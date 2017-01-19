/**
 * @file ecomeristem/plant/Model.cpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2017 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2017 ULCO http://www.univ-littoral.fr
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <model/models/ecomeristem/plant/Manager.hpp>
#include <model/models/ecomeristem/plant/Model.hpp>

#include <utils/DateTime.hpp>
#include <utils/Trace.hpp>

using namespace artis::kernel;

namespace ecomeristem { namespace plant {

Model::Model(const ecomeristem::AbstractModel* parent) :
    ecomeristem::AbstractCoupledModel < Model >(parent)
{
    // submodels
    S({ { ASSIMILATION, &assimilation_model },
            { ROOT, &root_model },
            { STOCK, &stock_model },
            { THERMAL_TIME, &thermal_time_model },
            { WATER_BALANCE, &water_balance_model },
            { MANAGER, &manager_model },
            { TILLER_MANAGER, &tiller_manager_model },
            { SLA, &sla_model } });

    // internals
    I({ { LAI, &assimilation_model, plant::assimilation::Model::LAI },
            { DELTA_T, &thermal_time_model,
                    plant::thermal_time::Model::DELTA_T },
            { BOOL_CROSSED_PLASTO, &thermal_time_model,
                    plant::thermal_time::Model::BOOL_CROSSED_PLASTO },
            { DD, &thermal_time_model, plant::thermal_time::Model::DD },
            { EDD, &thermal_time_model, plant::thermal_time::Model::EDD },
            { IH, &thermal_time_model, plant::thermal_time::Model::IH },
            { LIGULO_VISU, &thermal_time_model,
                    plant::thermal_time::Model::LIGULO_VISU },
            { PHENO_STAGE, &thermal_time_model,
                    plant::thermal_time::Model::PHENO_STAGE },
            { PLASTO_VISU, &thermal_time_model,
                    plant::thermal_time::Model::PLASTO_VISU },
            { TT, &thermal_time_model, plant::thermal_time::Model::TT },
            { TT_LIG, &thermal_time_model,
                    plant::thermal_time::Model::TT_LIG },
            { ASSIM, &assimilation_model,
                    plant::assimilation::Model::ASSIM },
            { CSTR, &water_balance_model,
                    plant::water_balance::Model::CSTR },
            { ROOT_DEMAND_COEF, &root_model, root::Model::ROOT_DEMAND_COEF },
            { ROOT_DEMAND, &root_model, root::Model::ROOT_DEMAND },
            { ROOT_BIOMASS, &root_model, root::Model::ROOT_BIOMASS },
                // { STOCK, &stock_model, stock::Model::STOCK },
            { GROW, &stock_model, stock::Model::GROW },
            { SUPPLY, &stock_model, stock::Model::SUPPLY },
            { DEFICIT, &stock_model, stock::Model::DEFICIT },
            { IC, &stock_model, stock::Model::IC },
            { SURPLUS, &stock_model, stock::Model::SURPLUS },
            { TEST_IC, &stock_model, stock::Model::TEST_IC },
            { DAY_DEMAND, &stock_model, stock::Model::DAY_DEMAND },
            { RESERVOIR_DISPO, &stock_model, stock::Model::RESERVOIR_DISPO },
            { SEED_RES, &stock_model, stock::Model::SEED_RES } });
    I < double>({ { LEAF_BIOMASS_SUM, &Model::_leaf_biomass_sum },
            { INTERNODE_BIOMASS_SUM, &Model::_internode_biomass_sum },
            { LEAF_LAST_DEMAND_SUM, &Model::_leaf_last_demand_sum },
            { INTERNODE_DEMAND_SUM, &Model::_internode_demand_sum },
            { LEAF_DEMAND_SUM, &Model::_leaf_demand_sum },
            { INTERNODE_LAST_DEMAND_SUM, &Model::_internode_last_demand_sum },
            { SENESC_DW_SUM, &Model::_senesc_dw_sum } });

    // externals
    E < double >({ { ETP, &Model::_etp },
            { P, &Model::_p },
            { RADIATION, &Model::_radiation },
            { TA, &Model::_ta },
            { WATER_SUPPLY, &Model::_water_supply } });
}

void Model::init(double t, const model::models::ModelParameters& parameters)
{
    assimilation_model.init(t, parameters);
    root_model.init(t, parameters);
    stock_model.init(t, parameters);
    thermal_time_model.init(t, parameters);
    water_balance_model.init(t, parameters);
    manager_model.init(t, parameters);
    tiller_manager_model.init(t, parameters);
    // lig_model.init(t, parameters);
    sla_model.init(t, parameters);

    culm::Model* meristem = new culm::Model(1);

    setsubmodel(CULMS, meristem);
    meristem->init(t, parameters);
    culm_models.push_back(meristem);

    _leaf_biomass_sum = 0;
    _leaf_demand_sum = 0;
    _leaf_last_demand_sum = 0;
    _internode_demand_sum = 0;
    _internode_last_demand_sum = 0;
    _internode_biomass_sum = 0;
    _leaf_blade_area_sum = 0;

    _nbleaf_enabling_tillering =
        parameters.get < double >("nb_leaf_enabling_tillering");
    _realocationCoeff = parameters.get < double >("realocationCoeff");
    _LL_BL = parameters.get < double >("LL_BL_init");

    _parameters = &parameters;

    _culm_index = -1;
    _leaf_index = -1;
    _begin = t;
}

void Model::compute(double t, bool /* update */)
{
    bool create = false;
    bool stable = true;

    _culm_is_computed = false;

    compute_manager(t);
    delete_leaf(t);
    if (not is_dead()) {
        compute_lig(t);
//    lig_model(t);
        do {
            if (not stable) {
                stable = true;
            }
            compute_assimilation(t);
            compute_water_balance(t);
            compute_thermal_time(t);
            compute_sla(t);
            compute_manager(t);
            compute_tiller(t);
            compute_culms(t);
            compute_lig(t);
            if (not create and
                (get_phase(t) == NEW_PHYTOMER or
                 get_phase(t) == NEW_PHYTOMER3)) {
                create = true;
                stable = false;
                create_phytomer(t);
            }

            compute_root(t);
            compute_stock(t);
            compute_manager(t);

            //TODO: refactor
            if (get_state(t) == plant::ELONG) {
                compute_culms(t);
            }
        } while (not stable or not assimilation_model.is_stable(t) or
                 not water_balance_model.is_stable(t) or
                 not thermal_time_model.is_stable(t) or
                 not sla_model.is_stable(t) or not manager_model.is_stable(t) or
                 not tiller_manager_model.is_stable(t) or
                 not culms_is_stable(t) or
                 not root_model.is_stable(t) or not stock_model.is_stable(t));

        search_deleted_leaf(t);
        compute_height(t);
    } else {
        _height = 0;
    }
}

void Model::compute_assimilation(double t)
{
    // TODO: strange !!!
    if (water_balance_model.is_computed(t, water_balance::Model::FCSTR)) {
        assimilation_model.put(
            t, assimilation::Model::FCSTR,
            water_balance_model.get < double, water_balance::Fcstr >(
                t, water_balance::Model::FCSTR));
        assimilation_model.put(
            t, assimilation::Model::CSTR,
            water_balance_model.get < double, water_balance::cstr >(
                t, water_balance::Model::CSTR));
    } else {
        assimilation_model.put(t, assimilation::Model::FCSTR, 0.);
        assimilation_model.put(t, assimilation::Model::CSTR, 0.);
    }
    if (_culm_is_computed) {
        assimilation_model.put(
            t, assimilation::Model::LEAF_BIOMASS, _leaf_biomass_sum);
        assimilation_model.put(
            t, assimilation::Model::INTERNODE_BIOMASS,
            _internode_biomass_sum);
        assimilation_model.put(
            t, assimilation::Model::PAI, _leaf_blade_area_sum);
    }
    assimilation_model.put(
        t, assimilation::Model::RADIATION, _radiation);
    assimilation_model.put(
        t, assimilation::Model::TA, _ta);
    assimilation_model(t);

#ifdef WITH_TRACE
    utils::Trace::trace()
        << utils::TraceElement("PLANT", t, artis::utils::COMPUTE)
        << "COMPUTE ASSIMILATION ";
    utils::Trace::trace().flush();
#endif
}

void Model::compute_culms(double t)
{
    std::vector < culm::Model* >::const_iterator it = culm_models.begin();
    double _predim_leaf_on_mainstem = 0;

    _leaf_biomass_sum = 0;
    _leaf_last_demand_sum = 0;
    _leaf_demand_sum = 0;
    _internode_last_demand_sum = 0;
    _internode_demand_sum = 0;
    _internode_biomass_sum = 0;
    _leaf_blade_area_sum = 0;
    _realloc_biomass_sum = 0;
    _senesc_dw_sum = 0;
    while (it != culm_models.end()) {
        (*it)->put(t, culm::Model::DD,
                   thermal_time_model.get < double, thermal_time::Dd >(
                       t, thermal_time::Model::DD));
        (*it)->put(t, culm::Model::DELTA_T,
                   thermal_time_model.get < double, thermal_time::DeltaT >(
                       t, thermal_time::Model::DELTA_T));
        (*it)->put(t, culm::Model::FTSW,
                   water_balance_model.get < double, water_balance::Ftsw >(
                       t, water_balance::Model::FTSW));
        (*it)->put(t, culm::Model::FCSTR,
                   water_balance_model.get < double, water_balance::Fcstr >(
                       t, water_balance::Model::FCSTR));
        (*it)->put(t, culm::Model::P, _p);
        (*it)->put(t, culm::Model::PHENO_STAGE,
                   thermal_time_model.get < double, thermal_time::PhenoStage >(
                       t, thermal_time::Model::PHENO_STAGE));
        (*it)->put(t, culm::Model::PREDIM_LEAF_ON_MAINSTEM,
                   _predim_leaf_on_mainstem);
        (*it)->put(t, culm::Model::SLA, sla_model.get < double >(t, Sla::SLA));
        // TODO: strange !!!
        if (stock_model.is_computed(t, stock::Model::GROW)) {
            (*it)->put(t, culm::Model::GROW,
                       stock_model.get < double, stock::Stock >(
                           t, stock::Model::GROW));
            (*it)->put(t, culm::Model::TEST_IC,
                       stock_model.get < double, stock::IndexCompetition >(
                           t, stock::Model::TEST_IC));
        } else {
            (*it)->put(t, culm::Model::GROW, 0.);
            (*it)->put(t, culm::Model::TEST_IC, 0.);
        }
        (*it)->put(t, culm::Model::PHASE, manager_model.get < double >(
                       t, Manager::PHASE));
        (*it)->put(t, culm::Model::STATE, manager_model.get < double >(
                       t, Manager::STATE));
        //TODO
        (*it)->put(t, culm::Model::STOP, 0.);
        (**it)(t);

        _leaf_biomass_sum += (*it)->get < double, culm::Model >(
            t, culm::Model::LEAF_BIOMASS_SUM);
        _leaf_last_demand_sum +=
            (*it)->get < double, culm::Model>(
                t, culm::Model::LEAF_LAST_DEMAND_SUM);
        _leaf_demand_sum += (*it)->get < double, culm::Model >(
            t, culm::Model::LEAF_DEMAND_SUM);
        _internode_last_demand_sum += (*it)->get < double, culm::Model >(
            t, culm::Model::INTERNODE_LAST_DEMAND_SUM);
        _internode_demand_sum += (*it)->get < double, culm::Model >(
            t, culm::Model::INTERNODE_DEMAND_SUM);
        _internode_biomass_sum += (*it)->get < double, culm::Model >(
            t, culm::Model::INTERNODE_BIOMASS_SUM);
        _leaf_blade_area_sum +=
            (*it)->get < double, culm::Model>(
                t, culm::Model::LEAF_BLADE_AREA_SUM);
        _realloc_biomass_sum +=
            (*it)->get < double, culm::Model>(
                t, culm::Model::REALLOC_BIOMASS_SUM);
        _senesc_dw_sum +=
            (*it)->get < double, culm::Model>(
                t, culm::Model::SENESC_DW_SUM);
        if (it == culm_models.begin()) {
            _predim_leaf_on_mainstem = (*it)->get < double, culm::Model>(
                t, culm::Model::LEAF_PREDIM);
        }
        ++it;
    }
    _culm_is_computed = true;

    // stock computations
    it = culm_models.begin();
    while (it != culm_models.end()) {
        (*it)->put(t, culm::Model::PLANT_BIOMASS_SUM,
                   _leaf_biomass_sum + _internode_biomass_sum);
        (*it)->put(t, culm::Model::PLANT_LEAF_BIOMASS_SUM,
                   _leaf_biomass_sum);
        (*it)->put(t, culm::Model::PLANT_BLADE_AREA_SUM,
                   _leaf_blade_area_sum);
        //TODO: strange !!!
        if (assimilation_model.is_computed(t, assimilation::Model::ASSIM)) {
            (*it)->put(t, culm::Model::ASSIM,
                       assimilation_model.get < double, assimilation::Assim >(
                           t, assimilation::Model::ASSIM));
        } else {
            (*it)->put(t, culm::Model::ASSIM, 0.);
        }
        (**it)(t);
        ++it;
    }


#ifdef WITH_TRACE
    utils::Trace::trace()
        << utils::TraceElement("PLANT", t, artis::utils::COMPUTE)
        << "COMPUTE CULMS "
        << " ; LeafBiomassSum = " << _leaf_biomass_sum
        << " ; LeafLastDemandSum = " << _leaf_last_demand_sum
        << " ; LeafDemandSum = " << _leaf_demand_sum
        << " ; InternodeLastDemandSum = " << _internode_last_demand_sum
        << " ; InternodeDemandSum = " << _internode_demand_sum
        << " ; InternodeBiomassSum = " << _internode_biomass_sum
        << " ; LeafBladeAreaSum = " << _leaf_blade_area_sum
        << " ; ReallocBiomassSum = " << _realloc_biomass_sum
        << " ; SenescDWSum = " << _senesc_dw_sum
        << " ; culm number = " << culm_models.size();
    utils::Trace::trace().flush();
#endif

}

void Model::compute_height(double t)
{
    int index;

    _height = 0;
    if (not culm_models.empty()) {
        _height += culm_models[0]->get < double, culm::Model >(
            t, culm::Model::INTERNODE_LEN_SUM);
        index = culm_models[0]->get_last_ligulated_leaf_index(t);
        if (index != -1) {
            _height += (1 - 1 / _LL_BL) * culm_models[0]->get_leaf_len(t,
                                                                       index);
        } else {
            index = culm_models[0]->get_first_alive_leaf_index(t);
            _height += (1 - 1 / _LL_BL) * culm_models[0]->get_leaf_len(t,
                                                                       index);
        }
    }

#ifdef WITH_TRACE
    utils::Trace::trace()
        << utils::TraceElement("PLANT", t, artis::utils::COMPUTE)
        << "COMPUTE HEIGHT "
        << " ; Height = " << _height;
    utils::Trace::trace().flush();
#endif

}

void Model::compute_lig(double t)
{
    if (culm_models[0]->is_computed(t, culm::Model::LIG)) {
        _lig = culm_models[0]->get < double, culm::Model >(t, culm::Model::LIG);
    }
}

void Model::compute_manager(double t)
{
    if (stock_model.is_computed(t, stock::Model::STOCK)) {
        manager_model.put(t, Manager::STOCK,
                          stock_model.get < double, stock::Stock >(
                              t, stock::Model::STOCK));
    }
    if (thermal_time_model.is_computed(t, thermal_time::Model::PHENO_STAGE)) {
        manager_model.put(
            t, Manager::PHENO_STAGE,
            thermal_time_model.get < double, thermal_time::PhenoStage >(
                t, thermal_time::Model::PHENO_STAGE));
    }
    if (thermal_time_model.is_computed(
            t, thermal_time::Model::BOOL_CROSSED_PLASTO)) {
        manager_model.put(
            t, Manager::BOOL_CROSSED_PLASTO,
            thermal_time_model.get < double, thermal_time::Dd >(
                t, thermal_time::Model::BOOL_CROSSED_PLASTO));
    }
    if (water_balance_model.is_computed(t, water_balance::Model::FTSW)) {
        manager_model.put(
            t, Manager::FTSW,
            water_balance_model.get < double, water_balance::Ftsw >(
                t, water_balance::Model::FTSW));
    }
    if (stock_model.is_computed(t, stock::Model::IC)) {
        manager_model.put(t, Manager::IC,
                          stock_model.get < double, stock::IndexCompetition >(
                              t, stock::Model::IC));
    }
}

void Model::compute_root(double t)
{
    double _culm_surplus_sum = 0;

    std::vector < culm::Model* >::const_iterator it =
        culm_models.begin();

    while (it != culm_models.end()) {
        if ((*it)->is_computed(t, culm::Model::CULM_STOCK)) {
            _culm_surplus_sum += (*it)->get < double, culm::Surplus >(
                t, culm::Model::CULM_SURPLUS_SUM);
        }
        ++it;
    }

    root_model.put(t, root::Model::P, _p);
    if (stock_model.is_computed(t, stock::Model::STOCK)) {
        root_model.put(t, root::Model::STOCK,
                       stock_model.get < double, stock::Stock >(
                           t, stock::Model::STOCK));
    }
    root_model.put(t, root::Model::CULM_SURPLUS_SUM, _culm_surplus_sum);
    root_model.put(t, root::Model::LEAF_DEMAND_SUM,
                   _leaf_demand_sum);
    root_model.put(t, root::Model::LEAF_LAST_DEMAND_SUM,
                   _leaf_last_demand_sum);
    root_model.put(t, root::Model::INTERNODE_DEMAND_SUM,
                   _internode_demand_sum);
    root_model.put(t, root::Model::INTERNODE_LAST_DEMAND_SUM,
                   _internode_last_demand_sum);
    if (stock_model.is_computed(t, stock::Model::GROW)) {
        root_model.put(t, root::Model::GROW,
                       stock_model.get < double, stock::Stock >(
                           t, stock::Model::GROW));
    }
    if (manager_model.is_computed(t, Manager::PHASE)) {
        root_model.put(t, root::Model::PHASE,
                       manager_model.get < double >(t, Manager::PHASE));
        root_model.put(t, root::Model::STATE,
                       manager_model.get < double >(t, Manager::STATE));
    }
    root_model(t);

    // TODO: est-ce un bug dans la version Delphi ?
    // if (get_state(t) == plant::ELONG) {
    // _demand_sum = _leaf_demand_sum + _internode_demand_sum +
    //     root_model.get < double >(t, root::Model::ROOT_DEMAND_1);
    // } else {
    _demand_sum = _leaf_demand_sum + _internode_demand_sum + get_root_demand(t);
    // }

#ifdef WITH_TRACE
    utils::Trace::trace()
        << utils::TraceElement("PLANT", t, artis::utils::COMPUTE)
        << "DemandSum = " << _demand_sum;
    utils::Trace::trace().flush();
#endif

}

void Model::compute_sla(double t)
{
    if (thermal_time_model.is_computed(t, thermal_time::Model::PHENO_STAGE)) {
        sla_model.put(
            t, Sla::PHENO_STAGE,
            thermal_time_model.get < double, thermal_time::PhenoStage >(
                t, thermal_time::Model::PHENO_STAGE));
        sla_model(t);
    }
}

void Model::compute_stock(double t)
{
    if (get_state(t) == plant::ELONG) {
        double _culm_stock_sum = 0;
        double _culm_deficit_sum = 0;

        std::vector < culm::Model* >::const_iterator it =
            culm_models.begin();

        while (it != culm_models.end()) {
            if ((*it)->is_computed(t, culm::Model::CULM_STOCK)) {
                _culm_stock_sum += (*it)->get < double, culm::Stock >(
                    t, culm::Model::CULM_STOCK);
                _culm_deficit_sum += (*it)->get < double, culm::Deficit >(
                    t, culm::Model::CULM_DEFICIT);
            }
            ++it;
        }
        // TODO: refactor
        if (assimilation_model.is_computed(t, assimilation::Model::ASSIM)) {
            stock_model.put(
                t, stock::Model::ASSIM,
                assimilation_model.get < double, assimilation::Assim >(
                    t, assimilation::Model::ASSIM));
        }
        if (manager_model.is_computed(t, Manager::PHASE)) {
            stock_model.put(t, stock::Model::PHASE,
                            manager_model.get < double >(t, Manager::PHASE));
        }
        stock_model.put(t, stock::Model::DEMAND_SUM,
                        _demand_sum);
        stock_model.put(t, stock::Model::LEAF_BIOMASS_SUM,
                        _leaf_biomass_sum);
        stock_model.put(t, stock::Model::LEAF_LAST_DEMAND_SUM,
                        _leaf_last_demand_sum);
        stock_model.put(t, stock::Model::INTERNODE_LAST_DEMAND_SUM,
                        _internode_last_demand_sum);
        stock_model.put(t, stock::Model::REALLOC_BIOMASS_SUM,
                        _realloc_biomass_sum);

        stock_model.put(t, stock::Model::STATE,
                        manager_model.get < double >(t, Manager::STATE));
        stock_model.put(t, stock::Model::CULM_STOCK,
                        _culm_stock_sum);
        stock_model.put(t, stock::Model::CULM_DEFICIT,
                        _culm_deficit_sum);
        stock_model.put(t, stock::Model::CULM_SURPLUS_SUM,
                        root_model.get < double, root::RootDemand >(
                            t, root::Model::SURPLUS));
        stock_model(t);
    } else {
        if (assimilation_model.is_computed(t, assimilation::Model::ASSIM)) {
            stock_model.put(
                t, stock::Model::ASSIM,
                assimilation_model.get < double, assimilation::Assim >(
                    t, assimilation::Model::ASSIM));
        }
        if (manager_model.is_computed(t, Manager::PHASE)) {
            stock_model.put(t, stock::Model::PHASE,
                            manager_model.get < double >(t, Manager::PHASE));
        }
        stock_model.put(t, stock::Model::DEMAND_SUM,
                        _demand_sum);
        stock_model.put(t, stock::Model::LEAF_BIOMASS_SUM,
                        _leaf_biomass_sum);
        stock_model.put(t, stock::Model::LEAF_LAST_DEMAND_SUM,
                        _leaf_last_demand_sum);
        stock_model.put(t, stock::Model::INTERNODE_LAST_DEMAND_SUM,
                        _internode_last_demand_sum);
        stock_model.put(t, stock::Model::REALLOC_BIOMASS_SUM,
                        _realloc_biomass_sum);
        //TODO
        stock_model.put(t, stock::Model::DELETED_LEAF_BIOMASS, 0.);
        stock_model.put(t, stock::Model::STATE, get_state(t));
        stock_model(t);
    }

    std::vector < culm::Model* >::const_iterator it = culm_models.begin();

    while (it != culm_models.end()) {
        (*it)->put(t, culm::Model::PLANT_STOCK, get_stock(t));
        (*it)->put(t, culm::Model::PLANT_DEFICIT, get_deficit(t));
        ++it;
    }
}

void Model::compute_thermal_time(double t)
{
    if (stock_model.is_computed(t, stock::Model::STOCK)) {
        thermal_time_model.put(
            t, thermal_time::Model::STOCK,
            stock_model.get < double, stock::Stock >(t, stock::Model::STOCK));
    }
    if (manager_model.is_computed(t, Manager::PHASE)) {
        thermal_time_model.put(t, thermal_time::Model::PHASE,
                               manager_model.get < double >(t, Manager::PHASE));
    }
    if (stock_model.is_computed(t, stock::Model::GROW)) {
        thermal_time_model.put(t, thermal_time::Model::GROW,
                               stock_model.get < double, stock::Stock >(
                                   t, stock::Model::GROW));
    }
    thermal_time_model.put(t, thermal_time::Model::TA, _ta);
    thermal_time_model.put(t, thermal_time::Model::LIG, _lig);
    // TODO
    thermal_time_model.put(t, thermal_time::Model::PLASTO_DELAY, 0.);
    thermal_time_model(t);
}

void Model::compute_tiller(double t)
{
    if (thermal_time_model.is_computed(
            t, thermal_time::Model::BOOL_CROSSED_PLASTO)) {
        tiller_manager_model.put(
            t, TillerManager::BOOL_CROSSED_PLASTO,
            thermal_time_model.get < double, thermal_time::Dd >(
                t, thermal_time::Model::BOOL_CROSSED_PLASTO));
    }
    if (thermal_time_model.is_computed(
            t, thermal_time::Model::PHENO_STAGE)) {
        tiller_manager_model.put(
            t, TillerManager::PHENO_STAGE,
            thermal_time_model.get < double, thermal_time::PhenoStage >(
                t, thermal_time::Model::PHENO_STAGE));
    }
    if (stock_model.is_computed(t, stock::Model::IC)) {
        tiller_manager_model.put(
            t, TillerManager::IC, stock_model.get < double,
            stock::IndexCompetition >(t, stock::Model::IC));
    }

    {
        int n = 0;

        for (unsigned int i = 0; i < culm_models.size(); ++i) {
            if (culm_models[i]->get_phytomer_number() >=
                _nbleaf_enabling_tillering) {
                ++n;
            }
        }
        tiller_manager_model.put(t, TillerManager::TAE, (double)n);
    }

    tiller_manager_model(t);

    if (tiller_manager_model.is_computed(t, TillerManager::NB_TILLERS)) {
        if (tiller_manager_model.get < double >(
                t, TillerManager::CREATE) > 0 and
            tiller_manager_model.get < double >(
                t, TillerManager::NB_TILLERS) > 0) {
            create_culm(t, tiller_manager_model.get < double >(
                            t, TillerManager::NB_TILLERS));
        }
    }
}

void Model::compute_water_balance(double t)
{
    if (assimilation_model.is_computed(t, assimilation::Model::INTERC)) {
        water_balance_model.put(
            t, water_balance::Model::INTERC,
            assimilation_model.get < double, assimilation::Interc >(
                t, assimilation::Model::INTERC));
    }
    water_balance_model.put(t, water_balance::Model::ETP, _etp);
    water_balance_model.put(t, water_balance::Model::WATER_SUPPLY,
                            _water_supply);
    water_balance_model(t);
}

void Model::create_culm(double t, int n)
{
    for (int i = 0; i < n; ++i) {
        culm::Model* culm = new culm::Model(culm_models.size() + 1);

        culm->init(t, *_parameters);
        culm_models.push_back(culm);
        setsubmodel(CULMS, culm);

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("PLANT", t, artis::utils::COMPUTE)
            << "CREATE CULM = " << culm_models.size()
            << " ; n = " << n;
        utils::Trace::trace().flush();
#endif

    }
}

void Model::create_phytomer(double t)
{
    std::vector < culm::Model* >::const_iterator it = culm_models.begin();

    while (it != culm_models.end()) {
        (*it)->create_phytomer(t);
        ++it;
    }
}

bool Model::culms_is_stable(double t)
{
    std::vector < culm::Model* >::const_iterator it = culm_models.begin();
    bool stable = true;

    while (it != culm_models.end() and stable) {
        stable = (*it)->is_stable(t);
        ++it;
    }
    return stable;
}

void Model::delete_leaf(double t)
{
    if (_culm_index != -1 and _leaf_index != -1) {

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("PLANT", t, artis::utils::COMPUTE)
            << "DELETE LEAF: culm index = " << _culm_index
            << " ; leaf index = " << _leaf_index;
        utils::Trace::trace().flush();
#endif

        culm_models[_culm_index]->delete_leaf(t, _leaf_index);

        std::vector < culm::Model* >::const_iterator it =
            culm_models.begin();

        while (it != culm_models.end()) {
            (*it)->realloc_biomass(t, _deleted_leaf_biomass);
            ++it;
        }
        stock_model.realloc_biomass(t, _deleted_leaf_biomass);
        _leaf_blade_area_sum -= _deleted_leaf_blade_area;
    } else {
        stock_model.realloc_biomass(t, 0);
    }
}

double Model::get_phase(double t) const
{
    return manager_model.is_computed(t, Manager::PHASE) ?
        manager_model.get < double >(t, Manager::PHASE) :
        (t == _begin ? (double)INITIAL : manager_model.get < double >(t - 1,
                                                           Manager::PHASE));
}

double Model::get_state(double t) const
{
    return manager_model.is_computed(t, Manager::STATE) ?
        manager_model.get < double >(t, Manager::STATE) :
        (t == _begin ? (double)VEGETATIVE : manager_model.get < double >(t - 1,
                                                              Manager::STATE));
}

double Model::get_deficit(double t) const
{
    return stock_model.is_computed(t, stock::Model::DEFICIT) ?
        stock_model.get < double, stock::Stock >(t, stock::Model::DEFICIT) :
        (t == _begin ? 0. : stock_model.get < double, stock::Stock >(
            t - 1, stock::Model::DEFICIT));
}

double Model::get_root_demand(double t) const
{
    return root_model.is_computed(t, root::Model::ROOT_DEMAND) ?
        root_model.get < double, root::RootDemand >(
            t, root::Model::ROOT_DEMAND) :
        (t == _begin ? 0. : root_model.get < double, root::RootDemand >(
            t, root::Model::ROOT_DEMAND));
}

double Model::get_stock(double t) const
{
    return stock_model.is_computed(t, stock::Model::STOCK) ?
        stock_model.get < double, stock::Stock >(t, stock::Model::STOCK) :
        (t == _begin ? 0. : stock_model.get < double, stock::Stock >(
            t - 1, stock::Model::STOCK));
}

void Model::search_deleted_leaf(double t)
{
    _culm_index = -1;
    _leaf_index = -1;
    _deleted_leaf_biomass = 0;
    _deleted_leaf_blade_area = 0;
    if (stock_model.get < double, stock::Stock >(t, stock::Model::STOCK) == 0) {
        std::vector < culm::Model* >::const_iterator it = culm_models.begin();
        int i = 0;

        while (it != culm_models.end() and
               (*it)->get_phytomer_number() == 0) {
            ++it;
            ++i;
        }
        if (it != culm_models.end()) {
            _culm_index = i;
            _leaf_index = (*it)->get_first_ligulated_leaf_index(t);
            if (_leaf_index != -1) {
                _deleted_leaf_biomass =
                    culm_models[_culm_index]->get_leaf_biomass(t, _leaf_index);
                _deleted_leaf_blade_area =
                    culm_models[_culm_index]->get_leaf_blade_area(t,
                                                                  _leaf_index);
            }
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("PLANT", t, artis::utils::COMPUTE)
            << "DELETE LEAF: "
            << " ; culm index = " << _culm_index
            << " ; leaf index = " << _leaf_index
            << " ; leaf biomass = " << _deleted_leaf_biomass
            << " ; culm number = " << culm_models.size();
        utils::Trace::trace().flush();
#endif

    }
}

} } // namespace ecomeristem plant

/**
 * @file ecomeristem/plant/Model.cpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2016 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2016 ULCO http://www.univ-littoral.fr
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

#include <model/models/ecomeristem/plant/PlantManager.hpp>
#include <model/models/ecomeristem/plant/PlantModel.hpp>

#include <utils/DateTime.hpp>
#include <utils/Trace.hpp>

using namespace artis::kernel;

namespace ecomeristem { namespace plant {

PlantModel::PlantModel(const ecomeristem::AbstractModel* parent) :
    ecomeristem::AbstractCoupledModel < PlantModel >(parent)
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
    I({ { LAI, &assimilation_model, plant::assimilation::PlantAssimilationModel::LAI },
            { DELTA_T, &thermal_time_model,
                    plant::thermal_time::ThermalTimeModel::DELTA_T },
            { BOOL_CROSSED_PLASTO, &thermal_time_model,
                    plant::thermal_time::ThermalTimeModel::BOOL_CROSSED_PLASTO },
            { DD, &thermal_time_model, plant::thermal_time::ThermalTimeModel::DD },
            { EDD, &thermal_time_model, plant::thermal_time::ThermalTimeModel::EDD },
            { IH, &thermal_time_model, plant::thermal_time::ThermalTimeModel::IH },
            { LIGULO_VISU, &thermal_time_model,
                    plant::thermal_time::ThermalTimeModel::LIGULO_VISU },
            { PHENO_STAGE, &thermal_time_model,
                    plant::thermal_time::ThermalTimeModel::PHENO_STAGE },
            { PLASTO_VISU, &thermal_time_model,
                    plant::thermal_time::ThermalTimeModel::PLASTO_VISU },
            { TT, &thermal_time_model, plant::thermal_time::ThermalTimeModel::TT },
            { TT_LIG, &thermal_time_model,
                    plant::thermal_time::ThermalTimeModel::TT_LIG },
            { ASSIM, &assimilation_model,
                    plant::assimilation::PlantAssimilationModel::ASSIM },
            { CSTR, &water_balance_model,
                    plant::water_balance::WaterBalanceModel::CSTR },
            { ROOT_DEMAND_COEF, &root_model, root::RootModel::ROOT_DEMAND_COEF },
            { ROOT_DEMAND, &root_model, root::RootModel::ROOT_DEMAND },
            { ROOT_BIOMASS, &root_model, root::RootModel::ROOT_BIOMASS },
                // { STOCK, &stock_model, stock::Model::STOCK },
            { GROW, &stock_model, stock::PlantStockModel::GROW },
            { SUPPLY, &stock_model, stock::PlantStockModel::SUPPLY },
            { DEFICIT, &stock_model, stock::PlantStockModel::DEFICIT },
            { IC, &stock_model, stock::PlantStockModel::IC },
            { SURPLUS, &stock_model, stock::PlantStockModel::SURPLUS },
            { TEST_IC, &stock_model, stock::PlantStockModel::TEST_IC },
            { DAY_DEMAND, &stock_model, stock::PlantStockModel::DAY_DEMAND },
            { RESERVOIR_DISPO, &stock_model, stock::PlantStockModel::RESERVOIR_DISPO },
            { SEED_RES, &stock_model, stock::PlantStockModel::SEED_RES } });
    I <double>({ { LEAF_BIOMASS_SUM, &PlantModel::_leaf_biomass_sum },
            { INTERNODE_BIOMASS_SUM, &PlantModel::_internode_biomass_sum },
            { LEAF_LAST_DEMAND_SUM, &PlantModel::_leaf_last_demand_sum },
            { INTERNODE_DEMAND_SUM, &PlantModel::_internode_demand_sum },
            { LEAF_DEMAND_SUM, &PlantModel::_leaf_demand_sum },
            { INTERNODE_LAST_DEMAND_SUM, &PlantModel::_internode_last_demand_sum },
            { SENESC_DW_SUM, &PlantModel::_senesc_dw_sum } });

    // externals
    E < double >({ { ETP, &PlantModel::_etp },
            { P, &PlantModel::_p },
            { RADIATION, &PlantModel::_radiation },
            { TA, &PlantModel::_ta },
            { WATER_SUPPLY, &PlantModel::_water_supply } });
}

void PlantModel::init(double t, const model::models::ModelParameters& parameters)
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

    culm::CulmModel* meristem = new culm::CulmModel(1);

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

void PlantModel::compute(double t, bool /* update */)
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

void PlantModel::compute_assimilation(double t)
{
    // TODO: strange !!!
    if (water_balance_model.is_computed(t, water_balance::WaterBalanceModel::FCSTR)) {
        assimilation_model.put(
            t, assimilation::PlantAssimilationModel::FCSTR,
            water_balance_model.get < double, water_balance::Fcstr >(
                t, water_balance::WaterBalanceModel::FCSTR));
        assimilation_model.put(
            t, assimilation::PlantAssimilationModel::CSTR,
            water_balance_model.get < double, water_balance::cstr >(
                t, water_balance::WaterBalanceModel::CSTR));
    } else {
        assimilation_model.put(t, assimilation::PlantAssimilationModel::FCSTR, 0.);
        assimilation_model.put(t, assimilation::PlantAssimilationModel::CSTR, 0.);
    }
    if (_culm_is_computed) {
        assimilation_model.put(
            t, assimilation::PlantAssimilationModel::LEAF_BIOMASS, _leaf_biomass_sum);
        assimilation_model.put(
            t, assimilation::PlantAssimilationModel::INTERNODE_BIOMASS,
            _internode_biomass_sum);
        assimilation_model.put(
            t, assimilation::PlantAssimilationModel::PAI, _leaf_blade_area_sum);
    }
    assimilation_model.put(
        t, assimilation::PlantAssimilationModel::RADIATION, _radiation);
    assimilation_model.put(
        t, assimilation::PlantAssimilationModel::TA, _ta);
    assimilation_model(t);

#ifdef WITH_TRACE
    utils::Trace::trace()
        << utils::TraceElement("PLANT", t, artis::utils::COMPUTE)
        << "COMPUTE ASSIMILATION ";
    utils::Trace::trace().flush();
#endif
}

void PlantModel::compute_culms(double t)
{
    std::vector < culm::CulmModel* >::const_iterator it = culm_models.begin();
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
        (*it)->put(t, culm::CulmModel::DD,
                   thermal_time_model.get < double, thermal_time::Dd >(
                       t, thermal_time::ThermalTimeModel::DD));
        (*it)->put(t, culm::CulmModel::DELTA_T,
                   thermal_time_model.get < double, thermal_time::DeltaT >(
                       t, thermal_time::ThermalTimeModel::DELTA_T));
        (*it)->put(t, culm::CulmModel::FTSW,
                   water_balance_model.get < double, water_balance::Ftsw >(
                       t, water_balance::WaterBalanceModel::FTSW));
        (*it)->put(t, culm::CulmModel::FCSTR,
                   water_balance_model.get < double, water_balance::Fcstr >(
                       t, water_balance::WaterBalanceModel::FCSTR));
        (*it)->put(t, culm::CulmModel::P, _p);
        (*it)->put(t, culm::CulmModel::PHENO_STAGE,
                   thermal_time_model.get < double, thermal_time::PhenoStage >(
                       t, thermal_time::ThermalTimeModel::PHENO_STAGE));
        (*it)->put(t, culm::CulmModel::PREDIM_LEAF_ON_MAINSTEM,
                   _predim_leaf_on_mainstem);
        (*it)->put(t, culm::CulmModel::SLA, sla_model.get < double >(t, Sla::SLA));
        // TODO: strange !!!
        if (stock_model.is_computed(t, stock::PlantStockModel::GROW)) {
            (*it)->put(t, culm::CulmModel::GROW,
                       stock_model.get < double, stock::PlantStock >(
                           t, stock::PlantStockModel::GROW));
            (*it)->put(t, culm::CulmModel::TEST_IC,
                       stock_model.get < double, stock::IndexCompetition >(
                           t, stock::PlantStockModel::TEST_IC));
        } else {
            (*it)->put(t, culm::CulmModel::GROW, 0.);
            (*it)->put(t, culm::CulmModel::TEST_IC, 0.);
        }
        (*it)->put(t, culm::CulmModel::PHASE, manager_model.get < double >(
                       t, PlantManager::PHASE));
        (*it)->put(t, culm::CulmModel::STATE, manager_model.get < double >(
                       t, PlantManager::STATE));
        //TODO
        (*it)->put(t, culm::CulmModel::STOP, 0.);
        (**it)(t);

        _leaf_biomass_sum += (*it)->get < double, culm::CulmModel >(
            t, culm::CulmModel::LEAF_BIOMASS_SUM);
        _leaf_last_demand_sum +=
            (*it)->get < double, culm::CulmModel>(
                t, culm::CulmModel::LEAF_LAST_DEMAND_SUM);
        _leaf_demand_sum += (*it)->get < double, culm::CulmModel >(
            t, culm::CulmModel::LEAF_DEMAND_SUM);
        _internode_last_demand_sum += (*it)->get < double, culm::CulmModel >(
            t, culm::CulmModel::INTERNODE_LAST_DEMAND_SUM);
        _internode_demand_sum += (*it)->get < double, culm::CulmModel >(
            t, culm::CulmModel::INTERNODE_DEMAND_SUM);
        _internode_biomass_sum += (*it)->get < double, culm::CulmModel >(
            t, culm::CulmModel::INTERNODE_BIOMASS_SUM);
        _leaf_blade_area_sum +=
            (*it)->get < double, culm::CulmModel>(
                t, culm::CulmModel::LEAF_BLADE_AREA_SUM);
        _realloc_biomass_sum +=
            (*it)->get < double, culm::CulmModel>(
                t, culm::CulmModel::REALLOC_BIOMASS_SUM);
        _senesc_dw_sum +=
            (*it)->get < double, culm::CulmModel>(
                t, culm::CulmModel::SENESC_DW_SUM);
        if (it == culm_models.begin()) {
            _predim_leaf_on_mainstem = (*it)->get < double, culm::CulmModel>(
                t, culm::CulmModel::LEAF_PREDIM);
        }
        ++it;
    }
    _culm_is_computed = true;

    // stock computations
    it = culm_models.begin();
    while (it != culm_models.end()) {
        (*it)->put(t, culm::CulmModel::PLANT_BIOMASS_SUM,
                   _leaf_biomass_sum + _internode_biomass_sum);
        (*it)->put(t, culm::CulmModel::PLANT_LEAF_BIOMASS_SUM,
                   _leaf_biomass_sum);
        (*it)->put(t, culm::CulmModel::PLANT_BLADE_AREA_SUM,
                   _leaf_blade_area_sum);
        //TODO: strange !!!
        if (assimilation_model.is_computed(t, assimilation::PlantAssimilationModel::ASSIM)) {
            (*it)->put(t, culm::CulmModel::ASSIM,
                       assimilation_model.get < double, assimilation::Assim >(
                           t, assimilation::PlantAssimilationModel::ASSIM));
        } else {
            (*it)->put(t, culm::CulmModel::ASSIM, 0.);
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

void PlantModel::compute_height(double t)
{
    int index;

    _height = 0;
    if (not culm_models.empty()) {
        _height += culm_models[0]->get < double, culm::CulmModel >(
            t, culm::CulmModel::INTERNODE_LEN_SUM);
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

void PlantModel::compute_lig(double t)
{
    if (culm_models[0]->is_computed(t, culm::CulmModel::LIG)) {
        _lig = culm_models[0]->get < double, culm::CulmModel >(t, culm::CulmModel::LIG);
    }
}

void PlantModel::compute_manager(double t)
{
    if (stock_model.is_computed(t, stock::PlantStockModel::STOCK)) {
        manager_model.put(t, PlantManager::STOCK,
                          stock_model.get < double, stock::PlantStock >(
                              t, stock::PlantStockModel::STOCK));
    }
    if (thermal_time_model.is_computed(t, thermal_time::ThermalTimeModel::PHENO_STAGE)) {
        manager_model.put(
            t, PlantManager::PHENO_STAGE,
            thermal_time_model.get < double, thermal_time::PhenoStage >(
                t, thermal_time::ThermalTimeModel::PHENO_STAGE));
    }
    if (thermal_time_model.is_computed(
            t, thermal_time::ThermalTimeModel::BOOL_CROSSED_PLASTO)) {
        manager_model.put(
            t, PlantManager::BOOL_CROSSED_PLASTO,
            thermal_time_model.get < double, thermal_time::Dd >(
                t, thermal_time::ThermalTimeModel::BOOL_CROSSED_PLASTO));
    }
    if (water_balance_model.is_computed(t, water_balance::WaterBalanceModel::FTSW)) {
        manager_model.put(
            t, PlantManager::FTSW,
            water_balance_model.get < double, water_balance::Ftsw >(
                t, water_balance::WaterBalanceModel::FTSW));
    }
    if (stock_model.is_computed(t, stock::PlantStockModel::IC)) {
        manager_model.put(t, PlantManager::IC,
                          stock_model.get < double, stock::IndexCompetition >(
                              t, stock::PlantStockModel::IC));
    }
}

void PlantModel::compute_root(double t)
{
    double _culm_surplus_sum = 0;

    std::vector < culm::CulmModel* >::const_iterator it =
        culm_models.begin();

    while (it != culm_models.end()) {
        if ((*it)->is_computed(t, culm::CulmModel::CULM_STOCK)) {
            _culm_surplus_sum += (*it)->get < double, culm::CulmSurplus >(
                t, culm::CulmModel::CULM_SURPLUS_SUM);
        }
        ++it;
    }

    root_model.put(t, root::RootModel::P, _p);
    if (stock_model.is_computed(t, stock::PlantStockModel::STOCK)) {
        root_model.put(t, root::RootModel::STOCK,
                       stock_model.get < double, stock::PlantStock >(
                           t, stock::PlantStockModel::STOCK));
    }
    root_model.put(t, root::RootModel::CULM_SURPLUS_SUM, _culm_surplus_sum);
    root_model.put(t, root::RootModel::LEAF_DEMAND_SUM,
                   _leaf_demand_sum);
    root_model.put(t, root::RootModel::LEAF_LAST_DEMAND_SUM,
                   _leaf_last_demand_sum);
    root_model.put(t, root::RootModel::INTERNODE_DEMAND_SUM,
                   _internode_demand_sum);
    root_model.put(t, root::RootModel::INTERNODE_LAST_DEMAND_SUM,
                   _internode_last_demand_sum);
    if (stock_model.is_computed(t, stock::PlantStockModel::GROW)) {
        root_model.put(t, root::RootModel::GROW,
                       stock_model.get < double, stock::PlantStock >(
                           t, stock::PlantStockModel::GROW));
    }
    if (manager_model.is_computed(t, PlantManager::PHASE)) {
        root_model.put(t, root::RootModel::PHASE,
                       manager_model.get < double >(t, PlantManager::PHASE));
        root_model.put(t, root::RootModel::STATE,
                       manager_model.get < double >(t, PlantManager::STATE));
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

void PlantModel::compute_sla(double t)
{
    if (thermal_time_model.is_computed(t, thermal_time::ThermalTimeModel::PHENO_STAGE)) {
        sla_model.put(
            t, Sla::PHENO_STAGE,
            thermal_time_model.get < double, thermal_time::PhenoStage >(
                t, thermal_time::ThermalTimeModel::PHENO_STAGE));
        sla_model(t);
    }
}

void PlantModel::compute_stock(double t)
{
    if (get_state(t) == plant::ELONG) {
        double _culm_stock_sum = 0;
        double _culm_deficit_sum = 0;

        std::vector < culm::CulmModel* >::const_iterator it =
            culm_models.begin();

        while (it != culm_models.end()) {
            if ((*it)->is_computed(t, culm::CulmModel::CULM_STOCK)) {
                _culm_stock_sum += (*it)->get < double, culm::CulmStock >(
                    t, culm::CulmModel::CULM_STOCK);
                _culm_deficit_sum += (*it)->get < double, culm::Deficit >(
                    t, culm::CulmModel::CULM_DEFICIT);
            }
            ++it;
        }
        // TODO: refactor
        if (assimilation_model.is_computed(t, assimilation::PlantAssimilationModel::ASSIM)) {
            stock_model.put(
                t, stock::PlantStockModel::ASSIM,
                assimilation_model.get < double, assimilation::Assim >(
                    t, assimilation::PlantAssimilationModel::ASSIM));
        }
        if (manager_model.is_computed(t, PlantManager::PHASE)) {
            stock_model.put(t, stock::PlantStockModel::PHASE,
                            manager_model.get < double >(t, PlantManager::PHASE));
        }
        stock_model.put(t, stock::PlantStockModel::DEMAND_SUM,
                        _demand_sum);
        stock_model.put(t, stock::PlantStockModel::LEAF_BIOMASS_SUM,
                        _leaf_biomass_sum);
        stock_model.put(t, stock::PlantStockModel::LEAF_LAST_DEMAND_SUM,
                        _leaf_last_demand_sum);
        stock_model.put(t, stock::PlantStockModel::INTERNODE_LAST_DEMAND_SUM,
                        _internode_last_demand_sum);
        stock_model.put(t, stock::PlantStockModel::REALLOC_BIOMASS_SUM,
                        _realloc_biomass_sum);

        stock_model.put(t, stock::PlantStockModel::STATE,
                        manager_model.get < double >(t, PlantManager::STATE));
        stock_model.put(t, stock::PlantStockModel::CULM_STOCK,
                        _culm_stock_sum);
        stock_model.put(t, stock::PlantStockModel::CULM_DEFICIT,
                        _culm_deficit_sum);
        stock_model.put(t, stock::PlantStockModel::CULM_SURPLUS_SUM,
                        root_model.get < double, root::RootDemand >(
                            t, root::RootModel::SURPLUS));
        stock_model(t);
    } else {
        if (assimilation_model.is_computed(t, assimilation::PlantAssimilationModel::ASSIM)) {
            stock_model.put(
                t, stock::PlantStockModel::ASSIM,
                assimilation_model.get < double, assimilation::Assim >(
                    t, assimilation::PlantAssimilationModel::ASSIM));
        }
        if (manager_model.is_computed(t, PlantManager::PHASE)) {
            stock_model.put(t, stock::PlantStockModel::PHASE,
                            manager_model.get < double >(t, PlantManager::PHASE));
        }
        stock_model.put(t, stock::PlantStockModel::DEMAND_SUM,
                        _demand_sum);
        stock_model.put(t, stock::PlantStockModel::LEAF_BIOMASS_SUM,
                        _leaf_biomass_sum);
        stock_model.put(t, stock::PlantStockModel::LEAF_LAST_DEMAND_SUM,
                        _leaf_last_demand_sum);
        stock_model.put(t, stock::PlantStockModel::INTERNODE_LAST_DEMAND_SUM,
                        _internode_last_demand_sum);
        stock_model.put(t, stock::PlantStockModel::REALLOC_BIOMASS_SUM,
                        _realloc_biomass_sum);
        //TODO
        stock_model.put(t, stock::PlantStockModel::DELETED_LEAF_BIOMASS, 0.);
        stock_model.put(t, stock::PlantStockModel::STATE, get_state(t));
        stock_model(t);
    }

    std::vector < culm::CulmModel* >::const_iterator it = culm_models.begin();

    while (it != culm_models.end()) {
        (*it)->put(t, culm::CulmModel::PLANT_STOCK, get_stock(t));
        (*it)->put(t, culm::CulmModel::PLANT_DEFICIT, get_deficit(t));
        ++it;
    }
}

void PlantModel::compute_thermal_time(double t)
{
    if (stock_model.is_computed(t, stock::PlantStockModel::STOCK)) {
        thermal_time_model.put(
            t, thermal_time::ThermalTimeModel::STOCK,
            stock_model.get < double, stock::PlantStock >(t, stock::PlantStockModel::STOCK));
    }
    if (manager_model.is_computed(t, PlantManager::PHASE)) {
        thermal_time_model.put(t, thermal_time::ThermalTimeModel::PHASE,
                               manager_model.get < double >(t, PlantManager::PHASE));
    }
    if (stock_model.is_computed(t, stock::PlantStockModel::GROW)) {
        thermal_time_model.put(t, thermal_time::ThermalTimeModel::GROW,
                               stock_model.get < double, stock::PlantStock >(
                                   t, stock::PlantStockModel::GROW));
    }
    thermal_time_model.put(t, thermal_time::ThermalTimeModel::TA, _ta);
    thermal_time_model.put(t, thermal_time::ThermalTimeModel::LIG, _lig);
    // TODO
    thermal_time_model.put(t, thermal_time::ThermalTimeModel::PLASTO_DELAY, 0.);
    thermal_time_model(t);
}

void PlantModel::compute_tiller(double t)
{
    if (thermal_time_model.is_computed(
            t, thermal_time::ThermalTimeModel::BOOL_CROSSED_PLASTO)) {
        tiller_manager_model.put(
            t, TillerManager::BOOL_CROSSED_PLASTO,
            thermal_time_model.get < double, thermal_time::Dd >(
                t, thermal_time::ThermalTimeModel::BOOL_CROSSED_PLASTO));
    }
    if (thermal_time_model.is_computed(
            t, thermal_time::ThermalTimeModel::PHENO_STAGE)) {
        tiller_manager_model.put(
            t, TillerManager::PHENO_STAGE,
            thermal_time_model.get < double, thermal_time::PhenoStage >(
                t, thermal_time::ThermalTimeModel::PHENO_STAGE));
    }
    if (stock_model.is_computed(t, stock::PlantStockModel::IC)) {
        tiller_manager_model.put(
            t, TillerManager::IC, stock_model.get < double,
            stock::IndexCompetition >(t, stock::PlantStockModel::IC));
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

void PlantModel::compute_water_balance(double t)
{
    if (assimilation_model.is_computed(t, assimilation::PlantAssimilationModel::INTERC)) {
        water_balance_model.put(
            t, water_balance::WaterBalanceModel::INTERC,
            assimilation_model.get < double, assimilation::Interc >(
                t, assimilation::PlantAssimilationModel::INTERC));
    }
    water_balance_model.put(t, water_balance::WaterBalanceModel::ETP, _etp);
    water_balance_model.put(t, water_balance::WaterBalanceModel::WATER_SUPPLY,
                            _water_supply);
    water_balance_model(t);
}

void PlantModel::create_culm(double t, int n)
{
    for (int i = 0; i < n; ++i) {
        culm::CulmModel* culm = new culm::CulmModel(culm_models.size() + 1);

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

void PlantModel::create_phytomer(double t)
{
    std::vector < culm::CulmModel* >::const_iterator it = culm_models.begin();

    while (it != culm_models.end()) {
        (*it)->create_phytomer(t);
        ++it;
    }
}

bool PlantModel::culms_is_stable(double t)
{
    std::vector < culm::CulmModel* >::const_iterator it = culm_models.begin();
    bool stable = true;

    while (it != culm_models.end() and stable) {
        stable = (*it)->is_stable(t);
        ++it;
    }
    return stable;
}

void PlantModel::delete_leaf(double t)
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

        std::vector < culm::CulmModel* >::const_iterator it =
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

double PlantModel::get_phase(double t) const
{
    return manager_model.is_computed(t, PlantManager::PHASE) ?
        manager_model.get < double >(t, PlantManager::PHASE) :
        (t == _begin ? (double)INITIAL : manager_model.get < double >(t - 1,
                                                           PlantManager::PHASE));
}

double PlantModel::get_state(double t) const
{
    return manager_model.is_computed(t, PlantManager::STATE) ?
        manager_model.get < double >(t, PlantManager::STATE) :
        (t == _begin ? (double)VEGETATIVE : manager_model.get < double >(t - 1,
                                                              PlantManager::STATE));
}

double PlantModel::get_deficit(double t) const
{
    return stock_model.is_computed(t, stock::PlantStockModel::DEFICIT) ?
        stock_model.get < double, stock::PlantStock >(t, stock::PlantStockModel::DEFICIT) :
        (t == _begin ? 0. : stock_model.get < double, stock::PlantStock >(
            t - 1, stock::PlantStockModel::DEFICIT));
}

double PlantModel::get_root_demand(double t) const
{
    return root_model.is_computed(t, root::RootModel::ROOT_DEMAND) ?
        root_model.get < double, root::RootDemand >(
            t, root::RootModel::ROOT_DEMAND) :
        (t == _begin ? 0. : root_model.get < double, root::RootDemand >(
            t, root::RootModel::ROOT_DEMAND));
}

double PlantModel::get_stock(double t) const
{
    return stock_model.is_computed(t, stock::PlantStockModel::STOCK) ?
        stock_model.get < double, stock::PlantStock >(t, stock::PlantStockModel::STOCK) :
        (t == _begin ? 0. : stock_model.get < double, stock::PlantStock >(
            t - 1, stock::PlantStockModel::STOCK));
}

void PlantModel::search_deleted_leaf(double t)
{
    _culm_index = -1;
    _leaf_index = -1;
    _deleted_leaf_biomass = 0;
    _deleted_leaf_blade_area = 0;
    if (stock_model.get < double, stock::PlantStock >(t, stock::PlantStockModel::STOCK) == 0) {
        std::vector < culm::CulmModel* >::const_iterator it = culm_models.begin();
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

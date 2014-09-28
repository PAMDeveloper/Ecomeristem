/**
 * @file ecomeristem/plant/Model.cpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2014 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2014 ULCO http://www.univ-littoral.fr
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

#include <model/models/ecomeristem/plant/Model.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant {

Model::Model()
{
    internal(LAI, &assimilation_model, plant::assimilation::Model::LAI);
    internal(DELTA_T, &thermal_time_model,
             plant::thermal_time::Model::DELTA_T);
    internal(BOOL_CROSSED_PLASTO, &thermal_time_model,
             plant::thermal_time::Model::BOOL_CROSSED_PLASTO);
    internal(DD, &thermal_time_model, plant::thermal_time::Model::DD);
    internal(EDD, &thermal_time_model, plant::thermal_time::Model::EDD);
    internal(IH, &thermal_time_model, plant::thermal_time::Model::IH);
    internal(LIGULO_VISU, &thermal_time_model,
             plant::thermal_time::Model::LIGULO_VISU);
    internal(PHENO_STAGE, &thermal_time_model,
             plant::thermal_time::Model::PHENO_STAGE);
    internal(PLASTO_VISU, &thermal_time_model,
             plant::thermal_time::Model::PLASTO_VISU);
    internal(TT, &thermal_time_model, plant::thermal_time::Model::TT);
    internal(TT_LIG, &thermal_time_model,
             plant::thermal_time::Model::TT_LIG);
    internal(ASSIM, &assimilation_model,
             plant::assimilation::Model::ASSIM);
    internal(CSTR, &water_balance_model,
             plant::water_balance::Model::CSTR);
    internal(ROOT_DEMAND_COEF, &root_model, root::Model::ROOT_DEMAND_COEF);
    internal(ROOT_DEMAND, &root_model, root::Model::ROOT_DEMAND);
    internal(ROOT_BIOMASS, &root_model, root::Model::ROOT_BIOMASS);
    internal(STOCK, &stock_model, stock::Model::STOCK);
    internal(GROW, &stock_model, stock::Model::GROW);
    internal(SUPPLY, &stock_model, stock::Model::SUPPLY);
    internal(DEFICIT, &stock_model, stock::Model::DEFICIT);
    internal(IC, &stock_model, stock::Model::IC);
    internal(SURPLUS, &stock_model, stock::Model::SURPLUS);
    internal(TEST_IC, &stock_model, stock::Model::TEST_IC);
    internal(DAY_DEMAND, &stock_model, stock::Model::DAY_DEMAND);
    internal(RESERVOIR_DISPO, &stock_model, stock::Model::RESERVOIR_DISPO);
    internal(SEED_RES, &stock_model, stock::Model::SEED_RES);

    external(ETP, &Model::_etp);
    external(P, &Model::_p);
    external(RADIATION, &Model::_radiation);
    external(TA, &Model::_ta);
    external(WATER_SUPPLY, &Model::_water_supply);
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
    lig_model.init(t, parameters);
    sla_model.init(t, parameters);

    culm::Model* meristem = new culm::Model(1);

    meristem->init(t, parameters);
    culm_models.push_back(meristem);

    _leaf_biomass_sum = 0;
    _leaf_last_demand_sum = 0;
    _leaf_demand_sum = 0;
    _leaf_blade_area_sum = 0;
}

void Model::compute(double t, bool /* update */)
{
    bool create = false;

    _culm_is_computed = false;
    lig_model(t);
    do {
        compute_assimilation(t);
        compute_water_balance(t);
        compute_thermal_time(t);
        compute_sla(t);
        compute_manager(t);
        compute_tiller(t);
        compute_culms(t);
        compute_root(t);
        compute_stock(t);
        compute_manager(t);
        if (not create and
            (manager_model.get(t, Manager::PHASE) == NEW_PHYTOMER or
             manager_model.get(t, Manager::PHASE) == NEW_PHYTOMER3)) {
            create = true;
            create_phytomer(t);
        }
    } while (not assimilation_model.is_stable(t) or
             not water_balance_model.is_stable(t) or
             not thermal_time_model.is_stable(t) or
             not sla_model.is_stable(t) or not manager_model.is_stable(t) or
             not tiller_manager_model.is_stable(t) or not culms_is_stable(t) or
             not root_model.is_stable(t) or not stock_model.is_stable(t));
}

void Model::compute_assimilation(double t)
{
    if (water_balance_model.is_computed(t, water_balance::Model::FCSTR)) {
        assimilation_model.put(t, assimilation::Model::FCSTR,
                               water_balance_model.get(t,
                                   water_balance::Model::FCSTR));
    };
    //TODO
    assimilation_model.put(t, assimilation::Model::INTERNODE_BIOMASS, 0);
    if (_culm_is_computed) {
        assimilation_model.put(t, assimilation::Model::LEAF_BIOMASS,
                               _leaf_biomass_sum);
        assimilation_model.put(t, assimilation::Model::PAI,
                               _leaf_blade_area_sum);
    }
    assimilation_model.put(t,
                           assimilation::Model::RADIATION, _radiation);
    assimilation_model.put(t, assimilation::Model::TA, _ta);
    if (water_balance_model.is_computed(t, water_balance::Model::CSTR)) {
        assimilation_model.put(t, assimilation::Model::CSTR,
                               water_balance_model.get(t,
                                   water_balance::Model::CSTR));
    }
    assimilation_model(t);
}

void Model::compute_culms(double t)
{
    std::vector < culm::Model* >::const_iterator it = culm_models.begin();
    double _predim_leaf_on_mainstem = (*it)->get(t, culm::Model::LEAF_PREDIM);

    _leaf_biomass_sum = 0;
    _leaf_last_demand_sum = 0;
    _leaf_demand_sum = 0;
    _leaf_blade_area_sum = 0;
    while (it != culm_models.end()) {
        if (thermal_time_model.is_computed(t, thermal_time::Model::DD)) {
            (*it)->put(t, culm::Model::DD,
                       thermal_time_model.get(
                           t, thermal_time::Model::DD));
        }
        if (thermal_time_model.is_computed(t, thermal_time::Model::DELTA_T)) {
            (*it)->put(t, culm::Model::DELTA_T,
                       thermal_time_model.get(
                           t, thermal_time::Model::DELTA_T));
        }
        if (water_balance_model.is_computed(t, water_balance::Model::FTSW)) {
            (*it)->put(t, culm::Model::FTSW,
                       water_balance_model.get(
                           t, water_balance::Model::FTSW));
        }
        if (water_balance_model.is_computed(t, water_balance::Model::FCSTR)) {
            (*it)->put(t, culm::Model::FCSTR,
                       water_balance_model.get(
                           t, water_balance::Model::FCSTR));
        }
        (*it)->put(t, culm::Model::P, _p);
        if (thermal_time_model.is_computed(
                t, thermal_time::Model::PHENO_STAGE)) {
            (*it)->put(t, culm::Model::PHENO_STAGE,
                       thermal_time_model.get(
                           t, thermal_time::Model::PHENO_STAGE));
        }
        (*it)->put(t, culm::Model::PREDIM_LEAF_ON_MAINSTEM,
                   _predim_leaf_on_mainstem);
        (*it)->put(t, culm::Model::SLA, sla_model.get(t, Sla::SLA));
        if (stock_model.is_computed(t, stock::Model::GROW)) {
            (*it)->put(t, culm::Model::GROW,
                       stock_model.get(t, stock::Model::GROW));
        }
        if (manager_model.is_computed(t, Manager::PHASE)) {
            (*it)->put(t, culm::Model::PHASE,
                       manager_model.get(t, Manager::PHASE));
        }
        //TODO
        (*it)->put(t, culm::Model::STOP, 0);
        if (stock_model.is_computed(t, stock::Model::TEST_IC)) {
            (*it)->put(t, culm::Model::TEST_IC,
                       stock_model.get(t, stock::Model::TEST_IC));
        }
        (**it)(t);

        _leaf_biomass_sum += (*it)->get(t, culm::Model::LEAF_BIOMASS_SUM);
        _leaf_last_demand_sum +=
            (*it)->get(t, culm::Model::LEAF_LAST_DEMAND_SUM);
        _leaf_demand_sum += (*it)->get(t, culm::Model::LEAF_DEMAND_SUM);
        _leaf_blade_area_sum +=
            (*it)->get(t, culm::Model::LEAF_BLADE_AREA_SUM);

        ++it;
    }
    _culm_is_computed = true;

#ifdef WITH_TRACE
    utils::Trace::trace()
        << utils::TraceElement("PLANT", t, utils::COMPUTE)
        << "LeafBiomassSum = " << _leaf_biomass_sum
        << " ; LeafLastDemandSum = " << _leaf_last_demand_sum
        << " ; LeafDemandSum = " << _leaf_demand_sum
        << " ; LeafBlaseAreaSum = " << _leaf_blade_area_sum;
    utils::Trace::trace().flush();
#endif

}

void Model::compute_manager(double t)
{
    if (stock_model.is_computed(t, stock::Model::STOCK)) {
        manager_model.put(t, Manager::STOCK,
                          stock_model.get(t, stock::Model::STOCK));
    }
    if (thermal_time_model.is_computed(t, thermal_time::Model::PHENO_STAGE)) {
        manager_model.put(t, Manager::PHENO_STAGE, thermal_time_model.get(
                              t, thermal_time::Model::PHENO_STAGE));
    }
    if (thermal_time_model.is_computed(
            t, thermal_time::Model::BOOL_CROSSED_PLASTO)) {
        manager_model.put(
            t, Manager::BOOL_CROSSED_PLASTO,
            thermal_time_model.get(t,
                                   thermal_time::Model::BOOL_CROSSED_PLASTO));
    }
    if (water_balance_model.is_computed(t, water_balance::Model::FTSW)) {
        manager_model.put(
            t, Manager::FTSW,
            water_balance_model.get(t, water_balance::Model::FTSW));
    }
    if (stock_model.is_computed(t, stock::Model::IC)) {
        manager_model.put(t, Manager::IC,
                          stock_model.get(t, stock::Model::IC));
    }
}

void Model::compute_root(double t)
{
    root_model.put(t, root::Model::P, _p);
    if (stock_model.is_computed(t, stock::Model::STOCK)) {
        root_model.put(t, root::Model::STOCK,
                       stock_model.get(t, stock::Model::STOCK));
    }
    root_model.put(t, root::Model::LEAF_DEMAND_SUM,
                   _leaf_demand_sum);
    if (stock_model.is_computed(t, stock::Model::GROW)) {
        root_model.put(t, root::Model::GROW,
                       stock_model.get(t, stock::Model::GROW));
    }
    if (manager_model.is_computed(t, Manager::PHASE)) {
        root_model.put(t, root::Model::PHASE,
                       manager_model.get(t, Manager::PHASE));
    }
    root_model(t);

    _demand_sum = _leaf_demand_sum +
        root_model.get(t, root::Model::ROOT_DEMAND);

#ifdef WITH_TRACE
    utils::Trace::trace()
        << utils::TraceElement("PLANT", t, utils::COMPUTE)
        << "DemandSum = " << _demand_sum;
    utils::Trace::trace().flush();
#endif

}

void Model::compute_sla(double t)
{
    if (thermal_time_model.is_computed(t, thermal_time::Model::PHENO_STAGE)) {
        sla_model.put(t, Sla::PHENO_STAGE, thermal_time_model.get(t,
                          thermal_time::Model::PHENO_STAGE));
        sla_model(t);
    }
}

void Model::compute_stock(double t)
{
    if (assimilation_model.is_computed(t, assimilation::Model::ASSIM)) {
        stock_model.put(t, stock::Model::ASSIM,
                        assimilation_model.get(t, assimilation::Model::ASSIM));
    }
    if (manager_model.is_computed(t, Manager::PHASE)) {
        stock_model.put(t, stock::Model::PHASE,
                        manager_model.get(t, Manager::PHASE));
    }
    stock_model.put(t, stock::Model::DEMAND_SUM,
                    _demand_sum);
    stock_model.put(t, stock::Model::LEAF_BIOMASS_SUM,
                    _leaf_biomass_sum);
    stock_model.put(t, stock::Model::LEAF_LAST_DEMAND_SUM,
                    _leaf_last_demand_sum);
    //TODO
    stock_model.put(t, stock::Model::DELETED_LEAF_BIOMASS, 0);
    stock_model(t);
}

void Model::compute_thermal_time(double t)
{
    if (stock_model.is_computed(t, stock::Model::STOCK)) {
        thermal_time_model.put(t, thermal_time::Model::STOCK,
                               stock_model.get(t, stock::Model::STOCK));
    }
    if (stock_model.is_computed(t, stock::Model::GROW)) {
        thermal_time_model.put(t, thermal_time::Model::GROW,
                               stock_model.get(t, stock::Model::GROW));
    }
    thermal_time_model.put(t, thermal_time::Model::TA, _ta);
    thermal_time_model.put(t, thermal_time::Model::LIG,
                           lig_model.get(t, Lig::LIG));
    // TODO
    thermal_time_model.put(t, thermal_time::Model::PLASTO_DELAY, 0);
    thermal_time_model(t);
}

void Model::compute_tiller(double t)
{
    if (thermal_time_model.is_computed(
            t, thermal_time::Model::BOOL_CROSSED_PLASTO)) {
        tiller_manager_model.put(
            t, TillerManager::BOOL_CROSSED_PLASTO,
            thermal_time_model.get(
                t, thermal_time::Model::BOOL_CROSSED_PLASTO));
    }
    if (thermal_time_model.get(
            t, thermal_time::Model::PHENO_STAGE)) {
        tiller_manager_model.put(
            t, TillerManager::PHENO_STAGE,
            thermal_time_model.get(
                t, thermal_time::Model::PHENO_STAGE));
    }
    if (stock_model.is_computed(t, stock::Model::IC)) {
        tiller_manager_model.put(t, TillerManager::IC,
                                 stock_model.get(t, stock::Model::IC));
    }
    tiller_manager_model(t);
}

void Model::compute_water_balance(double t)
{
    if (assimilation_model.is_computed(t, assimilation::Model::INTERC)) {
        water_balance_model.put(t, water_balance::Model::INTERC,
                                assimilation_model.get(t,
                                    assimilation::Model::INTERC));
    }
    water_balance_model.put(t, water_balance::Model::ETP, _etp);
    water_balance_model.put(t, water_balance::Model::WATER_SUPPLY,
                            _water_supply);
    water_balance_model(t);
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

} } // namespace ecomeristem plant

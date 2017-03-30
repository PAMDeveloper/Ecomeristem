/**
 * @file ecomeristem/leaf/Model.cpp
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

#include <model/models/ecomeristem/leaf/LeafModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

LeafModel::LeafModel(int index, bool is_on_mainstem) :
    _index(index),
    _is_first_leaf(_index == 1), _is_on_mainstem(is_on_mainstem),
    biomass_model(index),
    exp_time_model(_is_first_leaf, _is_on_mainstem),
    len_model(index),
    predim_model(index, _is_first_leaf, _is_on_mainstem),
    blade_area_model(index),
    ler_model(index),
    leaf_demand_model(index),
    manager_model(index),
    life_span_model(index),
    thermal_time_since_ligulation_model(index)
{
    // submodels
    S({ { TIME_FROM_APP, &time_from_app_model },
        { BIOMASS_, &biomass_model },
        { EXP_TIME, &exp_time_model },
        { LEN_, &len_model },
        { PREDIM_, &predim_model },
        { WIDTH, &width_model },
        { BLADE_AREA_, &blade_area_model },
        { LAST_DEMAND_, &last_demand_model },
        { LER, &ler_model },
        { REDUCTION_LER, &reduction_ler_model },
        { DEMAND_, &leaf_demand_model },
        { MANAGER, &manager_model },
        { PLASTO_DELAY_, &plasto_delay_model },
        { LIFE_SPAN, &life_span_model },
        { THERMAL_TIME_SINCE_LIGULATION, &thermal_time_since_ligulation_model }
        });

    I({ { BIOMASS, &biomass_model, LeafBiomass::BIOMASS },
            { BLADE_AREA, &blade_area_model, BladeArea::BLADE_AREA },
            { DEMAND, &leaf_demand_model, LeafDemand::DEMAND },
            { LAST_DEMAND, &last_demand_model, LeafLastDemand::LAST_DEMAND },
            { PREDIM, &predim_model, LeafPredim::PREDIM },
            { PLASTO_DELAY, &plasto_delay_model, PlastoDelay::PLASTO_DELAY },
            { REALLOC_BIOMASS, &biomass_model, LeafBiomass::REALLOC_BIOMASS },
            { SENESC_DW, &biomass_model, LeafBiomass::SENESC_DW },
            { SENESC_DW_SUM, &biomass_model, LeafBiomass::SENESC_DW_SUM },
            { CORRECTED_BIOMASS, &biomass_model, LeafBiomass::CORRECTED_BIOMASS },
            { CORRECTED_BLADE_AREA, &blade_area_model,
                    BladeArea::CORRECTED_BLADE_AREA },
            { LEN, &len_model, LeafLen::LEN }
        });

    external(DD, &LeafModel::_dd);
    external(DELTA_T, &LeafModel::_delta_t);
    external(FTSW, &LeafModel::_ftsw);
    external(FCSTR, &LeafModel::_fcstr);
    external(P, &LeafModel::_p);
    external(PHENO_STAGE, &LeafModel::_pheno_stage);
    external(PREDIM_LEAF_ON_MAINSTEM, &LeafModel::_predim_leaf_on_mainstem);
    external(PREDIM_PREVIOUS_LEAF, &LeafModel::_predim_previous_leaf);
    external(SLA, &LeafModel::_sla);
    external(GROW, &LeafModel::_grow);
    external(PHASE, &LeafModel::_phase);
    external(STATE, &LeafModel::_state);
    external(STOP, &LeafModel::_stop);
    external(TEST_IC, &LeafModel::_test_ic);
}

void LeafModel::init(double t,
                 const model::models::ModelParameters& parameters)
{
    time_from_app_model.init(t, parameters);
    biomass_model.init(t, parameters);
    exp_time_model.init(t, parameters);
    len_model.init(t, parameters);
    predim_model.init(t, parameters);
    width_model.init(t, parameters);
    blade_area_model.init(t, parameters);
    last_demand_model.init(t, parameters);
    ler_model.init(t, parameters);
    reduction_ler_model.init(t, parameters);
    leaf_demand_model.init(t, parameters);
    manager_model.init(t, parameters);
    plasto_delay_model.init(t, parameters);
    life_span_model.init(t, parameters);
    thermal_time_since_ligulation_model.init(t, parameters);
}

void LeafModel::compute(double t, bool /* update */)
{
    life_span_model(t);

    predim_model.put(t, LeafPredim::FCSTR, _fcstr);
    predim_model.put(t, LeafPredim::PREDIM_LEAF_ON_MAINSTEM,
                     _predim_leaf_on_mainstem);
    predim_model.put(t, LeafPredim::PREDIM_PREVIOUS_LEAF,
                     _predim_previous_leaf);
    // TODO: genant !
    // if (is_ready(t, TEST_IC)) {
        predim_model.put(t, LeafPredim::TEST_IC, _test_ic);
    // }
    predim_model(t);

    reduction_ler_model.put(t, ReductionLER::FTSW, _ftsw);
    reduction_ler_model.put(t, ReductionLER::P, _p);
    reduction_ler_model(t);

    if (predim_model.is_computed(t, LeafPredim::PREDIM)) {
        ler_model.put(t, Ler::PREDIM,
                      predim_model.get < double >(t, LeafPredim::PREDIM));
        ler_model.put(t, Ler::REDUCTION_LER,
                      reduction_ler_model.get < double >(t, ReductionLER::REDUCTION_LER));
        ler_model(t);
    }

    if (ler_model.is_computed(t, Ler::LER) and
        predim_model.is_computed(t, LeafPredim::PREDIM)) {
        exp_time_model.put(t, LeafExpTime::LER, ler_model.get < double >(t, Ler::LER));
        // exp_time_model.put(t, ExpTime::DD, _dd);
        exp_time_model.put(t, LeafExpTime::PREDIM,
                           predim_model.get < double >(t, LeafPredim::PREDIM));
        exp_time_model(t);
    }

    if (exp_time_model.is_computed(t, LeafExpTime::EXP_TIME) and
        ler_model.is_computed(t, Ler::LER) and
        predim_model.is_computed(t, LeafPredim::PREDIM)) {
        len_model.put(t, LeafLen::DD, _dd);
        len_model.put(t, LeafLen::DELTA_T, _delta_t);
        len_model.put(t, LeafLen::EXP_TIME,
                      exp_time_model.get < double >(t, LeafExpTime::EXP_TIME));
        len_model.put(t, LeafLen::LER, ler_model.get < double >(t, Ler::LER));
        len_model.put(t, LeafLen::GROW, _grow);
        len_model.put(t, LeafLen::PHASE, _phase);
        len_model.put(t, LeafLen::PREDIM,
                      predim_model.get < double >(t, LeafPredim::PREDIM));
        len_model(t);
    }

    if (len_model.is_computed(t, LeafLen::LEN)) {
        exp_time_model.put(t, LeafExpTime::LEN, len_model.get < double >(t, LeafLen::LEN));
        manager_model.put(t, LeafManager::LEN, len_model.get < double >(t, LeafLen::LEN));
    }

    manager_model.put(t, LeafManager::PREDIM,
                      predim_model.get < double >(t, LeafPredim::PREDIM));
    manager_model.put(t, LeafManager::PHASE, _phase);
    manager_model.put(t, LeafManager::STOP, _stop);

    if (exp_time_model.is_computed(t, LeafExpTime::EXP_TIME)) {
        plasto_delay_model.put(t, PlastoDelay::DELTA_T, _delta_t);
        plasto_delay_model.put(t, PlastoDelay::REDUCTION_LER,
                               reduction_ler_model.get < double >(
                                   t, ReductionLER::REDUCTION_LER));
        plasto_delay_model.put(t, PlastoDelay::EXP_TIME,
                               exp_time_model.get < double >(t, LeafExpTime::EXP_TIME));
        plasto_delay_model(t);
    }

    if (len_model.is_computed(t, LeafLen::LEN)) {
        width_model.put(t, Width::LEN, len_model.get < double >(t, LeafLen::LEN));
        width_model(t);
    }

    if (manager_model.is_computed(t, LeafManager::LEAF_PHASE)) {
        thermal_time_since_ligulation_model.put(
            t, ThermalTimeSinceLigulation::DELTA_T, _delta_t);
        thermal_time_since_ligulation_model.put(
            t, ThermalTimeSinceLigulation::PHASE,
            manager_model.get < double >(t, LeafManager::LEAF_PHASE));
        thermal_time_since_ligulation_model(t);
    }

    if (len_model.is_computed(t, LeafLen::LEN)) {
        blade_area_model.put(t, BladeArea::LEN, len_model.get < double >(t, LeafLen::LEN));
        blade_area_model.put(t, BladeArea::WIDTH,
                             width_model.get < double >(t, Width::WIDTH));
        blade_area_model.put(
            t, BladeArea::PHASE,
            manager_model.get < double >(t, LeafManager::LEAF_PHASE));
        blade_area_model.put(
            t, BladeArea::TT,
            thermal_time_since_ligulation_model.get < double >(
                t, ThermalTimeSinceLigulation::THERMAL_TIME_SINCE_LIGULATION));
        blade_area_model.put(t, BladeArea::LIFE_SPAN,
                             life_span_model.get < double >(t, LifeSpan::LIFE_SPAN));
        blade_area_model(t);
    }

    if (blade_area_model.is_computed(t, BladeArea::BLADE_AREA)) {
        biomass_model.put(t, LeafBiomass::GROW, _grow);
        biomass_model.put(t, LeafBiomass::SLA, _sla);
        biomass_model.put(t, LeafBiomass::PHASE,
                          manager_model.get < double >(t, LeafManager::LEAF_PHASE));
        biomass_model.put(t, LeafBiomass::BLADE_AREA,
                          blade_area_model.get < double >(t, BladeArea::BLADE_AREA));
        biomass_model.put(t, LeafBiomass::CORRECTED_BLADE_AREA,
                          blade_area_model.get < double >(
                              t, BladeArea::CORRECTED_BLADE_AREA));
        biomass_model.put(
            t, LeafBiomass::TT,
            thermal_time_since_ligulation_model.get < double >(
                t, ThermalTimeSinceLigulation::THERMAL_TIME_SINCE_LIGULATION));
        biomass_model.put(t, LeafBiomass::LIFE_SPAN,
                          life_span_model.get < double >(t, LifeSpan::LIFE_SPAN));
        biomass_model(t);
    }

    if (biomass_model.is_computed(t, LeafBiomass::BIOMASS)) {
        leaf_demand_model.put(t, LeafDemand::GROW, _grow);
        leaf_demand_model.put(t, LeafDemand::PHASE,
                              manager_model.get < double >(t, LeafManager::LEAF_PHASE));
        leaf_demand_model.put(t, LeafDemand::BIOMASS,
                              biomass_model.get < double >(t, LeafBiomass::BIOMASS));
        leaf_demand_model(t);
    }

    if (biomass_model.is_computed(t, LeafBiomass::BIOMASS)) {
        last_demand_model.put(t, LeafLastDemand::PHASE,
                              manager_model.get < double >(t, LeafManager::LEAF_PHASE));
        last_demand_model.put(t, LeafLastDemand::BIOMASS,
                              biomass_model.get < double >(t, LeafBiomass::BIOMASS));
        last_demand_model(t);
    }

    if (manager_model.is_computed(t, LeafManager::LEAF_PHASE)) {
        time_from_app_model.put(t, LeafTimeFromApp::PHASE,
                                manager_model.get < double >(t, LeafManager::LEAF_PHASE));
        time_from_app_model.put(t, LeafTimeFromApp::DD, _dd);
        time_from_app_model.put(t, LeafTimeFromApp::DELTA_T, _delta_t);
        time_from_app_model(t);
    }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF", t, artis::utils::COMPUTE)
            << "index = " << _index
            << " ; predim = "
            << (predim_model.is_computed(t, LeafPredim::PREDIM) ?
                predim_model.get < double >(t, LeafPredim::PREDIM) : -1);
        utils::Trace::trace().flush();
#endif

}

} } // namespace ecomeristem leaf

/**
 * @file ecomeristem/leaf/Model.cpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2015 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2015 ULCO http://www.univ-littoral.fr
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

#include <model/models/ecomeristem/leaf/Model.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

Model::Model(int index, bool is_on_mainstem) :
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
    internal(BIOMASS, &biomass_model, Biomass::BIOMASS);
    internal(BLADE_AREA, &blade_area_model, BladeArea::BLADE_AREA);
    internal(DEMAND, &leaf_demand_model, LeafDemand::DEMAND);
    internal(LAST_DEMAND, &last_demand_model, LastDemand::LAST_DEMAND);
    internal(PREDIM, &predim_model, Predim::PREDIM);
    internal(PLASTO_DELAY, &plasto_delay_model, PlastoDelay::PLASTO_DELAY);
    internal(REALLOC_BIOMASS, &biomass_model, Biomass::REALLOC_BIOMASS);
    internal(SENESC_DW, &biomass_model, Biomass::SENESC_DW);
    internal(CORRECTED_BIOMASS, &biomass_model, Biomass::CORRECTED_BIOMASS);
    internal(CORRECTED_BLADE_AREA, &blade_area_model,
             BladeArea::CORRECTED_BLADE_AREA);
    internal(LEN, &len_model, Len::LEN);

    external(DD, &Model::_dd);
    external(DELTA_T, &Model::_delta_t);
    external(FTSW, &Model::_ftsw);
    external(FCSTR, &Model::_fcstr);
    external(P, &Model::_p);
    external(PHENO_STAGE, &Model::_pheno_stage);
    external(PREDIM_LEAF_ON_MAINSTEM, &Model::_predim_leaf_on_mainstem);
    external(PREDIM_PREVIOUS_LEAF, &Model::_predim_previous_leaf);
    external(SLA, &Model::_sla);
    external(GROW, &Model::_grow);
    external(PHASE, &Model::_phase);
    external(STATE, &Model::_state);
    external(STOP, &Model::_stop);
    external(TEST_IC, &Model::_test_ic);
}

void Model::init(double t,
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

void Model::compute(double t, bool /* update */)
{
    life_span_model(t);

    predim_model.put(t, Predim::FCSTR, _fcstr);
    predim_model.put(t, Predim::PREDIM_LEAF_ON_MAINSTEM,
                     _predim_leaf_on_mainstem);
    predim_model.put(t, Predim::PREDIM_PREVIOUS_LEAF,
                     _predim_previous_leaf);
    if (is_ready(t, TEST_IC)) {
        predim_model.put(t, Predim::TEST_IC, _test_ic);
    }
    predim_model(t);

    reduction_ler_model.put(t, ReductionLER::FTSW, _ftsw);
    reduction_ler_model.put(t, ReductionLER::P, _p);
    reduction_ler_model(t);

    if (predim_model.is_computed(t, Predim::PREDIM)) {
        ler_model.put(t, Ler::PREDIM,
                      predim_model.get(t, Predim::PREDIM));
    }
    ler_model.put(t, Ler::REDUCTION_LER,
                  reduction_ler_model.get(t, ReductionLER::REDUCTION_LER));
    ler_model(t);

    exp_time_model.put(t, ExpTime::LER, ler_model.get(t, Ler::LER));
    exp_time_model.put(t, ExpTime::DD, _dd);
    if (predim_model.is_computed(t, Predim::PREDIM)) {
        exp_time_model.put(t, ExpTime::PREDIM,
                           predim_model.get(t, Predim::PREDIM));
    }
    exp_time_model(t);

    len_model.put(t, Len::DD, _dd);
    len_model.put(t, Len::DELTA_T, _delta_t);
    len_model.put(t, Len::EXP_TIME,
                  exp_time_model.get(t, ExpTime::EXP_TIME));
    len_model.put(t, Len::LER, ler_model.get(t, Ler::LER));
    len_model.put(t, Len::GROW, _grow);
    len_model.put(t, Len::PHASE, _phase);
    if (predim_model.is_computed(t, Predim::PREDIM)) {
        len_model.put(t, Len::PREDIM,
                      predim_model.get(t, Predim::PREDIM));
    }
    len_model(t);
    exp_time_model.put(t, ExpTime::LEN, len_model.get(t, Len::LEN));

    manager_model.put(t, Manager::LEN, len_model.get(t, Len::LEN));
    if (predim_model.is_computed(t, Predim::PREDIM)) {
        manager_model.put(t, Manager::PREDIM,
                          predim_model.get(t, Predim::PREDIM));
    }
    manager_model.put(t, Manager::PHASE, _phase);
    manager_model.put(t, Manager::STOP, _stop);

    plasto_delay_model.put(t, PlastoDelay::DELTA_T, _delta_t);
    plasto_delay_model.put(t, PlastoDelay::REDUCTION_LER,
                           reduction_ler_model.get(
                               t, ReductionLER::REDUCTION_LER));
    plasto_delay_model.put(t, PlastoDelay::EXP_TIME,
                           exp_time_model.get(t, ExpTime::EXP_TIME));
    plasto_delay_model(t);

    width_model.put(t, Width::LEN, len_model.get(t, Len::LEN));
    width_model(t);

    thermal_time_since_ligulation_model.put(
        t, ThermalTimeSinceLigulation::DELTA_T, _delta_t);
    thermal_time_since_ligulation_model.put(
        t, ThermalTimeSinceLigulation::PHASE,
        manager_model.get(t, Manager::LEAF_PHASE));
    thermal_time_since_ligulation_model(t);

    blade_area_model.put(t, BladeArea::LEN, len_model.get(t, Len::LEN));
    blade_area_model.put(t, BladeArea::WIDTH,
                         width_model.get(t, Width::WIDTH));
    blade_area_model.put(
        t, BladeArea::PHASE,
        manager_model.get(t, Manager::LEAF_PHASE));
    blade_area_model.put(
        t, BladeArea::TT,
        thermal_time_since_ligulation_model.get(
            t, ThermalTimeSinceLigulation::THERMAL_TIME_SINCE_LIGULATION));
    blade_area_model.put(t, BladeArea::LIFE_SPAN,
                         life_span_model.get(t, LifeSpan::LIFE_SPAN));
    blade_area_model(t);

    biomass_model.put(t, Biomass::GROW, _grow);
    biomass_model.put(t, Biomass::SLA, _sla);
    biomass_model.put(t, Biomass::PHASE,
                      manager_model.get(t, Manager::LEAF_PHASE));
    biomass_model.put(t, Biomass::BLADE_AREA,
                      blade_area_model.get(t, BladeArea::BLADE_AREA));
    biomass_model.put(t, Biomass::CORRECTED_BLADE_AREA,
                      blade_area_model.get(t, BladeArea::CORRECTED_BLADE_AREA));
    biomass_model.put(
        t, Biomass::TT,
        thermal_time_since_ligulation_model.get(
            t, ThermalTimeSinceLigulation::THERMAL_TIME_SINCE_LIGULATION));
    biomass_model.put(t, Biomass::LIFE_SPAN,
                         life_span_model.get(t, LifeSpan::LIFE_SPAN));
    biomass_model(t);

    leaf_demand_model.put(t, LeafDemand::GROW, _grow);
    leaf_demand_model.put(t, LeafDemand::PHASE,
                          manager_model.get(t, Manager::LEAF_PHASE));
    leaf_demand_model.put(t, LeafDemand::BIOMASS,
                          biomass_model.get(t, Biomass::BIOMASS));
    leaf_demand_model(t);

    last_demand_model.put(t, LastDemand::PHASE,
                          manager_model.get(t, Manager::LEAF_PHASE));
    last_demand_model.put(t, LastDemand::BIOMASS,
                          biomass_model.get(t, Biomass::BIOMASS));
    last_demand_model(t);

    time_from_app_model.put(t, TimeFromApp::PHASE,
                            manager_model.get(t, Manager::LEAF_PHASE));
    time_from_app_model.put(t, TimeFromApp::DD, _dd);
    time_from_app_model.put(t, TimeFromApp::DELTA_T, _delta_t);
    time_from_app_model(t);

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF", t, utils::COMPUTE)
            << "index = " << _index
            << " ; predim = "
            << (predim_model.is_computed(t, Predim::PREDIM) ?
                predim_model.get(t, Predim::PREDIM) : -1);
        utils::Trace::trace().flush();
#endif

}

} } // namespace ecomeristem leaf

/**
 * @file ecomeristem/internode/Model.cpp
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

#include <model/models/ecomeristem/internode/Model.hpp>

namespace ecomeristem { namespace internode {

Model::Model(int index, bool is_on_mainstem) :
    _index(index),
    _is_first_internode(_index == 1), _is_on_mainstem(is_on_mainstem),
    biomass_model(index),
    exp_time_model(index),
    len_model(index),
    predim_model(index),
    last_demand_model(index),
    iner_model(index),
    internode_demand_model(index),
    manager_model(index)
{
    S({ { TIME_FROM_APP, &time_from_app_model },
        { BIOMASS_, &biomass_model },
        { EXP_TIME, &exp_time_model },
        { LEN_, &len_model },
        { VOLUME, &volume_model },
        { PREDIM, &predim_model },
        { DIAMETER_PREDIM, &diameter_predim_model },
        { LAST_DEMAND_, &last_demand_model },
        { INER, &iner_model },
        { REDUCTION_INER, &reduction_iner_model },
        { DEMAND_, &internode_demand_model },
        { MANAGER, &manager_model }
        });

    internal(BIOMASS, &biomass_model, Biomass::BIOMASS);
    internal(DEMAND, &internode_demand_model, InternodeDemand::DEMAND);
    internal(LAST_DEMAND, &last_demand_model, LastDemand::LAST_DEMAND);
    internal(LEN, &len_model, Len::LEN);

    external(DD, &Model::_dd);
    external(DELTA_T, &Model::_delta_t);
    external(FTSW, &Model::_ftsw);
    external(P, &Model::_p);
    external(PHASE, &Model::_phase);
    external(STATE, &Model::_state);
    external(PREDIM_LEAF, &Model::_predim_leaf);
    external(LIG, &Model::_lig);
}

void Model::init(double t,
                 const model::models::ModelParameters& parameters)
{
    time_from_app_model.init(t, parameters);
    biomass_model.init(t, parameters);
    exp_time_model.init(t, parameters);
    len_model.init(t, parameters);
    predim_model.init(t, parameters);
    diameter_predim_model.init(t, parameters);
    volume_model.init(t, parameters);
    last_demand_model.init(t, parameters);
    iner_model.init(t, parameters);
    reduction_iner_model.init(t, parameters);
    internode_demand_model.init(t, parameters);
    manager_model.init(t, parameters);
}

void Model::compute(double t, bool /* update */)
{
    predim_model.put(t, Predim::PREDIM_PREVIOUS_LEAF, _predim_leaf);
    predim_model(t);

    reduction_iner_model.put(t, ReductionINER::FTSW, _ftsw);
    reduction_iner_model.put(t, ReductionINER::P, _p);
    reduction_iner_model(t);

    if (predim_model.is_computed(t, Predim::PREDIM)) {
        iner_model.put(t, Iner::PREDIM,
                      predim_model.get(t, Predim::PREDIM));
    }
    iner_model.put(t, Iner::REDUCTION_INER,
                  reduction_iner_model.get(t, ReductionINER::REDUCTION_INER));
    iner_model(t);

    manager_model.put(t, Manager::PHASE, _phase);
    manager_model.put(t, Manager::STATE, _state);
    manager_model.put(t, Manager::LIG, _lig);
    do {
        len_model.put(t, Len::DD, _dd);
        len_model.put(t, Len::DELTA_T, _delta_t);
        if (exp_time_model.is_computed(t, ExpTime::EXP_TIME)) {
            len_model.put(t, Len::EXP_TIME,
                          exp_time_model.get(t, ExpTime::EXP_TIME));
        }
        len_model.put(t, Len::INER, iner_model.get(t, Iner::INER));
        if (manager_model.is_computed(t, Manager::INTERNODE_PHASE)) {
            len_model.put(t, Len::PHASE, manager_model.get(
                              t, Manager::INTERNODE_PHASE));
        }
        if (predim_model.is_computed(t, Predim::PREDIM)) {
            len_model.put(t, Len::PREDIM,
                          predim_model.get(t, Predim::PREDIM));
        }
        len_model(t);

        exp_time_model.put(t, ExpTime::INER, iner_model.get(t, Iner::INER));
        if (len_model.is_computed(t, Len::LEN)) {
            exp_time_model.put(t, ExpTime::LEN, len_model.get(t, Len::LEN));
        }
        if (manager_model.is_computed(t, Manager::INTERNODE_PHASE)) {
            exp_time_model.put(t, ExpTime::PHASE, manager_model.get(
                                   t, Manager::INTERNODE_PHASE));
        }
        if (predim_model.is_computed(t, Predim::PREDIM)) {
            exp_time_model.put(t, ExpTime::PREDIM,
                               predim_model.get(t, Predim::PREDIM));
        }
        exp_time_model(t);
    } while (not len_model.is_computed(t, Len::LEN) or
             not exp_time_model.is_computed(t, ExpTime::EXP_TIME));

    manager_model.put(t, Manager::LEN, len_model.get(t, Len::LEN));
    if (predim_model.is_computed(t, Predim::PREDIM)) {
        manager_model.put(t, Manager::PREDIM,
                          predim_model.get(t, Predim::PREDIM));
    }

    if (predim_model.is_computed(t, Predim::PREDIM)) {
        diameter_predim_model.put(t, DiameterPredim::PREDIM,
                                  predim_model.get(t, Predim::PREDIM));
    }
    diameter_predim_model(t);

    volume_model.put(t, Volume::LEN, len_model.get(t, Len::LEN));
    volume_model.put(t, Volume::DIAMETER,
                         diameter_predim_model.get(
                             t, DiameterPredim::DIAMETER_PREDIM));
    volume_model(t);

    biomass_model.put(t, Biomass::VOLUME,
                      volume_model.get(t, Volume::VOLUME));
    biomass_model(t);

    internode_demand_model.put(t, InternodeDemand::BIOMASS,
                          biomass_model.get(t, Biomass::BIOMASS));
    internode_demand_model.put(t, InternodeDemand::PHASE,
                           manager_model.get(t, Manager::INTERNODE_PHASE));
    internode_demand_model(t);

    last_demand_model.put(t, LastDemand::PHASE,
                          manager_model.get(t, Manager::INTERNODE_PHASE));
    last_demand_model.put(t, LastDemand::BIOMASS,
                          biomass_model.get(t, Biomass::BIOMASS));
    last_demand_model(t);

    time_from_app_model.put(t, TimeFromApp::PHASE,
                            manager_model.get(t, Manager::INTERNODE_PHASE));
    time_from_app_model.put(t, TimeFromApp::DD, _dd);
    time_from_app_model.put(t, TimeFromApp::DELTA_T, _delta_t);
    time_from_app_model(t);

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("INTERNODE", t, artis::utils::COMPUTE)
            << "index = " << _index
            << " ; predim = "
            << (predim_model.is_computed(t, Predim::PREDIM) ?
                predim_model.get(t, Predim::PREDIM) : -1);
        utils::Trace::trace().flush();
#endif

}

} } // namespace ecomeristem internode

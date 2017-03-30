/**
 * @file ecomeristem/internode/Model.cpp
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

#include <model/models/ecomeristem/internode/InternodeModel.hpp>

namespace ecomeristem { namespace internode {

InternodeModel::InternodeModel(int index, bool is_on_mainstem) :
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
    internal(LAST_DEMAND, &last_demand_model, InternodeLastDemand::LAST_DEMAND);
    internal(LEN, &len_model, InternodeLen::LEN);

    external(DD, &InternodeModel::_dd);
    external(DELTA_T, &InternodeModel::_delta_t);
    external(FTSW, &InternodeModel::_ftsw);
    external(P, &InternodeModel::_p);
    external(PHASE, &InternodeModel::_phase);
    external(STATE, &InternodeModel::_state);
    external(PREDIM_LEAF, &InternodeModel::_predim_leaf);
    external(LIG, &InternodeModel::_lig);
}

void InternodeModel::init(double t,
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

void InternodeModel::compute(double t, bool /* update */)
{
    predim_model.put(t, InternodePredim::PREDIM_PREVIOUS_LEAF, _predim_leaf);
    predim_model(t);

    reduction_iner_model.put(t, ReductionINER::FTSW, _ftsw);
    reduction_iner_model.put(t, ReductionINER::P, _p);
    reduction_iner_model(t);

    if (predim_model.is_computed(t, InternodePredim::PREDIM)) {
        iner_model.put(t, Iner::PREDIM,
                      predim_model.get < double >(t, InternodePredim::PREDIM));
    }
    iner_model.put(t, Iner::REDUCTION_INER,
                  reduction_iner_model.get < double >(t, ReductionINER::REDUCTION_INER));
    iner_model(t);

    manager_model.put(t, InternodeManager::PHASE, _phase);
    manager_model.put(t, InternodeManager::STATE, _state);
    manager_model.put(t, InternodeManager::LIG, _lig);
    do {
        len_model.put(t, InternodeLen::DD, _dd);
        len_model.put(t, InternodeLen::DELTA_T, _delta_t);
        if (exp_time_model.is_computed(t, InternodeExpTime::EXP_TIME)) {
            len_model.put(t, InternodeLen::EXP_TIME,
                          exp_time_model.get < double >(t, InternodeExpTime::EXP_TIME));
        }
        len_model.put(t, InternodeLen::INER, iner_model.get < double >(t, Iner::INER));
        if (manager_model.is_computed(t, InternodeManager::INTERNODE_PHASE)) {
            len_model.put(t, InternodeLen::PHASE, manager_model.get < double >(
                              t, InternodeManager::INTERNODE_PHASE));
        }
        if (predim_model.is_computed(t, InternodePredim::PREDIM)) {
            len_model.put(t, InternodeLen::PREDIM,
                          predim_model.get < double >(t, InternodePredim::PREDIM));
        }
        len_model(t);

        exp_time_model.put(t, InternodeExpTime::INER, iner_model.get < double >(t, Iner::INER));
        if (len_model.is_computed(t, InternodeLen::LEN)) {
            exp_time_model.put(t, InternodeExpTime::LEN, len_model.get < double >(t, InternodeLen::LEN));
        }
        if (manager_model.is_computed(t, InternodeManager::INTERNODE_PHASE)) {
            exp_time_model.put(t, InternodeExpTime::PHASE, manager_model.get < double >(
                                   t, InternodeManager::INTERNODE_PHASE));
        }
        if (predim_model.is_computed(t, InternodePredim::PREDIM)) {
            exp_time_model.put(t, InternodeExpTime::PREDIM,
                               predim_model.get < double >(t, InternodePredim::PREDIM));
        }
        exp_time_model(t);
    } while (not len_model.is_computed(t, InternodeLen::LEN) or
             not exp_time_model.is_computed(t, InternodeExpTime::EXP_TIME));

    manager_model.put(t, InternodeManager::LEN, len_model.get < double >(t, InternodeLen::LEN));
    if (predim_model.is_computed(t, InternodePredim::PREDIM)) {
        manager_model.put(t, InternodeManager::PREDIM,
                          predim_model.get < double >(t, InternodePredim::PREDIM));
    }

    if (predim_model.is_computed(t, InternodePredim::PREDIM)) {
        diameter_predim_model.put(t, DiameterPredim::PREDIM,
                                  predim_model.get < double >(t, InternodePredim::PREDIM));
    }
    diameter_predim_model(t);

    volume_model.put(t, Volume::LEN, len_model.get < double >(t, InternodeLen::LEN));
    volume_model.put(t, Volume::DIAMETER,
                         diameter_predim_model.get < double >(
                             t, DiameterPredim::DIAMETER_PREDIM));
    volume_model(t);

    biomass_model.put(t, Biomass::VOLUME,
                      volume_model.get < double >(t, Volume::VOLUME));
    biomass_model(t);

    internode_demand_model.put(t, InternodeDemand::BIOMASS,
                          biomass_model.get < double >(t, Biomass::BIOMASS));
    internode_demand_model.put(t, InternodeDemand::PHASE,
                           manager_model.get < double >(t, InternodeManager::INTERNODE_PHASE));
    internode_demand_model(t);

    last_demand_model.put(t, InternodeLastDemand::PHASE,
                          manager_model.get < double >(t, InternodeManager::INTERNODE_PHASE));
    last_demand_model.put(t, InternodeLastDemand::BIOMASS,
                          biomass_model.get < double >(t, Biomass::BIOMASS));
    last_demand_model(t);

    time_from_app_model.put(t, InternodeTimeFromApp::PHASE,
                            manager_model.get < double >(t, InternodeManager::INTERNODE_PHASE));
    time_from_app_model.put(t, InternodeTimeFromApp::DD, _dd);
    time_from_app_model.put(t, InternodeTimeFromApp::DELTA_T, _delta_t);
    time_from_app_model(t);

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("INTERNODE", t, artis::utils::COMPUTE)
            << "index = " << _index
            << " ; predim = "
            << (predim_model.is_computed(t, InternodePredim::PREDIM) ?
                predim_model.get < double >(t, InternodePredim::PREDIM) : -1);
        utils::Trace::trace().flush();
#endif

}

} } // namespace ecomeristem internode

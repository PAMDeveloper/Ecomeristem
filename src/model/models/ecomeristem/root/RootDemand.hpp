/**
 * @file root/RootDemand.hpp
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

#ifndef __ECOMERISTEM_ROOT_ROOT_DEMAND_HPP
#define __ECOMERISTEM_ROOT_ROOT_DEMAND_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/PlantManager.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace root {

class RootDemand : public ecomeristem::AbstractAtomicModel < RootDemand >
{
public:
    enum internals { ROOT_DEMAND, ROOT_DEMAND_1, ROOT_BIOMASS, SURPLUS };
    enum externals { LEAF_DEMAND_SUM, LEAF_LAST_DEMAND_SUM,
                     INTERNODE_DEMAND_SUM, INTERNODE_LAST_DEMAND_SUM,
                     ROOT_DEMAND_COEF, GROW, PHASE, STATE, CULM_SURPLUS_SUM };

    RootDemand()
    {
        internal(ROOT_DEMAND, &RootDemand::_root_demand);
        internal(ROOT_DEMAND_1, &RootDemand::_root_demand_1);
        internal(ROOT_BIOMASS, &RootDemand::_root_biomass);
        internal(SURPLUS, &RootDemand::_surplus);

        external(LEAF_DEMAND_SUM, &RootDemand::_leaf_demand_sum);
        external(LEAF_LAST_DEMAND_SUM, &RootDemand::_leaf_last_demand_sum);
        external(INTERNODE_DEMAND_SUM, &RootDemand::_internode_demand_sum);
        external(INTERNODE_LAST_DEMAND_SUM,
                 &RootDemand::_internode_last_demand_sum);
        external(ROOT_DEMAND_COEF, &RootDemand::_root_demand_coef);
        external(GROW, &RootDemand::_grow);
        external(PHASE, &RootDemand::_phase);
        external(STATE, &RootDemand::_state);
        external(CULM_SURPLUS_SUM, &RootDemand::_culm_surplus_sum);
    }

    virtual ~RootDemand()
    { }

    bool check(double t) const
    { return is_ready(t, LEAF_DEMAND_SUM) and is_ready(t, ROOT_DEMAND_COEF) and
            is_ready(t, GROW) and is_ready(t, PHASE); }

    void compute(double t, bool update)
    {
        if (not update) {
            _root_demand_1 = _root_demand;
            _root_biomass_1 = _root_biomass;
            _stop = false;
        }
        if (_first_day == t) {
            _root_demand = (_leaf_demand_sum + _leaf_last_demand_sum +
                            _internode_demand_sum) * _root_demand_coef;
            _last_value = _root_demand;
            _root_biomass = _root_demand;
        } else {
            if (_phase == ecomeristem::plant::NOGROWTH or
                _phase == ecomeristem::plant::NOGROWTH4 or _stop) {
                _root_demand = 0;
                _last_value = 0;
                _stop = _phase == ecomeristem::plant::NOGROWTH4;
            } else {
                if (_state == ecomeristem::plant::ELONG ||
                    _state == ecomeristem::plant::PI) {
                    if (_leaf_demand_sum + _leaf_last_demand_sum +
                        _internode_demand_sum + _internode_last_demand_sum
                        == 0) {
                        _root_demand = _last_value * _root_demand_coef;
                    } else {
                        _root_demand = (_leaf_demand_sum +
                                        _leaf_last_demand_sum +
                                        _internode_demand_sum +
                                        _internode_last_demand_sum) *
                            _root_demand_coef;
                    }
                    if (_leaf_demand_sum + _leaf_last_demand_sum +
                        _internode_demand_sum + _internode_last_demand_sum
                        != 0) {
                        _last_value = _leaf_demand_sum + _leaf_last_demand_sum +
                            _internode_demand_sum + _internode_last_demand_sum;
                    } else {
                        _last_value = 0;
                    }
                    _root_demand = std::min(_culm_surplus_sum, _root_demand);
                      _surplus = _culm_surplus_sum - _root_demand;

                } else {
                    if (_leaf_demand_sum +
                        _leaf_last_demand_sum == 0) {
                        _root_demand = _last_value * _root_demand_coef;
                    } else {
                        _root_demand = (_leaf_demand_sum +
                                        _leaf_last_demand_sum) *
                            _root_demand_coef;
                    }
                    if (_leaf_demand_sum +
                        _internode_demand_sum != 0) {
                        _last_value = _leaf_demand_sum +
                            _internode_demand_sum;
                    } else {
                        _last_value = 0;
                    }
                    _surplus = 0;
                }
            }
            if (update) {
                _root_biomass = _root_biomass_1 + _root_demand;
            } else {
                _root_biomass += _root_demand;
            }
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("ROOT_DEMAND", t, artis::utils::COMPUTE)
            << "RootDemand = " << _root_demand
            << " ; RootBiomass = " << _root_biomass
            << " ; phase = " << _phase
            << " ; Surplus = " << _surplus
            << " ; LastValue = " << _last_value
            << " ; LeafDemandSum = " << _leaf_demand_sum
            << " ; LeafDemandSum[-1] = " << _leaf_demand_sum_1
            << " ; LeafLastDemandSum = " << _leaf_last_demand_sum
            << " ; LeafLastDemandSum[-1] = " << _leaf_last_demand_sum_1
            << " ; InternodeDemandSum = " << _internode_demand_sum
            << " ; InternodeDemandSum[-1] = " << _internode_demand_sum_1
            << " ; InternodeLastDemandSum = " << _internode_last_demand_sum
            << " ; InternodeLastDemandSum[-1] = "
            << _internode_last_demand_sum_1
            << " ; RootDemandCoef = " << _root_demand_coef
            << " ; Grow = " << _grow;
        utils::Trace::trace().flush();
#endif

    }

    void init(double t,
              const model::models::ModelParameters& /* parameters */)
    {
        _leaf_demand_sum = 0;
        _leaf_last_demand_sum = 0;
        _internode_demand_sum = 0;
        _internode_last_demand_sum = 0;
        _leaf_demand_sum_1 = 0;
        _leaf_last_demand_sum_1 = 0;
        _internode_demand_sum_1 = 0;
        _internode_last_demand_sum_1 = 0;
        _root_demand = 0;
        _root_demand_1 = 0;
        _root_biomass = 0;
        _root_biomass_1 = 0;
        _surplus = 0;
        _culm_surplus_sum = 0;
        _last_value = 0;
        _first_day = t;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == LEAF_DEMAND_SUM and !is_ready(t, LEAF_DEMAND_SUM)) {
            _leaf_demand_sum_1 = _leaf_demand_sum;
        }
        if (index == LEAF_LAST_DEMAND_SUM and
            !is_ready(t, LEAF_LAST_DEMAND_SUM)) {
            _leaf_last_demand_sum_1 = _leaf_last_demand_sum;
        }
        if (index == INTERNODE_DEMAND_SUM and
            not is_ready(t, INTERNODE_DEMAND_SUM)) {
            _internode_demand_sum_1 = _internode_demand_sum;
        }
        if (index == INTERNODE_LAST_DEMAND_SUM and
            not is_ready(t, INTERNODE_LAST_DEMAND_SUM)) {
            _internode_last_demand_sum_1 = _internode_last_demand_sum;
        }
        ecomeristem::AbstractAtomicModel < RootDemand >::put(t, index, value);
    }

private:
// internal variable
    double _root_demand;
    double _root_demand_1;
    double _root_biomass;
    double _root_biomass_1;
    double _first_day;
    double _last_value;
    double _surplus;
    bool _stop;

// external variables
    double _leaf_demand_sum;
    double _leaf_demand_sum_1;
    double _leaf_last_demand_sum;
    double _leaf_last_demand_sum_1;
    double _internode_demand_sum;
    double _internode_demand_sum_1;
    double _internode_last_demand_sum;
    double _internode_last_demand_sum_1;
    double _root_demand_coef;
    double _grow;
    double _phase;
    double _state;
    double _culm_surplus_sum;
};

} } // namespace ecomeristem root

#endif

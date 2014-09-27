/**
 * @file root/RootDemand.hpp
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

#ifndef __ECOMERISTEM_ROOT_ROOT_DEMAND_HPP
#define __ECOMERISTEM_ROOT_ROOT_DEMAND_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/Manager.hpp>

namespace ecomeristem { namespace root {

class RootDemand : public AbstractAtomicModel < RootDemand >
{
public:
    static const unsigned int ROOT_DEMAND = 0;
    static const unsigned int ROOT_BIOMASS = 1;

    static const unsigned int LEAF_DEMAND_SUM = 0;
    static const unsigned int ROOT_DEMAND_COEF = 1;
    static const unsigned int GROW = 2;
    static const unsigned int PHASE = 3;

    RootDemand()
    {
        internal(ROOT_DEMAND, &RootDemand::_root_demand);
        internal(ROOT_BIOMASS, &RootDemand::_root_biomass);
        external(LEAF_DEMAND_SUM, &RootDemand::_leaf_demand_sum);
        external(ROOT_DEMAND_COEF, &RootDemand::_root_demand_coef);
        external(GROW, &RootDemand::_grow);
        external(PHASE, &RootDemand::_phase);
    }

    virtual ~RootDemand()
    { }

    void compute(double t, bool /* update */)
    {
        if (_first_day == t) {
            _root_demand = _leaf_demand_sum * _root_demand_coef;
            _last_value = _root_demand;
            _root_biomass = _root_demand;

            // std::cout << "ROOT_DEMAND: " << _root_demand << " "
            //           << _leaf_demand_sum << " " << _root_demand_coef
            //           << std::endl;

        } else {
            if (_phase == ecomeristem::plant::NOGROWTH) {
                _root_demand = 0;
                _last_value= 0;
            } else {
                if (_leaf_demand_sum_1 == 0) {
                    _root_demand = _last_value * _root_demand_coef;
                } else {
                    _root_demand = _leaf_demand_sum_1 * _root_demand_coef;
                }
                if (_leaf_demand_sum_1 != 0) {
                    _last_value = _leaf_demand_sum_1;
            } else {
                    _last_value = 0;
                }
            }
            _root_biomass = _root_demand;
        }
    }

    void init(double t,
              const model::models::ModelParameters& /* parameters */)
    {
        _root_demand = 0;
        _root_biomass = 0;
        _last_value= 0;
        _first_day = t;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == LEAF_DEMAND_SUM and !is_ready(t, LEAF_DEMAND_SUM)) {
            _leaf_demand_sum_1 = _leaf_demand_sum;
        }
        AbstractAtomicModel < RootDemand >::put(t, index, value);
    }

private:
// internal variable
    double _root_demand;
    double _root_biomass;
    double _first_day;
    double _last_value;

// external variables
    double _leaf_demand_sum;
    double _leaf_demand_sum_1;
    double _root_demand_coef;
    double _grow;
    double _phase;
};

} } // namespace ecomeristem root

#endif

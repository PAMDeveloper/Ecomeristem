/**
 * @file leaf/LeafDemand.hpp
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

#ifndef __ECOMERISTEM_LEAF_LEAF_DEMAND_HPP
#define __ECOMERISTEM_LEAF_LEAF_DEMAND_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/Manager.hpp>

namespace ecomeristem { namespace leaf {

class LeafDemand : public AbstractAtomicModel < LeafDemand >
{
public:
    enum internals { DEMAND };
    enum externals { BIOMASS, GROW, PHASE };

    LeafDemand()
    {
        internal(DEMAND, &LeafDemand::_demand);
        external(BIOMASS, &LeafDemand::_biomass);
        external(GROW, &LeafDemand::_grow);
        external(PHASE, &LeafDemand::_phase);
    }

    virtual ~LeafDemand()
    { }

    void compute(double t, bool /* update */)
    {
        if (_first_day == t) {
            _demand = _biomass;
        } else {
            if (_phase != plant::LIG) {
                _demand = _biomass - _biomass_1;
            } else {
                _demand = 0;
            }
        }
    }

    void init(double t,
              const model::models::ModelParameters& /* parameters */)
    {
        _first_day = t;
        _biomass = 0;
        _biomass_1 = 0;
        _demand = 0;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == BIOMASS and !is_ready(t, BIOMASS)) {
            _biomass_1 = _biomass;
        }
        AbstractAtomicModel < LeafDemand >::put(t, index, value);
    }

private:
// internal variable
    double _demand;
    double _first_day;

// external variables
    double _biomass;
    double _biomass_1;
    double _grow;
    double _phase;
};

} } // namespace ecomeristem leaf

#endif
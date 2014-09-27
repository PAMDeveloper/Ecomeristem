/**
 * @file leaf/LastDemand.hpp
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

#ifndef __ECOMERISTEM_LEAF_LAST_DEMAND_HPP
#define __ECOMERISTEM_LEAF_LAST_DEMAND_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/Manager.hpp>

namespace ecomeristem { namespace leaf {

class LastDemand : public AbstractAtomicModel < LastDemand >
{
public:
    enum internals { LAST_DEMAND };
    enum externals { BIOMASS, PHASE };

    LastDemand()
    {
        internal(LAST_DEMAND, &LastDemand::_last_demand);
        external(BIOMASS, &LastDemand::_biomass);
        external(PHASE, &LastDemand::_phase);
    }

    virtual ~LastDemand()
    { }

    void compute(double t, bool /* update */)
    {
       if (_first_day == t) {
           _last_demand = 0;
        } else {
            if (_phase != plant::LIG) {
                _last_demand = _biomass - _biomass_1;
            } else {
                _last_demand = 0;
            }
        }

       // std::cout << "LAST_DEMAND: " << _last_demand << " " << _biomass
       //           << " " << _biomass_1 << std::endl;

    }

    void init(double t,
              const model::models::ModelParameters& /* parameters */)
    {
        _first_day = t;
        _biomass_1 = 0;
        _biomass = 0;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == BIOMASS and !is_ready(t, BIOMASS)) {
            _biomass_1 = _biomass;
        }
        AbstractAtomicModel < LastDemand >::put(t, index, value);
    }

private:
// internal variable
    double _last_demand;
    double _first_day;

// external variables
    double _biomass;
    double _biomass_1;
    double _phase;
};

} } // namespace ecomeristem leaf

#endif
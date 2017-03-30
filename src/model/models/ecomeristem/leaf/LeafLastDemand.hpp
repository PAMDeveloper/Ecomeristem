/**
 * @file leaf/LastDemand.hpp
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

#ifndef __ECOMERISTEM_LEAF_LAST_DEMAND_HPP
#define __ECOMERISTEM_LEAF_LAST_DEMAND_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

class LeafLastDemand : public ecomeristem::AbstractAtomicModel < LeafLastDemand >
{
public:
    enum internals { LAST_DEMAND };
    enum externals { BIOMASS, PHASE };

    LeafLastDemand()
    {
        internal(LAST_DEMAND, &LeafLastDemand::_last_demand);
        external(BIOMASS, &LeafLastDemand::_biomass);
        external(PHASE, &LeafLastDemand::_phase);
    }

    virtual ~LeafLastDemand()
    { }

    void compute(double t, bool update)
    {
        if (update and _lig) {
            _lig = false;
        }
        if (_first_day == t) {
           _last_demand = 0;
        } else {
            if (!_lig and _phase == leaf::LIG) {
                _last_demand = _biomass - _biomass_1;
                _lig = true;
            } else {
                _last_demand = 0;
            }
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_LAST_DEMAND", t, artis::utils::COMPUTE)
            << "LastDemand = " << _last_demand
            << " ; phase = " << _phase
            << " ; Biomass = " << _biomass
            << " ; Biomass[-1] = " << _biomass_1
            << " ; Biomass[-2] = " << _biomass_2
            << " ; lig = " << _lig;
        utils::Trace::trace().flush();
#endif

    }

    void init(double t,
              const model::models::ModelParameters& /* parameters */)
    {
        _first_day = t;
        _biomass_2 = 0;
        _biomass_1 = 0;
        _biomass = 0;
        _lig = false;
    }

    void put(double t, unsigned int index, double value)
    {

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_LAST_DEMAND", t, artis::utils::PUT)
            << "Index = " << index
            << " ; value = " << value
            << " ; biomass = " << _biomass
            << " ; phase = " << _phase;
        utils::Trace::trace().flush();
#endif

        if (index == BIOMASS and !is_ready(t, BIOMASS)) {
            _biomass_2 = _biomass_1;
            _biomass_1 = _biomass;
        }
        ecomeristem::AbstractAtomicModel < LeafLastDemand >::put(t, index, value);
    }

private:
// internal variable
    double _last_demand;
    double _first_day;
    double _lig;

// external variables
    double _biomass;
    double _biomass_2;
    double _biomass_1;
    double _phase;
};

} } // namespace ecomeristem leaf

#endif

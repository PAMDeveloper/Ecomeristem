/**
 * @file leaf/LeafDemand.hpp
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

#ifndef __ECOMERISTEM_LEAF_LEAF_DEMAND_HPP
#define __ECOMERISTEM_LEAF_LEAF_DEMAND_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

class LeafDemand : public ecomeristem::AbstractAtomicModel < LeafDemand >
{
public:
    enum internals { DEMAND };
    enum externals { BIOMASS, GROW, PHASE };

    LeafDemand(int index) : _index(index)
    {
        internal(DEMAND, &LeafDemand::_demand);
        external(BIOMASS, &LeafDemand::_biomass);
        external(GROW, &LeafDemand::_grow);
        external(PHASE, &LeafDemand::_phase);
    }

    virtual ~LeafDemand()
    { }

    bool check(double t) const
    { return is_ready(t, BIOMASS); }

    void compute(double t, bool update)
    {
        if (_first_day == t) {
            _demand = _biomass;
        } else {
            if (_phase != leaf::LIG) {
                _demand = _biomass - _biomass_1;
            } else {
                _demand = 0;
            }
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_DEMAND", t, artis::utils::COMPUTE)
            << "Demand = " << _demand
            << " ; phase = " << _phase
            << " ; index = " << _index
            << " ; Biomass = " << _biomass
            << " ; Biomass[-1] = " << _biomass_1
            << " ; lig = " << _lig
            << " ; update = " << update;
        utils::Trace::trace().flush();
#endif

    }

    void init(double t,
              const model::models::ModelParameters& /* parameters */)
    {
        _lig = false;
        _first_day = t;
        _grow = 0;
        _biomass = 0;
        _biomass_1 = 0;
        _demand = 0;
    }

    void put(double t, unsigned int index, double value)
    {

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_DEMAND", t, artis::utils::PUT)
            << "Index = " << index
            << " ; value = " << value
            << " ; biomass = " << _biomass
            << " ; grow = " << _grow
            << " ; phase = " << _phase;
        utils::Trace::trace().flush();
#endif

        if (index == BIOMASS and !is_ready(t, BIOMASS)) {
            _biomass_1 = _biomass;
        }
        ecomeristem::AbstractAtomicModel < LeafDemand >::put(t, index, value);
    }

private:
// parameters
    int _index;

// internal variable
    double _demand;
    double _first_day;
    bool _lig;

// external variables
    double _biomass;
    double _biomass_1;
    double _grow;
    double _phase;
};

} } // namespace ecomeristem leaf

#endif

/**
 * @file internode/InternodeDemand.hpp
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

#ifndef __ECOMERISTEM_INTERNODE_INTERNODE_DEMAND_HPP
#define __ECOMERISTEM_INTERNODE_INTERNODE_DEMAND_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace internode {

class InternodeDemand : public ecomeristem::AbstractAtomicModel < InternodeDemand >
{
public:
    enum internals { DEMAND };
    enum externals { BIOMASS, PHASE };

    InternodeDemand(int index) : _index(index)
    {
        internal(DEMAND, &InternodeDemand::_demand);

        external(BIOMASS, &InternodeDemand::_biomass);
        external(PHASE, &InternodeDemand::_phase);
    }

    virtual ~InternodeDemand()
    { }

    bool check(double t) const
    { return is_ready(t, BIOMASS); }

    void compute(double t, bool /* update */)
    {
        if (_phase == internode::MATURITY or
            _phase == internode::MATURITY_NOGROWTH) {
            _demand = 0;
        } else {
            _demand = _biomass - _biomass_1;
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("INTERNODE_DEMAND", t, artis::utils::COMPUTE)
            << "Demand = " << _demand
            << " ; index = " << _index
            << " ; Biomass = " << _biomass
            << " ; Biomass[-1] = " << _biomass_1;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _biomass = 0;
        _biomass_1 = 0;
        _demand = 0;
    }

    void put(double t, unsigned int index, double value)
    {

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("INTERNODE_DEMAND", t, artis::utils::PUT)
            << "Index = " << index
            << " ; value = " << value
            << " ; biomass = " << _biomass;
        utils::Trace::trace().flush();
#endif

        if (index == BIOMASS and !is_ready(t, BIOMASS)) {
            _biomass_1 = _biomass;
        }
        ecomeristem::AbstractAtomicModel < InternodeDemand >::put(t, index,
                                                                  value);
    }

private:
// parameters
    int _index;

// internal variable
    double _demand;

// external variables
    double _biomass;
    double _biomass_1;
    double _phase;
};

} } // namespace ecomeristem internode

#endif

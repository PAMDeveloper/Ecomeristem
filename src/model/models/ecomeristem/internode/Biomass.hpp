/**
 * @file internode/Biomass.hpp
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

#ifndef __ECOMERISTEM_INTERNODE_BIOMASS_HPP
#define __ECOMERISTEM_INTERNODE_BIOMASS_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace internode {

class Biomass : public ecomeristem::AbstractAtomicModel < Biomass >
{
public:
    enum internals { BIOMASS };
    enum externals { VOLUME };

    Biomass(int index) : _index(index)
    {
        internal(BIOMASS, &Biomass::_biomass);

        external(VOLUME, &Biomass::_volume);
    }

    virtual ~Biomass()
    { }

    void compute(double t, bool /* update */)
    {
        _biomass = _volume * _density;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("INTERNODE_BIOMASS", t, artis::utils::COMPUTE)
            << "Biomass = " << _biomass
            << " ; index = " << _index
            << " ; volume = " << _volume;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _density = parameters.get < double >("density_IN");
        _biomass = 0;
    }

private:
// parameters
    double _density;

// internal variable
    double _biomass;
    int _index;

// external variables
    double _volume;
};

} } // namespace ecomeristem internode

#endif

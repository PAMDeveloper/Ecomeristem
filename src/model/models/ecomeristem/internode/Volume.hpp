/**
 * @file internode/Volume.hpp
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

#ifndef __ECOMERISTEM_INTERNODE_VOLUME_HPP
#define __ECOMERISTEM_INTERNODE_VOLUME_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

//#include <cmath>
//#define _USE_MATH_DEFINES
#ifndef MLOCAL_PI
   #define MLOCAL_PI 3.141592653589793238462643383279502884197169399375
#endif

namespace ecomeristem { namespace internode {

class Volume : public AbstractAtomicModel < Volume >
{
public:
    enum internals { VOLUME };
    enum externals { LEN, DIAMETER };

    Volume()
    {
        internal(VOLUME, &Volume::_volume);

        external(LEN, &Volume::_len);
        external(DIAMETER, &Volume::_diameter);
    }

    virtual ~Volume()
    { }

    void compute(double t, bool /* update */)
    {
        double radius = _diameter / 2;

        _volume = _len * MLOCAL_PI * radius * radius;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("INTERNODE_VOLUME", t, artis::utils::COMPUTE)
            << "Volume = " << _volume
            << " ; len = " << _len
            << " ; diameter = " << _diameter;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _volume = 0;
    }

private:
// internal variable
    double _volume;

// external variables
    double _len;
    double _diameter;
};

} } // namespace ecomeristem internode

#endif

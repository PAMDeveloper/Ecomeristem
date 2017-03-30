/**
 * @file thermal-time/TT.hpp
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_TT_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_TT_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class Tt : public ecomeristem::AbstractAtomicModel < Tt >
{
public:
    static const unsigned int TT = 0;
    static const unsigned int DELTA_T = 0;

    Tt()
    {
        internal(TT, &Tt::_TT);
        external(DELTA_T, &Tt::_DeltaT);
    }

    virtual ~Tt()
    { }

    void compute(double /* t */, bool /* update */)
    {
        _TT = _TT + _DeltaT;
    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _TT = 0;
    }

private:
// internal variable
    double _TT;

// external variables
    double _DeltaT;
};

} } } // namespace ecomeristem plant thermal_time

#endif

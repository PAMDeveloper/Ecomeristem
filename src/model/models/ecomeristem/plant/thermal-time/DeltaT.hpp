/**
 * @file thermal-time/DeltaT.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2014 INRA http://www.cirad.fr
 * Copyright (C) 2014 ULCO http://www.univ-littoral.fr
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_DELAT_T_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_DELAT_T_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class DeltaT : public AbstractAtomicModel < DeltaT >
{
public:
    static const unsigned int DELTA_T = 0;
    static const unsigned int TA = 0;

    DeltaT()
    {
        internal(DELTA_T, &DeltaT::_deltaT);
        external(TA, &DeltaT::_Ta);
    }

    virtual ~DeltaT()
    { }

    void compute(double /* t */)
    { _deltaT = _Ta - _Tb; }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _Tb = parameters.get < double >("Tb");
        _deltaT = 0;
    }

private:
    // parameters
    double _Tb;

    // internal variable
    double _deltaT;

    // external variable
    double _Ta;
};

} } } // namespace ecomeristem plant thermal_time

#endif

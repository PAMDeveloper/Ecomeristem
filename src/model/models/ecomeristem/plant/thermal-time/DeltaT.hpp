/**
 * @file thermal-time/DeltaT.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2015 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2015 ULCO http://www.univ-littoral.fr
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
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class DeltaT : public ecomeristem::AbstractAtomicModel < DeltaT >
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

    bool check(double t) const
    { return is_ready(t, TA); }

    void compute(double t, bool /* update */)
    {
        _deltaT = _Ta - _Tb;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("DELTA_T", t, artis::utils::COMPUTE)
            << "DeltaT = " << _deltaT << " ; Ta = " << _Ta
            << " ; Tb = " << _Tb;
        utils::Trace::trace().flush();
#endif

    }

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

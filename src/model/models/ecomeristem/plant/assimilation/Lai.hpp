/**
 * @file assimilation/Lai.hpp
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

#ifndef __ECOMERISTEM_PLANT_ASSIMILATION_LAI_HPP
#define __ECOMERISTEM_PLANT_ASSIMILATION_LAI_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace assimilation {

class Lai : public ecomeristem::AbstractAtomicModel < Lai >
{
public:
    static const unsigned int LAI = 0;

    static const unsigned int FCSTR = 0;
    static const unsigned int PAI = 1;

    Lai()
    {
        internal(LAI, &Lai::_lai);
        external(FCSTR, &Lai::_fcstr);
        external(PAI, &Lai::_PAI);
    }

    virtual ~Lai()
    { }

    bool check(double t) const
    { return is_ready(t, PAI) and is_ready(t, FCSTR); }

    void compute(double t, bool /* update */)
    {
        _lai = _PAI * (_rolling_B + _rolling_A * _fcstr) * _density / 1.e4;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LAI", t, artis::utils::COMPUTE)
            << "lai = " << _lai << " ; fcstr = " << _fcstr
            << " ; PAI = " << _PAI << " ; rollingA = "
            << _rolling_A << " ; rollingB = " << _rolling_B;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _density = parameters.get < double >("density");
        _rolling_A = parameters.get < double >("Rolling_A");
        _rolling_B = parameters.get < double >("Rolling_B");
        _lai = 0;
    }

private:
// parameters
    double _density;
    double _rolling_A;
    double _rolling_B;

// internal variable
    double _lai;

// external variables
    double _fcstr;
    double _PAI;
};

} } } // namespace ecomeristem plant assimilation

#endif

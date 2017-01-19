/**
 * @file assimilation/AssimPot.hpp
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

#ifndef __ECOMERISTEM_PLANT_ASSIMILATION_ASSIM_POT_HPP
#define __ECOMERISTEM_PLANT_ASSIMILATION_ASSIM_POT_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace assimilation {

class AssimPot : public ecomeristem::AbstractAtomicModel < AssimPot >
{
public:
    enum internals { ASSIM_POT };
    enum externals { CSTR, INTERC, RADIATION };

    AssimPot()
    {
        internal(ASSIM_POT, &AssimPot::_assim_pot);

        external(CSTR, &AssimPot::_cstr);
        external(INTERC, &AssimPot::_interc);
        external(RADIATION, &AssimPot::_radiation);
    }

    virtual ~AssimPot()
    { }

    bool check(double t) const
    { return is_ready(t, CSTR) and is_ready(t, INTERC) and
            is_ready(t, RADIATION); }

    void compute(double t, bool /* update */)
    {
        _assim_pot = std::pow(_cstr, _power_for_cstr) * _interc * _epsib *
            _radiation * _kpar;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("ASSIM_POT", t, artis::utils::COMPUTE)
            << "assim_pot = " << _assim_pot << " ; cstr = " << _cstr
            << " ; power_for_cstr = " << _power_for_cstr << " ; interc = "
            << _interc << " ; epsib = " << _epsib << " ; radiation = "
            << _radiation << " ; kpar = " << _kpar;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _power_for_cstr = parameters.get < double >("power_for_cstr");
        _kpar = 1; // parameters.get < double >("Kpar");
        _epsib = parameters.get < double >("Epsib");
        _assim_pot = 0;
    }

private:
// parameters
    double _power_for_cstr;
    double _kpar;
    double _epsib;

// internal variable
    double _assim_pot;

// external variables
    double _cstr;
    double _interc;
    double _radiation;
};

} } } // namespace ecomeristem plant assimilation

#endif

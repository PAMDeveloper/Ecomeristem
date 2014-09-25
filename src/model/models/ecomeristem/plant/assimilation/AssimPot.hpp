/**
 * @file assimilation/AssimPot.hpp
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

#ifndef __ECOMERISTEM_PLANT_ASSIMILATION_ASSIM_POT_HPP
#define __ECOMERISTEM_PLANT_ASSIMILATION_ASSIM_POT_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace assimilation {

class AssimPot : public AbstractAtomicModel < AssimPot >
{
public:
    static const unsigned int ASSIM_POT = 0;
    static const unsigned int CSTR = 0;
    static const unsigned int INTERC = 1;
    static const unsigned int RADIATION = 2;

    AssimPot()
    {
        internal(ASSIM_POT, &AssimPot::_assim_pot);
        external(CSTR, &AssimPot::_cstr);
        external(INTERC, &AssimPot::_interc);
        external(RADIATION, &AssimPot::_radiation);
        _power_for_cstr = 0.5;
        _kpar = 1;
        _epsib = 3.5;
    }

    virtual ~AssimPot()
    { }

    void compute(double /* t */)
    {
        _assim_pot = std::pow(_cstr, _power_for_cstr) * _interc * _epsib *
            _radiation * _kpar;

        // std::cout << "ASSIMPOT: " << _assim_pot << " " << _cstr << " "
        //           << _power_for_cstr << " "
        //           << _interc << " " << _epsib << " " << _radiation << " "
        //           << _kpar << std::endl;

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

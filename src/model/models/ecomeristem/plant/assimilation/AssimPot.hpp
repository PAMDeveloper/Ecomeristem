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

namespace ecomeristem { namespace plant { namespace assimilation {

class AssimPot
{
public:
    AssimPot()
    {
        power_for_cstr = 0.5;
        Kpar = 1;
        Epsib = 3.5;
    }

    virtual ~AssimPot()
    { }

    void assign_cstr(double value)
    {
        cstr = value;
    }

    void assign_Interc(double value)
    {
        interc = value;
    }

    void assign_Radiation(double value)
    {
        Radiation = value;
    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        power_for_cstr = parameters.get("power_for_cstr");
        Kpar = parameters.get("Kpar");
        Epsib = parameters.get("Epsib");
        _assimPot = 0;
    }

private:
    void compute(double /* t */)
    {
        _assimPot = std::pow(cstr, power_for_cstr) * interc * Epsib *
            Radiation * Kpar;
    }

// parameters
    double power_for_cstr;
    double Kpar;
    double Epsib;

// internal variable
    double _assimPot;

// external variables
    double cstr;
    double interc;
    double Radiation;
};

} } } // namespace ecomeristem plant assimilation

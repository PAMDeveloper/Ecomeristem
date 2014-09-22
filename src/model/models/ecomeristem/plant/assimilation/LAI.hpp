/**
 * @file assimilation/LAI.hpp
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

class LAI
{
public:
    LAI()
    {
        density = 30;
        rolling_A = 0.7;
        rolling_B = 0.3;
        _PAI = 1;
    }

    virtual ~LAI()
    { }

    void assign_fcstr(double value)
    {
        _fcstr = value;
    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        density = parameters.get("density");
        rolling_A = parameters.get("rolling_A");
        rolling_B = parameters.get("rolling_B");
        _lai = 0;
    }

private:
    void compute(double /* t */)
    {
        _lai = _PAI * (rolling_B + rolling_A * _fcstr) * density / 1.e4;
    }

// parameters
    double density;
    double rolling_A;
    double rolling_B;

// internal variable
    double _lai;

// external variables
    double _fcstr;
    double _PAI;
};

} } } // namespace ecomeristem plant assimilation

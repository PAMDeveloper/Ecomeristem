/**
 * @file assimilation/Interc.hpp
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

class Interc
{
public:
    Interc()
    {
        Kdf = 0.65;
    }

    virtual ~Interc()
    { }

    void assign_LAI(double value)
    {
        _lai = value;
    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        Kdf = parameters.get("Kdf");
        _interc = 0;
        return 0;
    }

private:
    void compute(double /* t */)
    {
        _interc = 1. - std::exp(-Kdf * _lai);
    }

// parameters
    double Kdf;

// internal variable
    double _interc;

// external variables
    double _lai;
};

} } } // namespace ecomeristem plant assimilation

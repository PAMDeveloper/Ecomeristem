/**
 * @file assimilation/Assim.hpp
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

class Assim : public ecomeristem::Dynamics < >
{
public:
    Assim()
    {
        density = 30;
    }

    virtual ~Assim()
    { }

    void assign_RespMaint(double value)
    {
        RespMaint = value;
    }

    void assign_AssimPot(double value)
    {
        AssimPot = value;
    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        density = parameters.get("density");
        _assim = 0;
    }

    void compute(double t)
    {
        _assim = std::max(0., AssimPot / density - RespMaint);
    }

private:
// parameters
    double density;

// internal variable
    double _assim;

// external variables
    double RespMaint;
    double AssimPot;
};

} } } // namespace ecomeristem plant assimilation

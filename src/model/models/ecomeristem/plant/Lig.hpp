/**
 * @file plant/Lig.hpp
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

#ifndef __ECOMERISTEM_PLANT_LIG_HPP
#define __ECOMERISTEM_PLANT_LIG_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant {

class Lig : public ecomeristem::AbstractAtomicModel < Lig >
{
public:
    static const unsigned int LIG = 0;

    Lig()
    {
        internal(LIG, &Lig::_lig);
    }

    virtual ~Lig()
    { }

    void compute(double /* t */, bool /* update */)
    {
        // TODO
        if (j == 3 || j == 7 || j == 11 || j == 15 || j == 19 || j == 23 ||
            j == 26 || j == 29 || j == 34) {
            ++_lig;
        }
        ++j;
    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _lig = 0;
        j = 0;
    }

private:
    // internal variable
    double _lig;

    unsigned int j;
};

} } // namespace ecomeristem plant

#endif

/**
 * @file plant/Lig.hpp
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

#ifndef __ECOMERISTEM_PLANT_LIG_HPP
#define __ECOMERISTEM_PLANT_LIG_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant {

class Lig : public AbstractAtomicModel < Lig >
{
public:
    static const unsigned int LIG = 0;

    Lig()
    {
        internal(LIG, &Lig::_lig);
    }

    virtual ~Lig()
    { }

    void compute(double /* t */)
    { _lig = 0; }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    { _lig = 0; }

private:
    // internal variable
    double _lig;
};

} } // namespace ecomeristem plant

#endif
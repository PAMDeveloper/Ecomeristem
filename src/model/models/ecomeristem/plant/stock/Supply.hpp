/**
 * @file ecomeristem/plant/stock/Supply.hpp
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

#ifndef __ECOMERISTEM_PLANT_STOCK_SUPPLY_HPP
#define __ECOMERISTEM_PLANT_STOCK_SUPPLY_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace stock {

class Supply : public AbstractAtomicModel < Supply >
{
public:
    static const unsigned int SUPPLY = 0;
    static const unsigned int ASSIM = 0;

    Supply()
    {
        internal(SUPPLY, &Supply::_supply);
        external(ASSIM, &Supply::_assim);
    }

    virtual ~Supply()
    { }

    void compute(double /* t */)
    {
        _supply = _assim;
    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _supply = 0;
    }

private:
// internal variable
    double _supply;

// external variables
    double _assim;
};

} } } // namespace ecomeristem plant stock

#endif
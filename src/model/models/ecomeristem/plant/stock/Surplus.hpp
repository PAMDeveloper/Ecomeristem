/**
 * @file ecomeristem/plant/stock/Surplus.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2014 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2014 ULCO http://www.univ-littoral.fr
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

#ifndef __ECOMERISTEM_PLANT_STOCK_SURPLUS_HPP
#define __ECOMERISTEM_PLANT_STOCK_SURPLUS_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace stock {

class Surplus : public AbstractAtomicModel < Surplus >
{
public:
    static const int SURPLUS = 0;

    static const int DAY_DEMAND = 0;
    static const int RESERVOIR_DISPO = 1;
    static const int SEED_RES = 2;
    static const int SUPPLY = 3;

    Surplus()
    {
        internal(SURPLUS, &Surplus::_surplus);

        external(DAY_DEMAND, &Surplus::_day_demand);
        external(RESERVOIR_DISPO, &Surplus::_reservoir_dispo);
        external(SEED_RES, &Surplus::_seed_res);
        external(SUPPLY, &Surplus::_supply);
    }

    virtual ~Surplus()
    { }

    void compute(double /* t */)
    {
        if (_seed_res_1 > 0) {
            if (_seed_res_1 > _day_demand) {
                _surplus = std::max(0., _supply - _reservoir_dispo);
            } else {
                _surplus = std::max(0., _supply - (_day_demand - _seed_res) -
                                _reservoir_dispo);
            }
        } else {
            _surplus = std::max(0., _supply - _reservoir_dispo - _day_demand);
        }
    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _surplus = 0;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == SEED_RES and !is_ready(t, SEED_RES)) {
            _seed_res_1 = _seed_res;
        }
        AbstractAtomicModel < Surplus >::put(t, index, value);
    }

private:
// internal variable
    double _surplus;

// external variables
    double _day_demand;
    double _reservoir_dispo;
    double _seed_res;
    double _seed_res_1;
    double _supply;
};

} } } // namespace ecomeristem plant stock

#endif

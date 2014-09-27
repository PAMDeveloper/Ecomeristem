/**
 * @file ecomeristem/plant/stock/SeedRes.hpp
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

#ifndef __ECOMERISTEM_PLANT_STOCK_SEED_RES_HPP
#define __ECOMERISTEM_PLANT_STOCK_SEED_RES_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace stock {

class SeedRes : public AbstractAtomicModel < SeedRes >
{
public:
    static const int SEED_RES = 0;
    static const int DAY_DEMAND = 0;

    SeedRes()
    {
        internal(SEED_RES, &SeedRes::_seed_res);
        external(DAY_DEMAND, &SeedRes::_day_demand);
    }

    virtual ~SeedRes()
    { }

    void compute(double t, bool /* update */)
    {
        if (_first_day == t) {
            _seed_res = _gdw - _day_demand;
        } else {
            if (_seed_res_1 > 0) {
                if (_seed_res_1 > _day_demand) {
                    _seed_res_1 = _seed_res;
                    _seed_res = _seed_res_1 - _day_demand;
                } else {
                    _seed_res_1 = _seed_res;
                    _seed_res = 0;
                }
            } else {
                _seed_res_1 = _seed_res;
                _seed_res = 0;
            }
        }

        std::cout << "SEED_RES: " << _seed_res << " " << _seed_res_1 << " "
                  << _gdw << " " << _day_demand << std::endl;

    }

    void init(double t,
              const model::models::ModelParameters& parameters)
    {
        _gdw = parameters.get < double >("gdw");
        _seed_res_1 = 0;
        _seed_res = 0;
        _first_day = t;
    }

private:
// parameters
    double _gdw;

// internal variable
    double _seed_res;
    double _seed_res_1;
    double _first_day;

// external variables
    double _day_demand;
};

} } } // namespace ecomeristem plant stock

#endif

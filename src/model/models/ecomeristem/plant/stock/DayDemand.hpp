/**
 * @file ecomeristem/plant/stock/DayDemand.hpp
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

#ifndef __ECOMERISTEM_PLANT_STOCK_DAY_DEMAND_HPP
#define __ECOMERISTEM_PLANT_STOCK_DAY_DEMAND_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/Manager.hpp>

namespace ecomeristem { namespace plant { namespace stock {

class DayDemand : public AbstractAtomicModel < DayDemand >
{
public:
    static const int DAY_DEMAND = 0;

    static const int DEMAND_SUM = 0;
    static const int LEAF_LAST_DEMAND_SUM = 1;
    static const int GROW = 2;
    static const int PHASE = 3;

    DayDemand()
    {
        internal(DAY_DEMAND, &DayDemand::_day_demand);

        external(DEMAND_SUM, &DayDemand::_demand_sum);
        external(LEAF_LAST_DEMAND_SUM, &DayDemand::_leaf_last_demand_sum);
        external(GROW, &DayDemand::_grow);
        external(PHASE, &DayDemand::_phase);
    }

    virtual ~DayDemand()
    { }

    void compute(double /* t */, bool /* update */)
    {
        if (_phase == ecomeristem::plant::NOGROWTH) {
            _day_demand = 0;
        } else {
            _day_demand = _demand_sum + _leaf_last_demand_sum;
        }

        std::cout << "DAY_DEMAND: " << _day_demand << " " << _demand_sum
                  << " " << _leaf_last_demand_sum << std::endl;

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _day_demand = 0;
    }

private:
// internal variable
    double _day_demand;

// external variables
    double _demand_sum;
    double _leaf_last_demand_sum;
    double _grow;
    double _phase;
};

} } } // namespace ecomeristem plant stock

#endif

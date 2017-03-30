/**
 * @file ecomeristem/plant/stock/DayDemand.hpp
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

#ifndef __ECOMERISTEM_PLANT_STOCK_DAY_DEMAND_HPP
#define __ECOMERISTEM_PLANT_STOCK_DAY_DEMAND_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/PlantManager.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace stock {

class DayDemand : public ecomeristem::AbstractAtomicModel < DayDemand >
{
public:
    enum internals { DAY_DEMAND };
    enum externals { DEMAND_SUM, LEAF_LAST_DEMAND_SUM,
                     INTERNODE_LAST_DEMAND_SUM, GROW, PHASE };

    DayDemand()
    {
        internal(DAY_DEMAND, &DayDemand::_day_demand);

        external(DEMAND_SUM, &DayDemand::_demand_sum);
        external(LEAF_LAST_DEMAND_SUM, &DayDemand::_leaf_last_demand_sum);
        external(INTERNODE_LAST_DEMAND_SUM,
                 &DayDemand::_internode_last_demand_sum);
        external(GROW, &DayDemand::_grow);
        external(PHASE, &DayDemand::_phase);
    }

    virtual ~DayDemand()
    { }

    bool check(double t) const
    { return is_ready(t, DEMAND_SUM) and is_ready(t, LEAF_LAST_DEMAND_SUM)
            and is_ready(t, PHASE); }

    void compute(double t, bool update)
    {
        if (not update) {
            _stop = false;
        }
        if (_phase == ecomeristem::plant::NOGROWTH or
            _phase == ecomeristem::plant::NOGROWTH3 or
            _phase == ecomeristem::plant::NOGROWTH4 or _stop) {
            _day_demand = 0;
            if (not _stop) {
                _stop = _phase == ecomeristem::plant::NOGROWTH3 or
                    _phase == ecomeristem::plant::NOGROWTH4;
            }
        } else {
            if (_demand_sum == 0) {
                _day_demand = _leaf_last_demand_sum +
                    _internode_last_demand_sum;
            } else {
                _day_demand = _demand_sum + _leaf_last_demand_sum +
                    _internode_last_demand_sum;
            }

        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("DAY_DEMAND", t, artis::utils::COMPUTE)
            << "dayDemand = " << _day_demand
            << " ; phase = " << _phase
            << " ; stop = " << _stop
            << " ; update = " << update
            << " ; DemandSum = " << _demand_sum
            << " ; LeafLastdemand = " << _leaf_last_demand_sum
            << " ; InternodeLastdemand = " << _internode_last_demand_sum;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _day_demand = 0;
    }

private:
// internal variable
    double _day_demand;
    bool _stop;

// external variables
    double _demand_sum;
    double _leaf_last_demand_sum;
    double _internode_last_demand_sum;
    double _grow;
    double _phase;
};

} } } // namespace ecomeristem plant stock

#endif

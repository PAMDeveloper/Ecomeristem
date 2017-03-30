/**
 * @file ecomeristem/plant/stock/Surplus.hpp
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

#ifndef __ECOMERISTEM_PLANT_STOCK_SURPLUS_HPP
#define __ECOMERISTEM_PLANT_STOCK_SURPLUS_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace stock {

class StockSurplus : public ecomeristem::AbstractAtomicModel < StockSurplus >
{
public:
    enum internals { SURPLUS };
    enum externals { DAY_DEMAND, RESERVOIR_DISPO, SEED_RES, SUPPLY,
                     REALLOC_BIOMASS_SUM, CULM_SURPLUS_SUM, STATE };

    StockSurplus()
    {
        internal(SURPLUS, &StockSurplus::_surplus);

        external(DAY_DEMAND, &StockSurplus::_day_demand);
        external(RESERVOIR_DISPO, &StockSurplus::_reservoir_dispo);
        external(SEED_RES, &StockSurplus::_seed_res);
        external(SUPPLY, &StockSurplus::_supply);
        external(REALLOC_BIOMASS_SUM, &StockSurplus::_realloc_biomass_sum);
        external(CULM_SURPLUS_SUM, &StockSurplus::_culm_surplus_sum);
        external(STATE, &StockSurplus::_state);
    }

    virtual ~StockSurplus()
    { }

    bool check(double t) const
    { return is_ready(t, DAY_DEMAND) and is_ready(t, RESERVOIR_DISPO) and
            is_ready(t, SEED_RES) and is_ready(t, SUPPLY); }

    void compute(double t, bool /* update */)
    {
        if (_state == plant::ELONG) {
            _surplus = _culm_surplus_sum;
        } else {
            if (_seed_res_1 > 0) {
                if (_seed_res_1 > _day_demand) {
                    _surplus = std::max(0., _supply - _reservoir_dispo +
                                        _realloc_biomass_sum);
                } else {
                    _surplus = std::max(0., _supply -
                                        (_day_demand - _seed_res_1) -
                                        _reservoir_dispo + _realloc_biomass_sum);
                }
            } else {
                _surplus = std::max(0.,
                                    _supply - _reservoir_dispo - _day_demand +
                                    _realloc_biomass_sum);
            }
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("SURPLUS", t, artis::utils::COMPUTE)
            << "Surplus = " << _surplus
            << " ; SeedRes = " << _seed_res
            << " ; SeedRes[-1] = " << _seed_res_1
            << " ; ReservoirDispo = " << _reservoir_dispo
            << " ; Supply = " << _supply
            << " ; DayDemand = " << _day_demand
            << " ; ReallocBiomassSum = " << _realloc_biomass_sum
            << " ; State = " << _state;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _surplus = 0;
        _seed_res = parameters.get < double >("gdw");
        _seed_res_1 = parameters.get < double >("gdw");
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == SEED_RES and !is_ready(t, SEED_RES)) {
            _seed_res_1 = _seed_res;
        }
        ecomeristem::AbstractAtomicModel < StockSurplus >::put(t, index, value);
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
    double _realloc_biomass_sum;
    double _culm_surplus_sum;
    double _state;
};

} } } // namespace ecomeristem plant stock

#endif

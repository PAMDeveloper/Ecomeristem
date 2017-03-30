/**
 * @file ecomeristem/culm/Surplus.hpp
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

#ifndef __ECOMERISTEM_CULM_SURPLUS_HPP
#define __ECOMERISTEM_CULM_SURPLUS_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace culm {

class CulmSurplus : public ecomeristem::AbstractAtomicModel < CulmSurplus >
{
public:
    enum internals { SURPLUS };
    enum externals { PLANT_STOCK, PLANT_STATE, STOCK, SUPPLY,
                     MAX_RESERVOIR_DISPO, INTERNODE_DEMAND_SUM,
                     LEAF_DEMAND_SUM, INTERNODE_LAST_DEMAND_SUM,
                     LEAF_LAST_DEMAND_SUM, REALLOC_BIOMASS_SUM };

    CulmSurplus()
    {
        internal(SURPLUS, &CulmSurplus::_surplus);

        external(PLANT_STOCK, &CulmSurplus::_plant_stock);
        external(PLANT_STATE, &CulmSurplus::_plant_state);
        external(STOCK, &CulmSurplus::_stock);
        external(SUPPLY, &CulmSurplus::_supply);
        external(MAX_RESERVOIR_DISPO, &CulmSurplus::_max_reversoir_dispo);
        external(INTERNODE_DEMAND_SUM, &CulmSurplus::_internode_demand_sum);
        external(LEAF_DEMAND_SUM, &CulmSurplus::_leaf_demand_sum);
        external(INTERNODE_LAST_DEMAND_SUM,
                 &CulmSurplus::_internode_last_demand_sum);
        external(LEAF_LAST_DEMAND_SUM, &CulmSurplus::_leaf_last_demand_sum);
        external(REALLOC_BIOMASS_SUM, &CulmSurplus::_realloc_biomass_sum);
    }

    virtual ~CulmSurplus()
    { }

    virtual bool check(double t) const
    { return is_ready(t, PLANT_STATE) and is_ready(t, SUPPLY) and
            is_ready(t, MAX_RESERVOIR_DISPO) and
            is_ready(t, INTERNODE_DEMAND_SUM) and
            is_ready(t, LEAF_DEMAND_SUM) and
            is_ready(t, INTERNODE_LAST_DEMAND_SUM) and
            is_ready(t, LEAF_LAST_DEMAND_SUM) and
            is_ready(t, REALLOC_BIOMASS_SUM); }

    void compute(double t, bool update)
    {
        if (_plant_state == plant::ELONG) {
            if (_first_day < 0 or (update and _first_day == t)) {
                _surplus = std::max(0., _plant_stock_1 - _internode_demand_sum -
                                    _leaf_demand_sum - _leaf_last_demand_sum -
                                    _internode_last_demand_sum + _supply -
                                    _max_reversoir_dispo +
                                    _realloc_biomass_sum);
                _first_day = t;
            } else {
                _surplus = std::max(0., _stock_1 - _internode_demand_sum -
                                    _leaf_demand_sum - _leaf_last_demand_sum -
                                    _internode_last_demand_sum + _supply -
                                    _max_reversoir_dispo +
                                    _realloc_biomass_sum);
            }
        } else {
            _surplus = 0;
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM_SURPLUS", t, artis::utils::COMPUTE)
            << "Surplus = " << _surplus
            << " ; Plant state = " << _plant_state
            << " ; Plant stock = " << _plant_stock
            << " ; Plant stock_1 = " << _plant_stock_1
            << " ; Stock = " << _stock
            << " ; Stock_1 = " << _stock_1
            << " ; Supply = " << _supply
            << " ; MaxReservoirDispo = " << _max_reversoir_dispo
            << " ; LeafDemandSum = " << _leaf_demand_sum
            << " ; InternodeDemandSum = " << _internode_demand_sum
            << " ; LeafLastDemandSum = " << _leaf_last_demand_sum
            << " ; InternodeLastDemandSum = " << _internode_last_demand_sum
            << " ; ReallocBiomassSum = " << _realloc_biomass_sum;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _first_day = -1;
        _plant_stock_1 = _plant_stock = 0;
        _stock_1 = _stock = 0;
        _surplus = 0;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == PLANT_STOCK and !is_ready(t, PLANT_STOCK)) {
            _plant_stock_1 = _plant_stock;
        }
        if (index == STOCK and !is_ready(t, STOCK)) {
            _stock_1 = _stock;
        }
        ecomeristem::AbstractAtomicModel < CulmSurplus >::put(t, index, value);
    }

private:
// internal variables
    double _first_day;
    double _surplus;

// external variables
    double _plant_stock_1;
    double _stock_1;
    double _plant_stock;
    double _plant_state;
    double _stock;
    double _supply;
    double _max_reversoir_dispo;
    double _internode_demand_sum;
    double _leaf_demand_sum;
    double _internode_last_demand_sum;
    double _leaf_last_demand_sum;
    double _realloc_biomass_sum;
};

} } // namespace ecomeristem culm

#endif

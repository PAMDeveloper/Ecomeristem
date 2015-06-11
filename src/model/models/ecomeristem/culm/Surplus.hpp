/**
 * @file ecomeristem/culm/Surplus.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2015 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2015 ULCO http://www.univ-littoral.fr
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

class Surplus : public AbstractAtomicModel < Surplus >
{
public:
    enum internals { SURPLUS };
    enum externals { PLANT_STOCK, STOCK, SUPPLY, MAX_RESERVOIR_DISPO,
                     INTERNODE_DEMAND_SUM, LEAF_DEMAND_SUM,
                     INTERNODE_LAST_DEMAND_SUM, LEAF_LAST_DEMAND_SUM,
                     REALLOC_BIOMASS_SUM };

    Surplus()
    {
        internal(SURPLUS, &Surplus::_surplus);

        external(PLANT_STOCK, &Surplus::_plant_stock);
        external(STOCK, &Surplus::_stock);
        external(SUPPLY, &Surplus::_supply);
        external(MAX_RESERVOIR_DISPO, &Surplus::_max_reversoir_dispo);
        external(INTERNODE_DEMAND_SUM, &Surplus::_internode_demand_sum);
        external(LEAF_DEMAND_SUM, &Surplus::_leaf_demand_sum);
        external(INTERNODE_LAST_DEMAND_SUM,
                 &Surplus::_internode_last_demand_sum);
        external(LEAF_LAST_DEMAND_SUM, &Surplus::_leaf_last_demand_sum);
        external(REALLOC_BIOMASS_SUM, &Surplus::_realloc_biomass_sum);
    }

    virtual ~Surplus()
    { }

    void compute(double t, bool /* update */)
    {
        if (t == _first_day) {
            _surplus = std::max(0., _plant_stock_1 - _internode_demand_sum -
                                _leaf_demand_sum - _leaf_last_demand_sum -
                                _internode_last_demand_sum + _supply -
                                _max_reversoir_dispo + _realloc_biomass_sum);
        } else {
            _surplus = std::max(0., _stock_1 - _internode_demand_sum -
                                _leaf_demand_sum - _leaf_last_demand_sum -
                                _internode_last_demand_sum + _supply -
                                _max_reversoir_dispo + _realloc_biomass_sum);
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM_SURPLUS", t, utils::COMPUTE)
            << "Surplus = " << _surplus
            << " ; Stock = " << _stock
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

    void init(double t,
              const model::models::ModelParameters& /* parameters */)
    {
        _first_day = t;
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
        AbstractAtomicModel < Surplus >::put(t, index, value);
    }

private:
// internal variables
    double _first_day;
    double _surplus;

// external variables
    double _plant_stock_1;
    double _stock_1;
    double _plant_stock;
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

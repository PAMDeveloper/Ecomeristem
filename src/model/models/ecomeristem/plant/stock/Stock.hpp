/**
 * @file ecomeristem/plant/stock/Stock.hpp
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

#ifndef __ECOMERISTEM_PLANT_STOCK_STOCK_HPP
#define __ECOMERISTEM_PLANT_STOCK_STOCK_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace stock {

class Stock : public AbstractAtomicModel < Stock >
{
public:
    enum internals { STOCK, GROW, DEFICIT };
    enum externals { DAY_DEMAND, RESERVOIR_DISPO, SEED_RES, SUPPLY,
                     DELETED_LEAF_BIOMASS, REALLOC_BIOMASS_SUM,
                     DAILY_SENESCED_LEAF_BIOMASS, STATE, CULM_STOCK,
                     CULM_DEFICIT };

    Stock()
    {
        internal(STOCK, &Stock::_stock);
        internal(GROW, &Stock::_grow);
        internal(DEFICIT, &Stock::_deficit);

        external(DAY_DEMAND, &Stock::_day_demand);
        external(RESERVOIR_DISPO, &Stock::_reservoir_dispo);
        external(SEED_RES, &Stock::_seed_res);
        external(SUPPLY, &Stock::_supply);
        external(DELETED_LEAF_BIOMASS, &Stock::_deleted_leaf_biomass);
        external(REALLOC_BIOMASS_SUM, &Stock::_realloc_biomass_sum);
        external(STATE, &Stock::_state);
        external(CULM_STOCK, &Stock::_culm_stock);
        external(CULM_DEFICIT, &Stock::_culm_deficit);
    }

    virtual ~Stock()
    { }

    bool check(double t) const
    { return (_state == plant::ELONG) or
            (is_ready(t, DAY_DEMAND) and is_ready(t, RESERVOIR_DISPO)
             and is_ready(t, SEED_RES) and is_ready(t, SUPPLY)
             and is_ready(t, DELETED_LEAF_BIOMASS)
             and is_ready(t, REALLOC_BIOMASS_SUM)); }

    void compute(double t, bool update)
    {

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("STOCK", t, utils::COMPUTE)
            << "BEFORE Stock = " << _stock
            << " ; Stock[-1] = " << _stock_1
            << " ; SeedRes = " << _seed_res
            << " ; SeedRes[-1] = " << _seed_res_1
            << " ; deficit = " << _deficit
            << " ; ReservoirDispo = " << _reservoir_dispo
            << " ; Supply = " << _supply
            << " ; DayDemand = " << _day_demand
            << " ; ReallocBiomassSum = " << _realloc_biomass_sum
            << " ; CulmStock = " << _culm_stock
            << " ; CulmDeficit = " << _culm_deficit;
        utils::Trace::trace().flush();
#endif

        if (_state == plant::ELONG) {
            _stock = _culm_stock;
            _deficit = _culm_deficit;
        } else {
            double stock = 0;

            if (not update) {
                _stock_1 = _stock;
            }
            if (_seed_res > 0 or _seed_res_1 > 0) {
                if (_seed_res > _day_demand) {
                    stock = _stock_1 + std::min(_reservoir_dispo, _supply +
                                                _realloc_biomass_sum);
                } else {
                    stock = _stock_1 +
                        std::min(_reservoir_dispo,
                                 _supply - (_day_demand - _seed_res_1) +
                                 _realloc_biomass_sum);
                }
            } else {
                stock = _stock_1 + std::min(_reservoir_dispo,
                                            _supply - _day_demand +
                                            _realloc_biomass_sum);
            }
            _stock = std::max(0., _deficit + stock);
            _deficit = std::min(0., _deficit + stock);
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("STOCK", t, utils::COMPUTE)
            << "AFTER Stock = " << _stock
            << " ; Stock[-1] = " << _stock_1
            << " ; SeedRes = " << _seed_res
            << " ; SeedRes[-1] = " << _seed_res_1
            << " ; deficit = " << _deficit
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
        _realocationCoeff = parameters.get < double >("realocationCoeff");

        _stock_1 = 0;
        _stock = 0;
        _grow = 0;
        _deficit = 0;
        _stock_realloc = 0;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == SEED_RES and !is_ready(t, SEED_RES)) {
            _seed_res_1 = _seed_res;
        }
        AbstractAtomicModel < Stock >::put(t, index, value);
    }

    void realloc_biomass(double t, double value)
    {
        if (value > 0) {
            double qty = value * _realocationCoeff;

#ifdef WITH_TRACE
            utils::Trace::trace()
                << utils::TraceElement("STOCK", t, utils::COMPUTE)
                << "BEFORE stock = " << _stock
                << " ; Stock[-1] = " << _stock_1
                << " ; deficit = " << _deficit
                << " ; realloc biomass = " << qty;
            utils::Trace::trace().flush();
#endif

            _stock = std::max(0., qty + _deficit);
            _stock_1 = _stock;
            _deficit = std::min(0., qty + _deficit);

#ifdef WITH_TRACE
            utils::Trace::trace()
                << utils::TraceElement("STOCK", t, utils::COMPUTE)
                << "AFTER stock = " << _stock
                << " ; Stock[-1] = " << _stock_1
                << " ; deficit = " << _deficit
                << " ; realloc biomass = " << qty;
            utils::Trace::trace().flush();
#endif

        }
    }

private:
// parameters
    double _nbleaf_enabling_tillering;
    double _realocationCoeff;

// internal variables
    double _stock;
    double _stock_1;
    double _stock_realloc;
    double _grow;
    double _deficit;

// external variables
    double _day_demand;
    double _reservoir_dispo;
    double _seed_res;
    double _seed_res_1;
    double _supply;
    double _deleted_leaf_biomass;
    double _realloc_biomass_sum;
    double _state;
    double _culm_stock;
    double _culm_deficit;
};

} } } // namespace ecomeristem plant stock

#endif

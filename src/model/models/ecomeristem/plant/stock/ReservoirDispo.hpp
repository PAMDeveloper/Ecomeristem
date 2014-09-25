/**
 * @file ecomeristem/plant/stock/ReservoirDispo.hpp
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

#ifndef __ECOMERISTEM_PLANT_STOCK_RESERVOIR_DISPO_HPP
#define __ECOMERISTEM_PLANT_STOCK_RESERVOIR_DISPO_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace stock {

class ReservoirDispo : public AbstractAtomicModel < ReservoirDispo >
{
public:
    static const int RESERVOIR_DISPO = 0;

    static const int LEAF_BIOMASS_SUM = 0;
    static const int STOCK = 1;
    static const int GROW = 2;

    ReservoirDispo()
    {
        internal(RESERVOIR_DISPO, &ReservoirDispo::_reservoir_dispo);

        external(LEAF_BIOMASS_SUM, &ReservoirDispo::_leaf_biomass_sum);
        external(STOCK, &ReservoirDispo::_stock);
        external(GROW, &ReservoirDispo::_grow);
    }

    virtual ~ReservoirDispo()
    { }

    void compute(double t)
    {
        if (is_ready(t, STOCK)) {
            _reservoir_dispo = _leaf_stock_max * _leaf_biomass_sum - _stock_1;
        } else {
            _reservoir_dispo = _leaf_stock_max * _leaf_biomass_sum - _stock;
        }
    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _leaf_stock_max = parameters.get < double >("leaf_stock_max");
        _reservoir_dispo = 0;
        _stock_1 = 0;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == STOCK and !is_ready(t, STOCK)) {
            _stock_1 = _stock;
        }
        AbstractAtomicModel < ReservoirDispo >::put(t, index, value);
    }

private:
// parameters
    double _leaf_stock_max;

// internal variables
    double _reservoir_dispo;

// external variables
    double _leaf_biomass_sum;
    double _stock_1;
    double _stock;
    double _grow;
};

} } } // namespace ecomeristem plant stock

#endif

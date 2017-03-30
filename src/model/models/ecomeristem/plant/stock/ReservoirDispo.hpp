/**
 * @file ecomeristem/plant/stock/ReservoirDispo.hpp
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

#ifndef __ECOMERISTEM_PLANT_STOCK_RESERVOIR_DISPO_HPP
#define __ECOMERISTEM_PLANT_STOCK_RESERVOIR_DISPO_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace stock {

class ReservoirDispo : public ecomeristem::AbstractAtomicModel < ReservoirDispo >
{
public:
    enum internals { RESERVOIR_DISPO };
    enum externals { LEAF_BIOMASS_SUM, STOCK, GROW };

    ReservoirDispo()
    {
        internal(RESERVOIR_DISPO, &ReservoirDispo::_reservoir_dispo);

        external(LEAF_BIOMASS_SUM, &ReservoirDispo::_leaf_biomass_sum);
        external(STOCK, &ReservoirDispo::_stock);
        external(GROW, &ReservoirDispo::_grow);
    }

    virtual ~ReservoirDispo()
    { }

    virtual bool check(double t) const
    { return is_ready(t, LEAF_BIOMASS_SUM); }

    void compute(double t, bool /* update */)
    {
        if (is_ready(t, STOCK)) {
            _reservoir_dispo = _leaf_stock_max * _leaf_biomass_sum - _stock_1;
        } else {
            _reservoir_dispo = _leaf_stock_max * _leaf_biomass_sum - _stock;
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("RESERVOIR_DISPO", t, artis::utils::COMPUTE)
            << "ReservoirDispo = " << _reservoir_dispo
            << " ; stock = " << _stock
            << " ; stock[-1] = " << _stock_1
            << " ; LeafBiomassSum = " << _leaf_biomass_sum
            << " ; LeafStockMax = " << _leaf_stock_max;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _leaf_stock_max = parameters.get < double >("leaf_stock_max");
        _reservoir_dispo = 0;
        _stock = 0;
        _stock_1 = 0;
    }

    void put(double t, unsigned int index, double value)
    {

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("RESERVOIR_DISPO", t, artis::utils::PUT)
            << "index  = " << index
            << " ; value = " << value;
        utils::Trace::trace().flush();
#endif

        if (index == STOCK and !is_ready(t, STOCK)) {
            _stock_1 = _stock;
        }
        ecomeristem::AbstractAtomicModel < ReservoirDispo >::put(t, index,
                                                                 value);
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

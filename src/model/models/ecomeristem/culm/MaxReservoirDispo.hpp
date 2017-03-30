/**
 * @file ecomeristem/culm/MaxReservoirDispo.hpp
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

#ifndef __ECOMERISTEM_CULM_MAX_RESERVOIR_DISPO_HPP
#define __ECOMERISTEM_CULM_MAX_RESERVOIR_DISPO_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace culm {

class MaxReservoirDispo : public ecomeristem::AbstractAtomicModel < MaxReservoirDispo >
{
public:
    enum internals { MAX_RESERVOIR_DISPO };
    enum externals { LEAF_BIOMASS_SUM, INTERNODE_BIOMASS_SUM };

    MaxReservoirDispo()
    {
        internal(MAX_RESERVOIR_DISPO,
                 &MaxReservoirDispo::_max_reversoir_dispo);

        external(LEAF_BIOMASS_SUM, &MaxReservoirDispo::_leaf_biomass_sum);
        external(INTERNODE_BIOMASS_SUM,
                 &MaxReservoirDispo::_internode_biomass_sum);
    }

    virtual ~MaxReservoirDispo()
    { }

    void compute(double t, bool /* update */)
    {
        _max_reversoir_dispo = _maximum_reserve_in_internode *
            _internode_biomass_sum + _leaf_stock_max * _leaf_biomass_sum;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM_MAX_RESERVOIR_DISPO",
                                   t, artis::utils::COMPUTE)
            << "MaxReservoirDispo = " << _max_reversoir_dispo
            << " ; InternodeBiomassSum = " << _internode_biomass_sum
            << " ; LeafBiomassSum = " << _leaf_biomass_sum
            << " ; LeafStockMax = " << _leaf_stock_max
            << " ; MaximumReserveInInternode = "
            << _maximum_reserve_in_internode;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _maximum_reserve_in_internode =
            parameters.get < double >("maximumReserveInInternode");
        _leaf_stock_max = parameters.get < double >("leaf_stock_max");
        _max_reversoir_dispo = 0;
    }

private:
// parameters
    double _maximum_reserve_in_internode;
    double _leaf_stock_max;

// internal variables
    double _max_reversoir_dispo;

// external variables
    double _leaf_biomass_sum;
    double _internode_biomass_sum;
};

} } // namespace ecomeristem culm

#endif

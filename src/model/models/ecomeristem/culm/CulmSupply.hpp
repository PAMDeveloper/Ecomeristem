/**
 * @file ecomeristem/culm/Supply.hpp
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

#ifndef __ECOMERISTEM_CULM_SUPPLY_HPP
#define __ECOMERISTEM_CULM_SUPPLY_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace culm {

class CulmSupply : public ecomeristem::AbstractAtomicModel < CulmSupply >
{
public:
    enum internals { SUPPLY };
    enum externals { ASSIM, LEAF_BIOMASS_SUM, PLANT_LEAF_BIOMASS_SUM };

    CulmSupply()
    {
        internal(SUPPLY, &CulmSupply::_supply);

        external(ASSIM, &CulmSupply::_assim);
        external(LEAF_BIOMASS_SUM, &CulmSupply::_leaf_biomass_sum);
        external(PLANT_LEAF_BIOMASS_SUM, &CulmSupply::_plant_leaf_biomass_sum);
    }

    virtual ~CulmSupply()
    { }

    void compute(double t, bool /* update */)
    {
        _supply = _assim * _leaf_biomass_sum / _plant_leaf_biomass_sum;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM_SUPPLY", t, artis::utils::COMPUTE)
            << "Supply = " << _supply
            << " ; Assim = " << _assim
            << " ; LeafBiomassSum = " << _leaf_biomass_sum
            << " ; PlantLeafBiomassSum = " << _plant_leaf_biomass_sum;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _supply = _assim * _leaf_biomass_sum / _plant_leaf_biomass_sum;
    }

private:
// internal variables
    double _supply;

// external variables
    double _assim;
    double _leaf_biomass_sum;
    double _plant_leaf_biomass_sum;
};

} } // namespace ecomeristem culm

#endif

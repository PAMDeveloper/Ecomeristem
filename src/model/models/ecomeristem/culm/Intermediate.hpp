/**
 * @file ecomeristem/culm/Intermediate.hpp
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

#ifndef __ECOMERISTEM_CULM_INTERMEDIATE_HPP
#define __ECOMERISTEM_CULM_INTERMEDIATE_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace culm {

class Intermediate : public ecomeristem::AbstractAtomicModel < Intermediate >
{
public:
    enum internals { INTERMEDIATE };
    enum externals { LEAF_BIOMASS_SUM, INTERNODE_BIOMASS_SUM,
                     PLANT_BIOMASS_SUM, SUPPLY, PLANT_STOCK, PLANT_DEFICIT,
                     INTERNODE_DEMAND_SUM, LEAF_DEMAND_SUM,
                     INTERNODE_LAST_DEMAND_SUM, LEAF_LAST_DEMAND_SUM,
                     REALLOC_BIOMASS_SUM };

    Intermediate()
    {
        internal(INTERMEDIATE, &Intermediate::_intermediate);

        external(LEAF_BIOMASS_SUM, &Intermediate::_leaf_biomass_sum);
        external(INTERNODE_BIOMASS_SUM, &Intermediate::_internode_biomass_sum);
        external(PLANT_BIOMASS_SUM, &Intermediate::_plant_biomass_sum);
        external(SUPPLY, &Intermediate::_supply);
        external(PLANT_STOCK, &Intermediate::_plant_stock);
        external(PLANT_DEFICIT, &Intermediate::_plant_deficit);
        external(INTERNODE_DEMAND_SUM, &Intermediate::_internode_demand_sum);
        external(LEAF_DEMAND_SUM, &Intermediate::_leaf_demand_sum);
        external(INTERNODE_LAST_DEMAND_SUM,
                 &Intermediate::_internode_last_demand_sum);
        external(LEAF_LAST_DEMAND_SUM, &Intermediate::_leaf_last_demand_sum);
        external(REALLOC_BIOMASS_SUM, &Intermediate::_realloc_biomass_sum);
    }

    virtual ~Intermediate()
    { }

    void compute(double t, bool /* update */)
    {

        double stock = _plant_stock_1 * (_leaf_biomass_sum +
                                         _internode_biomass_sum) /
            _plant_biomass_sum;
        double deficit = _plant_deficit_1 * (_leaf_biomass_sum +
                                             _internode_biomass_sum) /
            _plant_biomass_sum;

        _intermediate = stock + deficit + _supply - _internode_demand_sum -
            _leaf_demand_sum - _leaf_last_demand_sum -
            _internode_last_demand_sum + _realloc_biomass_sum;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM_INTERMEDIATE", t, artis::utils::COMPUTE)
            << "Intermediaire = " << _intermediate
            << " ; Stock[-1] = " << _plant_stock_1
            << " ; Deficit[-1] = " << _plant_deficit_1
            << " ; Stock[0] = " << _plant_stock
            << " ; Deficit[0] = " << _plant_deficit
            << " ; Stock = " << stock
            << " ; Deficit = " << deficit
            << " ; Supply = " << _supply
            << " ; InternodeDemandSum = " << _internode_demand_sum
            << " ; LeafBiomassSum = " << _leaf_biomass_sum
            << " ; InternodeBiomassSum = " << _internode_biomass_sum
            << " ; LeafDemandSum = " << _leaf_demand_sum
            << " ; LeafLastDemandSum = " << _leaf_last_demand_sum
            << " ; InternodeLastDemandSum = " << _internode_last_demand_sum
            << " ; ReallocBiomassSum = " << _realloc_biomass_sum;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _realocationCoeff = parameters.get < double >("realocationCoeff");

        _intermediate = 0;
        _plant_stock_1 = _plant_stock = 0;
        _plant_deficit_1 = _plant_deficit = 0;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == PLANT_STOCK and not is_ready(t, PLANT_STOCK)) {
            _plant_stock_1 = _plant_stock;
        }
        if (index == PLANT_DEFICIT and not is_ready(t, PLANT_DEFICIT)) {
            _plant_deficit_1 = _plant_deficit;
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM_INTERMEDIATE", t, artis::utils::PUT)
            << "Intermediaire = " << _intermediate
            << " ; Stock[-1] = " << _plant_stock_1
            << " ; Deficit[-1] = " << _plant_deficit_1
            << " ; Stock[0] = " << _plant_stock
            << " ; Deficit[0] = " << _plant_deficit;
        utils::Trace::trace().flush();
#endif

        ecomeristem::AbstractAtomicModel < Intermediate >::put(t, index, value);
    }

    void realloc_biomass(double t, double value)
    {
        if (value > 0) {
            double qty = value * _realocationCoeff;

            _plant_stock_1 = std::max(0., qty + _plant_deficit);
            _plant_stock = _plant_stock_1;
            _plant_deficit_1 = std::min(0., qty + _plant_deficit);
            _plant_deficit = _plant_deficit_1;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM_INTERMEDIATE", t, artis::utils::COMPUTE)
            << "Intermediaire = " << _intermediate
            << " ; Stock[-1] = " << _plant_stock_1
            << " ; Deficit[-1] = " << _plant_deficit_1
            << " ; Stock[0] = " << _plant_stock
            << " ; Deficit[0] = " << _plant_deficit
            << " ==> REALLOC";
        utils::Trace::trace().flush();
#endif
        }
    }

private:
// parameters
    double _realocationCoeff;

// internal variables
    double _intermediate;

// external variables
    double _leaf_biomass_sum;
    double _internode_biomass_sum;
    double _plant_biomass_sum;
    double _supply;
    double _plant_stock;
    double _plant_stock_1;
    double _plant_deficit;
    double _plant_deficit_1;
    double _internode_demand_sum;
    double _leaf_demand_sum;
    double _internode_last_demand_sum;
    double _leaf_last_demand_sum;
    double _realloc_biomass_sum;
};

} } // namespace ecomeristem culm

#endif

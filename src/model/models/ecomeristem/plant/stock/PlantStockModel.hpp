/**
 * @file ecomeristem/plant/stock/Model.hpp
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

#include <model/kernel/AbstractCoupledModel.hpp>
#include <model/models/ecomeristem/plant/stock/DayDemand.hpp>
#include <model/models/ecomeristem/plant/stock/IndexCompetition.hpp>
#include <model/models/ecomeristem/plant/stock/ReservoirDispo.hpp>
#include <model/models/ecomeristem/plant/stock/SeedRes.hpp>
#include <model/models/ecomeristem/plant/stock/PlantStock.hpp>
#include <model/models/ecomeristem/plant/stock/PlantSupply.hpp>
#include <model/models/ecomeristem/plant/stock/StockSurplus.hpp>

namespace ecomeristem { namespace plant { namespace stock {

class PlantStockModel : public ecomeristem::AbstractCoupledModel < PlantStockModel >
{
public:
    enum submodels { DAY_DEMAND_MODEL, IC_MODEL, RESERVOIR_DISPO_MODEL,
                     SEED_RES_MODEL, STOCK_MODEL, SUPPLY_MODEL, SURPLUS_MODEL };
    enum internals { STOCK, GROW, SUPPLY, DEFICIT, IC, SURPLUS, TEST_IC,
                     DAY_DEMAND, RESERVOIR_DISPO, SEED_RES };
    enum externals { ASSIM, DEMAND_SUM, LEAF_BIOMASS_SUM,
                     LEAF_LAST_DEMAND_SUM, INTERNODE_LAST_DEMAND_SUM,
                     DELETED_LEAF_BIOMASS, PHASE,
                     REALLOC_BIOMASS_SUM, STATE, CULM_STOCK, CULM_DEFICIT,
                     CULM_SURPLUS_SUM };

    PlantStockModel();

    virtual ~PlantStockModel()
    { }

    void compute(double t, bool /* update */);
    void init(double t, const model::models::ModelParameters& parameters);

    void realloc_biomass(double t, double value)
    { stock_model.realloc_biomass(t, value); }

private:
    void compute_stock(double t);

    // submodels
    DayDemand day_demand_model;
    IndexCompetition index_competition_model;
    ReservoirDispo reservoir_dispo_model;
    SeedRes seed_res_model;
    PlantStock stock_model;
    PlantSupply supply_model;
    StockSurplus surplus_model;

    // internal variables
    bool _stop;

    // external variables
    double _assim;
    double _demand_sum;
    double _leaf_biomass_sum;
    double _leaf_last_demand_sum;
    double _internode_last_demand_sum;
    double _deleted_leaf_biomass;
    double _phase;
    double _realloc_biomass_sum;
    double _state;
    double _culm_stock;
    double _culm_deficit;
    double _culm_surplus_sum;
};

} } } // namespace ecomeristem plant stock

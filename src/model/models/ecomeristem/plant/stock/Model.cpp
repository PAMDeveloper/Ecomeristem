/**
 * @file ecomeristem/plant/stock/Model.cpp
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

#include <model/models/ecomeristem/plant/stock/Model.hpp>

namespace ecomeristem { namespace plant { namespace stock {

Model::Model()
{
    internal(STOCK, &stock_model, stock::Stock::STOCK);
    internal(GROW, &stock_model, stock::Stock::GROW);
    internal(DEFICIT, &stock_model, stock::Stock::DEFICIT);
    internal(SUPPLY, &supply_model, stock::Supply::SUPPLY);
    internal(IC, &index_competition_model, stock::IndexCompetition::IC);
    internal(TEST_IC, &index_competition_model,
             stock::IndexCompetition::TEST_IC);
    internal(SURPLUS, &surplus_model, stock::Surplus::SURPLUS);
    internal(DAY_DEMAND, &day_demand_model, stock::DayDemand::DAY_DEMAND);
    internal(RESERVOIR_DISPO, &reservoir_dispo_model,
             stock::ReservoirDispo::RESERVOIR_DISPO);
    internal(SEED_RES, &seed_res_model, stock::SeedRes::SEED_RES);

    external(ASSIM, &Model::_assim);
    external(DEMAND_SUM, &Model::_demand_sum);
    external(LEAF_BIOMASS_SUM, &Model::_leaf_biomass_sum);
    external(LEAF_LAST_DEMAND_SUM, &Model::_leaf_last_demand_sum);
    external(DELETED_LEAF_BIOMASS, &Model::_deleted_leaf_biomass);
    external(PHASE, &Model::_phase);
    external(REALLOC_BIOMASS_SUM, &Model::_realloc_biomass_sum);
}

void Model::init(double t, const model::models::ModelParameters& parameters)
{
    day_demand_model.init(t, parameters);
    index_competition_model.init(t, parameters);
    reservoir_dispo_model.init(t, parameters);
    seed_res_model.init(t, parameters);
    stock_model.init(t, parameters);
    supply_model.init(t, parameters);
    surplus_model.init(t, parameters);
}

void Model::compute(double t, bool update)
{
    if (not update) {
        _stop = false;
    }

    if (is_ready(t, DEMAND_SUM) and is_ready(t, LEAF_LAST_DEMAND_SUM) and
        is_ready(t, PHASE)) {
        day_demand_model.put(t, DayDemand::DEMAND_SUM, _demand_sum);
        day_demand_model.put(t, DayDemand::LEAF_LAST_DEMAND_SUM,
                             _leaf_last_demand_sum);
        day_demand_model.put(t, DayDemand::PHASE, _phase);
        day_demand_model(t);

        seed_res_model.put(t, SeedRes::DAY_DEMAND,
                           day_demand_model.get(t, DayDemand::DAY_DEMAND));
        seed_res_model(t);

        if (is_ready(t, ASSIM)) {
            supply_model.put(t, Supply::ASSIM, _assim);
            supply_model(t);

            if (not update or (update and not _stop)) {
                index_competition_model.put(t, IndexCompetition::DAY_DEMAND,
                                            day_demand_model.get(
                                                t, DayDemand::DAY_DEMAND));
                index_competition_model.put(
                    t, IndexCompetition::SEED_RES,
                    seed_res_model.get(t, SeedRes::SEED_RES));
                index_competition_model.put(
                    t, IndexCompetition::SUPPLY,
                    supply_model.get(t, Supply::SUPPLY));
                index_competition_model(t);
                _stop = _phase == plant::NOGROWTH4;
            }

            reservoir_dispo_model.put(t, ReservoirDispo::LEAF_BIOMASS_SUM,
                                      _leaf_biomass_sum);
            reservoir_dispo_model(t);

            surplus_model.put(t, Surplus::DAY_DEMAND,
                              day_demand_model.get(t, DayDemand::DAY_DEMAND));
            surplus_model.put(t, Surplus::RESERVOIR_DISPO,
                              reservoir_dispo_model.get(
                                  t, ReservoirDispo::RESERVOIR_DISPO));
            surplus_model.put(t, Surplus::SEED_RES,
                              seed_res_model.get(t, SeedRes::SEED_RES));
            surplus_model.put(t, Surplus::SUPPLY,
                              supply_model.get(t, Supply::SUPPLY));
            surplus_model.put(t, Surplus::REALLOC_BIOMASS_SUM,
                              _realloc_biomass_sum);
            surplus_model(t);

            compute_stock(t);
        }
    }
}

void Model::compute_stock(double t)
{
    stock_model.put(t, Stock::DAY_DEMAND,
                    day_demand_model.get(t, DayDemand::DAY_DEMAND));
    stock_model.put(t, Stock::SEED_RES,
                    seed_res_model.get(t, SeedRes::SEED_RES));
    stock_model.put(t, Stock::SUPPLY,
                    supply_model.get(t, Supply::SUPPLY));
    stock_model.put(t, Stock::RESERVOIR_DISPO,
                    reservoir_dispo_model.get(
                        t, ReservoirDispo::RESERVOIR_DISPO));
    stock_model.put(t, Stock::REALLOC_BIOMASS_SUM, _realloc_biomass_sum);
    stock_model.put(t, Stock::DELETED_LEAF_BIOMASS, _deleted_leaf_biomass);
    stock_model(t);
    if (stock_model.is_computed(t, Stock::GROW)) {
        day_demand_model.put(t, DayDemand::GROW,
                             stock_model.get(t, Stock::GROW));
        reservoir_dispo_model.put(t, ReservoirDispo::GROW,
                                  stock_model.get(t, Stock::GROW));
    }
    if (stock_model.is_computed(t, Stock::STOCK)) {
        reservoir_dispo_model.put(t, ReservoirDispo::STOCK,
                                  stock_model.get(t, Stock::STOCK));
    }
}

} } } // namespace ecomeristem plant stock

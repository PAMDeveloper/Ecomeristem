/**
 * @file ecomeristem/culm/Model.hpp
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

#include <model/kernel/AbstractModel.hpp>
#include <model/kernel/AbstractCoupledModel.hpp>
#include <model/models/ecomeristem/phytomer/PhytomerModel.hpp>
#include <model/models/ecomeristem/culm/Deficit.hpp>
#include <model/models/ecomeristem/culm/Intermediate.hpp>
#include <model/models/ecomeristem/culm/MaxReservoirDispo.hpp>
#include <model/models/ecomeristem/culm/CulmStock.hpp>
#include <model/models/ecomeristem/culm/CulmSurplus.hpp>
#include <model/models/ecomeristem/culm/CulmSupply.hpp>
#include <utils/Trace.hpp>

#include <deque>

namespace ecomeristem { namespace culm {

class CulmModel : public ecomeristem::AbstractCoupledModel < CulmModel >
{
public:
    enum submodels { PHYTOMERS };
    enum internals { LEAF_BIOMASS_SUM, LEAF_LAST_DEMAND_SUM, LEAF_DEMAND_SUM,
                     INTERNODE_DEMAND_SUM, INTERNODE_LAST_DEMAND_SUM,
                     INTERNODE_BIOMASS_SUM, INTERNODE_LEN_SUM,
                     LEAF_BLADE_AREA_SUM, LEAF_PREDIM,
                     REALLOC_BIOMASS_SUM, SENESC_DW_SUM, LIG, CULM_STOCK,
                     CULM_DEFICIT, CULM_SURPLUS_SUM };
    enum externals { DD, DELTA_T, FTSW, FCSTR, P, PHENO_STAGE,
                     PREDIM_LEAF_ON_MAINSTEM, SLA, GROW, PHASE, STATE,
                     STOP, TEST_IC, PLANT_STOCK, PLANT_DEFICIT,
                     PLANT_LEAF_BIOMASS_SUM, PLANT_BIOMASS_SUM,
                     PLANT_BLADE_AREA_SUM, ASSIM };

    CulmModel(int index);

    virtual ~CulmModel()
    {
        std::deque < phytomer::PhytomerModel* >::iterator it = phytomer_models.begin();

        while (it != phytomer_models.end()) {
            delete *it;
            ++it;
        }
    }

    void init(double t, const model::models::ModelParameters& parameters);
    bool is_stable(double t) const;
    void compute(double t, bool update);
    void create_phytomer(double t);
    void delete_leaf(double t, int index);
    double get_leaf_biomass(double t, int index) const;
    double get_leaf_blade_area(double t, int index) const;
    double get_leaf_len(double t, int index) const;

    int get_phytomer_number() const
    { return phytomer_models.size(); }

    int get_first_ligulated_leaf_index(double t) const;
    int get_last_ligulated_leaf_index(double t) const;
    int get_first_alive_leaf_index(double t) const;

    bool is_dead() const
    { return _deleted_leaf_number > 0 and _lig == _deleted_leaf_number; }

    void realloc_biomass(double t, double value)
    { intermediate_model.realloc_biomass(t, value); }

private:
// parameters
    int _index;
    double _first_day;
    bool _is_first_culm;

    const model::models::ModelParameters* _parameters;

//submodels
    std::deque < phytomer::PhytomerModel* > phytomer_models;
    Deficit deficit_model;
    Intermediate intermediate_model;
    CulmStock stock_model;
    CulmSurplus surplus_model;
    CulmSupply supply_model;
    MaxReservoirDispo max_reservoir_dispo_model;

// internal
    double _leaf_biomass_sum;
    double _leaf_last_demand_sum;
    double _leaf_demand_sum;
    double _internode_last_demand_sum;
    double _internode_demand_sum;
    double _internode_biomass_sum;
    double _internode_len_sum;
    double _leaf_blade_area_sum;
    double _leaf_predim;
    double _realloc_biomass_sum;
    double _senesc_dw_sum;
    double _lig;
    double _deleted_leaf_number;
    double _deleted_senesc_dw;
    bool _deleted_senesc_dw_computed;

// external variables
    double _dd;
    double _delta_t;
    double _ftsw;
    double _fcstr;
    double _p;
    double _pheno_stage;
    double _predim_leaf_on_mainstem;
    double _sla;
    double _grow;
    double _phase;
    double _state;
    double _stop;
    double _test_ic;
    double _plant_stock;
    double _plant_deficit;
    double _plant_biomass_sum;
    double _plant_leaf_biomass_sum;
    double _plant_blade_area_sum;
    double _assim;
};

} } // namespace ecomeristem culm

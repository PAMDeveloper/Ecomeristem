/**
 * @file ecomeristem/plant/Model.hpp
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

#include <model/models/ecomeristem/culm/Model.hpp>

#include <model/models/ecomeristem/plant/Lig.hpp>
#include <model/models/ecomeristem/plant/Manager.hpp>
#include <model/models/ecomeristem/plant/TillerManager.hpp>
#include <model/models/ecomeristem/plant/assimilation/Model.hpp>
#include <model/models/ecomeristem/root/Model.hpp>
#include <model/models/ecomeristem/plant/SLA.hpp>
#include <model/models/ecomeristem/plant/stock/Model.hpp>
#include <model/models/ecomeristem/plant/thermal-time/Model.hpp>
#include <model/models/ecomeristem/plant/water-balance/Model.hpp>
#include <model/kernel/AbstractCoupledModel.hpp>

namespace ecomeristem { namespace plant {

class Model : public AbstractCoupledModel < Model >
{
public:
    enum submodels { ASSIMILATION, ROOT, STOCK, THERMAL_TIME, WATER_BALANCE,
                     MANAGER, TILLER_MANAGER, SLA, CULMS };
    enum internals { LAI, DELTA_T, DD, EDD, IH, LIGULO_VISU, PHENO_STAGE,
                     PLASTO_VISU, TT, TT_LIG, BOOL_CROSSED_PLASTO,
                     ASSIM, CSTR, ROOT_DEMAND_COEF, ROOT_DEMAND,
                     ROOT_BIOMASS, /*STOCK,*/ GROW, SUPPLY, DEFICIT, IC,
                     SURPLUS, TEST_IC, DAY_DEMAND, RESERVOIR_DISPO,
                     SEED_RES, LEAF_BIOMASS_SUM, INTERNODE_BIOMASS_SUM,
                     SENESC_DW_SUM, LEAF_LAST_DEMAND_SUM,
                     INTERNODE_LAST_DEMAND_SUM, LEAF_DEMAND_SUM,
                     INTERNODE_DEMAND_SUM };
    enum externals { ETP, P, RADIATION, TA, WATER_SUPPLY };

    Model();

    virtual ~Model()
    {
        std::vector < culm::Model* >::const_iterator it = culm_models.begin();

        while (it != culm_models.end()) {
            delete *it;
            ++it;
        }
    }

    void compute(double t, bool /* update */);
    void init(double t, const model::models::ModelParameters& parameters);

private:
    void compute_assimilation(double t);
    void compute_culms(double t);
    void compute_lig(double t);
    void compute_manager(double t);
    void compute_root(double t);
    void compute_sla(double t);
    void compute_stock(double t);
    void compute_thermal_time(double t);
    void compute_tiller(double t);
    void compute_water_balance(double t);
    void create_culm(double t, int n);
    void create_phytomer(double t);
    bool culms_is_stable(double t);

// parameters
    double _nbleaf_enabling_tillering;
    double _realocationCoeff;

    const model::models::ModelParameters* _parameters;

// internal variables
    double _leaf_biomass_sum;
    double _leaf_last_demand_sum;
    double _leaf_demand_sum;
    double _internode_demand_sum;
    double _internode_last_demand_sum;
    double _internode_biomass_sum;
    double _leaf_blade_area_sum;
    double _demand_sum;
    bool _culm_is_computed;
    double _realloc_biomass_sum;
    double _senesc_dw_sum;
    double _lig;
    double _deleted_leaf_biomass;
    double _deleted_leaf_blade_area;

// external variables
    double _etp;
    double _p;
    double _radiation;
    double _ta;
    double _water_supply;
    int _culm_index;
    int _leaf_index;

// submodels
    ecomeristem::plant::assimilation::Model assimilation_model;
    ecomeristem::root::Model root_model;
    ecomeristem::plant::stock::Model stock_model;
    ecomeristem::plant::thermal_time::Model thermal_time_model;
    ecomeristem::plant::water_balance::Model water_balance_model;
    ecomeristem::plant::Manager manager_model;
    ecomeristem::plant::TillerManager tiller_manager_model;
//    ecomeristem::plant::Lig lig_model;
    ecomeristem::plant::Sla sla_model;

    std::vector < culm::Model* > culm_models;
    double _begin;
};

} } // namespace ecomeristem plant

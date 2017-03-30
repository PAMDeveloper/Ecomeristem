/**
 * @file ecomeristem/root/Model.hpp
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
#include <model/models/ecomeristem/root/RootDemandCoef.hpp>
#include <model/models/ecomeristem/root/RootDemand.hpp>
#include <model/models/ecomeristem/root/RootManager.hpp>

namespace ecomeristem { namespace root {

class RootModel : public ecomeristem::AbstractCoupledModel < RootModel >
{
public:
    enum submodels { ROOT_DEMAND_COEF_MODEL, ROOT_DEMAND_MODEL};
    enum internals { ROOT_DEMAND_COEF, ROOT_DEMAND, ROOT_DEMAND_1, ROOT_BIOMASS,
                     SURPLUS };
    enum externals { LEAF_DEMAND_SUM, LEAF_LAST_DEMAND_SUM,
                     INTERNODE_DEMAND_SUM, INTERNODE_LAST_DEMAND_SUM, P,
                     STOCK, GROW, PHASE, STATE, CULM_SURPLUS_SUM };

    RootModel()
    {
        // submodels
        submodel(ROOT_DEMAND_COEF_MODEL, &root_demand_coef_model);
        submodel(ROOT_DEMAND_MODEL, &root_demand_model);

        // internals
        internal(ROOT_DEMAND_COEF, &root_demand_coef_model,
                 RootDemandCoef::ROOT_DEMAND_COEF);
        internal(ROOT_DEMAND, &root_demand_model, RootDemand::ROOT_DEMAND);
        internal(ROOT_DEMAND_1, &root_demand_model, RootDemand::ROOT_DEMAND_1);
        internal(ROOT_BIOMASS, &root_demand_model, RootDemand::ROOT_BIOMASS);
        internal(SURPLUS, &root_demand_model, RootDemand::SURPLUS);

        // externals
        external(LEAF_DEMAND_SUM, &RootModel::_leaf_demand_sum);
        external(LEAF_LAST_DEMAND_SUM, &RootModel::_leaf_last_demand_sum);
        external(INTERNODE_DEMAND_SUM, &RootModel::_internode_demand_sum);
        external(INTERNODE_LAST_DEMAND_SUM, &RootModel::_internode_last_demand_sum);
        external(P, &RootModel::_p);
        external(STOCK, &RootModel::_stock);
        external(GROW, &RootModel::_grow);
        external(PHASE, &RootModel::_phase);
        external(STATE, &RootModel::_state);
        external(CULM_SURPLUS_SUM, &RootModel::_culm_surplus_sum);
    }

    virtual ~RootModel()
    { }

    void init(double t, const model::models::ModelParameters& parameters)
    {
        root_demand_coef_model.init(t, parameters);
        root_demand_model.init(t, parameters);
        root_manager_model.init(t, parameters);
    }

    void compute(double t, bool /* update */)
    {
        root_demand_coef_model.put(t, RootDemandCoef::P, _p);
        root_demand_coef_model(t);

        root_demand_model.put(t, RootDemand::CULM_SURPLUS_SUM,
                              _culm_surplus_sum);
        root_demand_model.put(t, RootDemand::LEAF_DEMAND_SUM,
                              _leaf_demand_sum);
        root_demand_model.put(t, RootDemand::LEAF_LAST_DEMAND_SUM,
                              _leaf_last_demand_sum);
        root_demand_model.put(t, RootDemand::INTERNODE_DEMAND_SUM,
                              _internode_demand_sum);
        root_demand_model.put(t, RootDemand::INTERNODE_LAST_DEMAND_SUM,
                              _internode_last_demand_sum);
        root_demand_model.put(t, RootDemand::ROOT_DEMAND_COEF,
                              root_demand_coef_model.get < double >(t,
                                  RootDemandCoef::ROOT_DEMAND_COEF));
        root_demand_model.put(t, RootDemand::GROW, _grow);
        root_demand_model.put(t, RootDemand::PHASE, _phase);
        root_demand_model.put(t, RootDemand::STATE, _state);
        root_demand_model(t);
    }

private:
    //external variables
    double _leaf_demand_sum;
    double _leaf_last_demand_sum;
    double _internode_demand_sum;
    double _internode_last_demand_sum;
    double _p;
    double _stock;
    double _grow;
    double _phase;
    double _state;
    double _culm_surplus_sum;

    // submodels
    RootDemandCoef root_demand_coef_model;
    RootDemand root_demand_model;
    RootManager root_manager_model;
};

} } // namespace ecomeristem root

/**
 * @file ecomeristem/root/Model.hpp
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

#include <model/kernel/AbstractCoupledModel.hpp>
#include <model/models/ecomeristem/root/RootDemandCoef.hpp>
#include <model/models/ecomeristem/root/RootDemand.hpp>
#include <model/models/ecomeristem/root/RootManager.hpp>

namespace ecomeristem { namespace root {

class Model : public AbstractCoupledModel < Model >
{
public:
    static const unsigned int ROOT_DEMAND_COEF = 0;
    static const unsigned int ROOT_DEMAND = 1;
    static const unsigned int ROOT_BIOMASS = 2;

    static const unsigned int LEAF_DEMAND_SUM = 0;
    static const unsigned int P = 1;
    static const unsigned int STOCK = 2;
    static const unsigned int GROW = 3;
    static const unsigned int PHASE = 4;

    Model()
    {
        internal(ROOT_DEMAND_COEF, &root_demand_coef_model,
                 RootDemandCoef::ROOT_DEMAND_COEF);
        internal(ROOT_DEMAND, &root_demand_model,
                 RootDemand::ROOT_DEMAND);
        internal(ROOT_BIOMASS, &root_demand_model,
                 RootDemand::ROOT_BIOMASS);

        external(LEAF_DEMAND_SUM, &Model::_leaf_demand_sum);
        external(P, &Model::_p);
        external(STOCK, &Model::_stock);
        external(GROW, &Model::_grow);
        external(PHASE, &Model::_phase);
    }

    virtual ~Model()
    { }

    void init(double t, const model::models::ModelParameters& parameters)
    {
        root_demand_coef_model.init(t, parameters);
        root_demand_model.init(t, parameters);
        root_manager_model.init(t, parameters);
    }

    void compute(double t)
    {
        root_demand_coef_model.put(t, RootDemandCoef::P, _p);
        root_demand_coef_model.compute(t);

        root_demand_model.put(t, RootDemand::LEAF_DEMAND_SUM,
                              _leaf_demand_sum);
        root_demand_model.put(t, RootDemand::ROOT_DEMAND_COEF,
                              root_demand_coef_model.get(
                                  RootDemandCoef::ROOT_DEMAND_COEF));
        root_demand_model.put(t, RootDemand::GROW, _grow);
        root_demand_model.put(t, RootDemand::PHASE, _phase);
        root_demand_model.compute(t);
    }

private:
    //external variables
    double _leaf_demand_sum;
    double _p;
    double _stock;
    double _grow;
    double _phase;

    // submodels
    RootDemandCoef root_demand_coef_model;
    RootDemand root_demand_model;
    RootManager root_manager_model;
};

} } // namespace ecomeristem root

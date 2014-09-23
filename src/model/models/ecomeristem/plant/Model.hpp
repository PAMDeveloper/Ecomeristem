/**
 * @file ecomeristem/plant/Model.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2014 INRA http://www.cirad.fr
 * Copyright (C) 2014 ULCO http://www.univ-littoral.fr
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

#include <model/models/ecomeristem/plant/Manager.hpp>
#include <model/models/ecomeristem/plant/TillerManager.hpp>
#include <model/models/ecomeristem/plant/assimilation/Model.hpp>
#include <model/models/ecomeristem/root/Model.hpp>
#include <model/models/ecomeristem/plant/stock/Model.hpp>
#include <model/models/ecomeristem/plant/thermal-time/Model.hpp>
#include <model/models/ecomeristem/plant/water-balance/Model.hpp>
#include <model/models/ModelParameters.hpp>

#include <iostream>

namespace ecomeristem { namespace plant {

class Model
{
public:
    Model()
    { }

    virtual ~Model()
    { }

    void build()
    {
        assimilation_model = new ecomeristem::plant::assimilation::Model;
        root_model = new ecomeristem::root::Model;
        stock_model = new ecomeristem::plant::stock::Model;
        thermal_time_model = new ecomeristem::plant::thermal_time::Model;
        water_balance_model = new ecomeristem::plant::water_balance::Model;
        manager_model = new ecomeristem::plant::Manager;
        tiller_manager_model = new ecomeristem::plant::TillerManager;

        assimilation_model->build();
    }

    void init(double t, const model::models::ModelParameters& parameters)
    {
        assimilation_model->init(t, parameters);
        root_model->init(t, parameters);
        stock_model->init(t, parameters);
        thermal_time_model->init(t, parameters);
        water_balance_model->init(t, parameters);
        manager_model->init(t, parameters);
        tiller_manager_model->init(t, parameters);
    }

    void compute(double t)
    {
        assimilation_model->put(t, assimilation::Model::FCSTR, 0);
        assimilation_model->put(t, assimilation::Model::INTERNODE_BIOMASS, 0);
        assimilation_model->put(t, assimilation::Model::LEAF_BIOMASS, 0);
        assimilation_model->put(t, assimilation::Model::PAI, 0);
        assimilation_model->put(t, assimilation::Model::RADIATION, 0);
        assimilation_model->put(t, assimilation::Model::TA, 0);
        assimilation_model->put(t, assimilation::Model::CSTR, 0);
        assimilation_model->compute(t);

        std::cout << "assim = "
                  << assimilation_model->get(assimilation::Model::ASSIM);
        std::cout << "interc = "
                  << assimilation_model->get(assimilation::Model::INTERC);

/*        root_model->compute(t);

        manager_model->compute(t);

        tiller_manager_model->compute(t); */
    }

private:
    ecomeristem::plant::assimilation::Model* assimilation_model;
    ecomeristem::root::Model* root_model;
    ecomeristem::plant::stock::Model* stock_model;
    ecomeristem::plant::thermal_time::Model* thermal_time_model;
    ecomeristem::plant::water_balance::Model* water_balance_model;

    ecomeristem::plant::Manager* manager_model;
    ecomeristem::plant::TillerManager* tiller_manager_model;
};

} } // namespace ecomeristem plant

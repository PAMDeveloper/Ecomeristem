/**
 * @file ecomeristem/Model.cpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2016 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2016 ULCO http://www.univ-littoral.fr
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

#include <model/models/ecomeristem/Model.hpp>

namespace ecomeristem {

Model::Model() : plant_model(new plant::Model)
{
    submodel(PLANT, plant_model);

    internal(LAI, plant_model, plant::Model::LAI);
    internal(DELTA_T, plant_model, plant::Model::DELTA_T);
    internal(BOOL_CROSSED_PLASTO, plant_model, plant::Model::BOOL_CROSSED_PLASTO);
    internal(DD, plant_model, plant::Model::DD);
    internal(EDD, plant_model, plant::Model::EDD);
    internal(IH, plant_model, plant::Model::IH);
    internal(LIGULO_VISU, plant_model, plant::Model::LIGULO_VISU);
    internal(PHENO_STAGE, plant_model, plant::Model::PHENO_STAGE);
    internal(PLASTO_VISU, plant_model, plant::Model::PLASTO_VISU);
    internal(TT, plant_model, plant::Model::TT);
    internal(TT_LIG, plant_model, plant::Model::TT_LIG);
    internal(ASSIM, plant_model, plant::Model::ASSIM);
    internal(CSTR, plant_model, plant::Model::CSTR);
    internal(ROOT_DEMAND_COEF, plant_model, plant::Model::ROOT_DEMAND_COEF);
    internal(ROOT_DEMAND, plant_model, plant::Model::ROOT_DEMAND);
    internal(ROOT_BIOMASS, plant_model, plant::Model::ROOT_BIOMASS);
    internal(STOCK, plant_model, plant::Model::STOCK);
    internal(GROW, plant_model, plant::Model::GROW);
    internal(SUPPLY, plant_model, plant::Model::SUPPLY);
    internal(DEFICIT, plant_model, plant::Model::DEFICIT);
    internal(IC, plant_model, plant::Model::IC);
    internal(SURPLUS, plant_model, plant::Model::SURPLUS);
    internal(TEST_IC, plant_model, plant::Model::TEST_IC);
    internal(DAY_DEMAND, plant_model, plant::Model::DAY_DEMAND);
    internal(RESERVOIR_DISPO, plant_model, plant::Model::RESERVOIR_DISPO);
    internal(SEED_RES, plant_model, plant::Model::SEED_RES);

    external(ETP, &Model::_etp);
    external(P, &Model::_p);
    external(RADIATION, &Model::_radiation);
    external(TA, &Model::_ta);
    external(WATER_SUPPLY, &Model::_water_supply);
}

Model::~Model()
{
    if (plant_model) {
        delete plant_model;
    }
}

void Model::init(double t, const model::models::ModelParameters& parameters)
{
    plant_model->init(t, parameters);
}

void Model::compute(double t, bool /* update */)
{
    if (plant_model) {
        plant_model->put(t, plant::Model::ETP, _etp);
        plant_model->put(t, plant::Model::P, _p);
        plant_model->put(t, plant::Model::RADIATION, _radiation);
        plant_model->put(t, plant::Model::TA, _ta);
        plant_model->put(t, plant::Model::WATER_SUPPLY, _water_supply);
        (*plant_model)(t);

        if (plant_model->is_dead()) {
            delete plant_model;
            plant_model = 0;
            submodel(PLANT, 0);
        }
    }
}

} // namespace ecomeristem

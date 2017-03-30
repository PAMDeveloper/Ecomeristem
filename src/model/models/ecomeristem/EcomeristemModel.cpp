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

#include <model/models/ecomeristem/EcomeristemModel.hpp>

namespace ecomeristem {

EcomeristemModel::EcomeristemModel(const ecomeristem::AbstractModel* parent) :
    AbstractCoupledModel < EcomeristemModel >(parent),
    plant_model(new plant::PlantModel(this))
{
    submodel(PLANT, plant_model);

	// submodels
	S({ { PLANT, plant_model } });
	I({ { LAI, plant_model, plant::PlantModel::LAI },
		{ DELTA_T, plant_model, plant::PlantModel::DELTA_T },
		{ BOOL_CROSSED_PLASTO, plant_model, plant::PlantModel::BOOL_CROSSED_PLASTO },
		{ DD, plant_model, plant::PlantModel::DD },
		{ EDD, plant_model, plant::PlantModel::EDD },
		{ IH, plant_model, plant::PlantModel::IH },
		{ LIGULO_VISU, plant_model, plant::PlantModel::LIGULO_VISU },
		{ PHENO_STAGE, plant_model, plant::PlantModel::PHENO_STAGE },
		{ PLASTO_VISU, plant_model, plant::PlantModel::PLASTO_VISU },
		{ TT, plant_model, plant::PlantModel::TT },
		{ TT_LIG, plant_model, plant::PlantModel::TT_LIG },
		{ ASSIM, plant_model, plant::PlantModel::ASSIM },
		{ CSTR, plant_model, plant::PlantModel::CSTR },
		{ ROOT_DEMAND_COEF, plant_model, plant::PlantModel::ROOT_DEMAND_COEF },
		{ ROOT_DEMAND, plant_model, plant::PlantModel::ROOT_DEMAND },
		{ ROOT_BIOMASS, plant_model, plant::PlantModel::ROOT_BIOMASS },
		{ STOCK, plant_model, plant::PlantModel::STOCK },
		{ GROW, plant_model, plant::PlantModel::GROW },
		{ SUPPLY, plant_model, plant::PlantModel::SUPPLY },
		{ DEFICIT, plant_model, plant::PlantModel::DEFICIT },
		{ IC, plant_model, plant::PlantModel::IC },
		{ SURPLUS, plant_model, plant::PlantModel::SURPLUS },
		{ TEST_IC, plant_model, plant::PlantModel::TEST_IC },
		{ DAY_DEMAND, plant_model, plant::PlantModel::DAY_DEMAND },
		{ RESERVOIR_DISPO, plant_model, plant::PlantModel::RESERVOIR_DISPO },
		{ SEED_RES, plant_model, plant::PlantModel::SEED_RES } });
	
	E <double> ({ { ETP, &EcomeristemModel::_etp },
		{ P, &EcomeristemModel::_p },
		{ RADIATION, &EcomeristemModel::_radiation },
		{ TA, &EcomeristemModel::_ta },
		{ WATER_SUPPLY, &EcomeristemModel::_water_supply } });
}

EcomeristemModel::~EcomeristemModel()
{
    if (plant_model) {
        delete plant_model;
    }
}

void EcomeristemModel::init(double t, const model::models::ModelParameters& parameters)
{
    plant_model->init(t, parameters);
}

void EcomeristemModel::compute(double t, bool /* update */)
{
    if (plant_model) {
        plant_model->put(t, plant::PlantModel::ETP, _etp);
        plant_model->put(t, plant::PlantModel::P, _p);
        plant_model->put(t, plant::PlantModel::RADIATION, _radiation);
        plant_model->put(t, plant::PlantModel::TA, _ta);
        plant_model->put(t, plant::PlantModel::WATER_SUPPLY, _water_supply);
        (*plant_model)(t);

        if (plant_model->is_dead()) {
            delete plant_model;
            plant_model = 0;
            submodel(PLANT, 0);
        }
    }
}

} // namespace ecomeristem

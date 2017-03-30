/**

* @file model/kernel/Model.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS file
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

#ifndef MODEL_KERNEL_MODEL_HPP
#define MODEL_KERNEL_MODEL_HPP

#include <model/kernel/AbstractCoupledModel.hpp>
#include <model/models/ecomeristem/EcomeristemModel.hpp>
#include <model/models/meteo/MeteoModel.hpp>

namespace model { namespace kernel {

class KernelModel : public ecomeristem::AbstractCoupledModel < KernelModel >
{
public:
    enum submodels { ECOMERISTEM, CLIMATE };
    enum internals { LAI, DELTA_T, DD, EDD, IH, LIGULO_VISU, PHENO_STAGE,
                     PLASTO_VISU, TT, TT_LIG, BOOL_CROSSED_PLASTO,
                     ASSIM, CSTR, ROOT_DEMAND_COEF, ROOT_DEMAND,
                     ROOT_BIOMASS, STOCK, GROW, SUPPLY, DEFICIT,
                     IC, SURPLUS, TEST_IC, DAY_DEMAND, RESERVOIR_DISPO,
                     SEED_RES };

    KernelModel() : ecomeristem_model(this)
    {
        submodel(ECOMERISTEM, &ecomeristem_model);
        submodel(CLIMATE, &meteo_model);

//        internal(LAI, &ecomeristem_model, ecomeristem::EcomeristemModel::LAI);
        internal(DELTA_T, &ecomeristem_model, ecomeristem::EcomeristemModel::DELTA_T);
        internal(DD, &ecomeristem_model, ecomeristem::EcomeristemModel::DD);
        internal(EDD, &ecomeristem_model, ecomeristem::EcomeristemModel::EDD);
        internal(IH, &ecomeristem_model, ecomeristem::EcomeristemModel::IH);
        internal(LIGULO_VISU, &ecomeristem_model,
                 ecomeristem::EcomeristemModel::LIGULO_VISU);
        internal(PHENO_STAGE, &ecomeristem_model,
                 ecomeristem::EcomeristemModel::PHENO_STAGE);
        internal(PLASTO_VISU, &ecomeristem_model,
                 ecomeristem::EcomeristemModel::PLASTO_VISU);
        internal(TT, &ecomeristem_model, ecomeristem::EcomeristemModel::TT);
        internal(TT_LIG, &ecomeristem_model, ecomeristem::EcomeristemModel::TT_LIG);
        internal(BOOL_CROSSED_PLASTO, &ecomeristem_model,
                 ecomeristem::EcomeristemModel::BOOL_CROSSED_PLASTO);
        internal(ASSIM, &ecomeristem_model, ecomeristem::EcomeristemModel::ASSIM);
        internal(CSTR, &ecomeristem_model, ecomeristem::EcomeristemModel::CSTR);
        internal(ROOT_DEMAND_COEF, &ecomeristem_model,
                 ecomeristem::EcomeristemModel::ROOT_DEMAND_COEF);
        internal(ROOT_DEMAND, &ecomeristem_model,
                 ecomeristem::EcomeristemModel::ROOT_DEMAND);
        internal(ROOT_BIOMASS, &ecomeristem_model,
                 ecomeristem::EcomeristemModel::ROOT_BIOMASS);
        internal(STOCK, &ecomeristem_model, ecomeristem::EcomeristemModel::STOCK);
        internal(GROW, &ecomeristem_model, ecomeristem::EcomeristemModel::GROW);
        internal(SUPPLY, &ecomeristem_model, ecomeristem::EcomeristemModel::SUPPLY);
        internal(DEFICIT, &ecomeristem_model, ecomeristem::EcomeristemModel::DEFICIT);
        internal(IC, &ecomeristem_model, ecomeristem::EcomeristemModel::IC);
        internal(SURPLUS, &ecomeristem_model, ecomeristem::EcomeristemModel::SURPLUS);
        internal(TEST_IC, &ecomeristem_model, ecomeristem::EcomeristemModel::TEST_IC);
        internal(DAY_DEMAND, &ecomeristem_model,
                 ecomeristem::EcomeristemModel::DAY_DEMAND);
        internal(RESERVOIR_DISPO, &ecomeristem_model,
                 ecomeristem::EcomeristemModel::RESERVOIR_DISPO);
        internal(SEED_RES, &ecomeristem_model, ecomeristem::EcomeristemModel::SEED_RES);
    }

    virtual ~KernelModel()
    { }

    void compute(double t, bool update);

    void init(double t, const model::models::ModelParameters& parameters)
    {
        ecomeristem_model.init(t, parameters);
        meteo_model.init(t, parameters);
    }

private:
// submodels
    ecomeristem::EcomeristemModel ecomeristem_model;
    meteo::MeteoModel meteo_model;
};

} }

#endif

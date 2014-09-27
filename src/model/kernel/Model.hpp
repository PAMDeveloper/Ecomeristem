/**
 * @file model/kernel/Model.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS file
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

#ifndef MODEL_KERNEL_MODEL_HPP
#define MODEL_KERNEL_MODEL_HPP

#include <model/kernel/AbstractCoupledModel.hpp>
#include <model/models/ecomeristem/Model.hpp>
#include <model/models/meteo/Meteo.hpp>

namespace model { namespace kernel {

class Model : public ecomeristem::AbstractCoupledModel < Model >
{
public:
    static const int LAI = 0;
    static const int DELTA_T = 1;
    static const int DD = 2;
    static const int EDD = 3;
    static const int IH = 4;
    static const int LIGULO_VISU = 5;
    static const int PHENO_STAGE = 6;
    static const int PLASTO_VISU = 7;
    static const int TT = 8;
    static const int TT_LIG = 9;
    static const int BOOL_CROSSED_PLASTO = 10;
    static const int ASSIM = 11;
    static const int CSTR = 12;
    static const int ROOT_DEMAND_COEF = 13;
    static const int ROOT_DEMAND = 14;
    static const int ROOT_BIOMASS = 15;
    static const int STOCK = 16;
    static const int GROW = 17;
    static const int SUPPLY = 18;
    static const int DEFICIT = 19;
    static const int IC = 20;
    static const int SURPLUS = 21;
    static const int TEST_IC = 22;
    static const int DAY_DEMAND = 23;
    static const int RESERVOIR_DISPO = 24;
    static const int SEED_RES = 25;

    Model()
    {
        internal(LAI, &ecomeristem_model, ecomeristem::Model::LAI);
        internal(DELTA_T, &ecomeristem_model, ecomeristem::Model::DELTA_T);
        internal(DD, &ecomeristem_model, ecomeristem::Model::DD);
        internal(EDD, &ecomeristem_model, ecomeristem::Model::EDD);
        internal(IH, &ecomeristem_model, ecomeristem::Model::IH);
        internal(LIGULO_VISU, &ecomeristem_model,
                 ecomeristem::Model::LIGULO_VISU);
        internal(PHENO_STAGE, &ecomeristem_model,
                 ecomeristem::Model::PHENO_STAGE);
        internal(PLASTO_VISU, &ecomeristem_model,
                 ecomeristem::Model::PLASTO_VISU);
        internal(TT, &ecomeristem_model, ecomeristem::Model::TT);
        internal(TT_LIG, &ecomeristem_model, ecomeristem::Model::TT_LIG);
        internal(BOOL_CROSSED_PLASTO, &ecomeristem_model,
                 ecomeristem::Model::BOOL_CROSSED_PLASTO);
        internal(ASSIM, &ecomeristem_model, ecomeristem::Model::ASSIM);
        internal(CSTR, &ecomeristem_model, ecomeristem::Model::CSTR);
        internal(ROOT_DEMAND_COEF, &ecomeristem_model,
                 ecomeristem::Model::ROOT_DEMAND_COEF);
        internal(ROOT_DEMAND, &ecomeristem_model,
                 ecomeristem::Model::ROOT_DEMAND);
        internal(ROOT_BIOMASS, &ecomeristem_model,
                 ecomeristem::Model::ROOT_BIOMASS);
        internal(STOCK, &ecomeristem_model, ecomeristem::Model::STOCK);
        internal(GROW, &ecomeristem_model, ecomeristem::Model::GROW);
        internal(SUPPLY, &ecomeristem_model, ecomeristem::Model::SUPPLY);
        internal(DEFICIT, &ecomeristem_model, ecomeristem::Model::DEFICIT);
        internal(IC, &ecomeristem_model, ecomeristem::Model::IC);
        internal(SURPLUS, &ecomeristem_model, ecomeristem::Model::SURPLUS);
        internal(TEST_IC, &ecomeristem_model, ecomeristem::Model::TEST_IC);
        internal(DAY_DEMAND, &ecomeristem_model,
                 ecomeristem::Model::DAY_DEMAND);
        internal(RESERVOIR_DISPO, &ecomeristem_model,
                 ecomeristem::Model::RESERVOIR_DISPO);
        internal(SEED_RES, &ecomeristem_model, ecomeristem::Model::SEED_RES);
    }

    virtual ~Model()
    { }

    void compute(double t, bool update);

    void init(double t, const model::models::ModelParameters& parameters)
    {
        ecomeristem_model.init(t, parameters);
        meteo_model.init(t, parameters);
    }

private:
// submodels
    ecomeristem::Model ecomeristem_model;
    meteo::Model meteo_model;
};

} }

#endif

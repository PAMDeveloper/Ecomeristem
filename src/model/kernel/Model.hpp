/**
 * @file model/kernel/Model.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS file
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
   }

    virtual ~Model()
    { }

    void build();

    void compute(double t);

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

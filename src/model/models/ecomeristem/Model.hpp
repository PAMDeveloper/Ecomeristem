/**
 * @file ecomeristem/Model.hpp
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

#include <model/kernel/AbstractModel.hpp>
#include <model/kernel/AbstractCoupledModel.hpp>
#include <model/models/ecomeristem/plant/Model.hpp>

namespace ecomeristem {

class Model : public AbstractCoupledModel < Model >
{
public:
    enum submodels { PLANT };
    enum internals { LAI, DELTA_T, DD, EDD, IH, LIGULO_VISU, PHENO_STAGE,
                     PLASTO_VISU, TT, TT_LIG, BOOL_CROSSED_PLASTO,
                     ASSIM, CSTR, ROOT_DEMAND_COEF, ROOT_DEMAND,
                     ROOT_BIOMASS, STOCK, GROW, SUPPLY, DEFICIT,
                     IC, SURPLUS, TEST_IC, DAY_DEMAND, RESERVOIR_DISPO,
                     SEED_RES };
    enum externals { ETP, P, RADIATION, TA, WATER_SUPPLY };

    Model(const ecomeristem::AbstractModel* parent);
    virtual ~Model();

    void init(double t, const model::models::ModelParameters& parameters);

    void compute(double t, bool /* update */);

private:
// external variables
    double _etp;
    double _p;
    double _radiation;
    double _ta;
    double _water_supply;

// submodels
    plant::Model* plant_model;
};

} // namespace ecomeristem

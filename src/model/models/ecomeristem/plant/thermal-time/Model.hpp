/**
 * @file ecomeristem/plant/thermal-time/Model.hpp
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

#include <model/kernel/AbstractCoupledModel.hpp>
#include <model/models/ecomeristem/plant/thermal-time/DeltaT.hpp>
#include <model/models/ecomeristem/plant/thermal-time/DD.hpp>
#include <model/models/ecomeristem/plant/thermal-time/IH.hpp>
#include <model/models/ecomeristem/plant/thermal-time/LiguloVisu.hpp>
#include <model/models/ecomeristem/plant/thermal-time/TT.hpp>
#include <model/models/ecomeristem/plant/thermal-time/TT_lig.hpp>
#include <model/models/ecomeristem/plant/thermal-time/ThermalTimeManager.hpp>
#include <model/models/ecomeristem/plant/thermal-time/PhenoStage.hpp>
#include <model/models/ecomeristem/plant/thermal-time/PlastoVisu.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class Model : public ecomeristem::AbstractCoupledModel < Model >
{
public:
    enum submodels { DELTA_T_MODEL, DD_MODEL, IH_MODEL, LIGULO_VISU_MODEL,
                     PHENO_STAGE_MODEL, PLASTO_VISU_MODEL, TT_MODEL,
                     TT_LIG_MODEL, MANAGER_MODEL };
    enum internals { DD, DELTA_T, EDD, IH, LIGULO_VISU, PHENO_STAGE,
                     PLASTO_VISU, TT, TT_LIG, BOOL_CROSSED_PLASTO };
    enum externals { STOCK, PHASE, TA, GROW, LIG, PLASTO_DELAY };

    Model();

    virtual ~Model()
    { }

    void compute(double t, bool /* update */);
    void init(double t, const model::models::ModelParameters& parameters);

private:
// external variables
    double _stock;
    double _phase;
    double _Ta;
    double _grow;
    double _lig;
    double _plasto_delay;

// models
    ecomeristem::plant::thermal_time::DeltaT DeltaT_model;
    ecomeristem::plant::thermal_time::Dd DD_model;
    ecomeristem::plant::thermal_time::Ih IH_model;
    ecomeristem::plant::thermal_time::LiguloVisu LiguloVisu_model;
    ecomeristem::plant::thermal_time::Tt TT_model;
    ecomeristem::plant::thermal_time::TT_lig TT_lig_model;
    ecomeristem::plant::thermal_time::PlastoVisu PlastoVisu_model;
    ecomeristem::plant::thermal_time::ThermalTimeManager
    ThermalTimeManager_model;
    ecomeristem::plant::thermal_time::PhenoStage PhenoStage_model;

};

} } } // namespace ecomeristem plant thermal_time

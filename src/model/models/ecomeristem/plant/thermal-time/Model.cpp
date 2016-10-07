/**
 * @file ecomeristem/plant/thermal-time/Model.cpp
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

#include <model/models/ecomeristem/plant/thermal-time/Model.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

Model::Model()
{
    // submodels
    submodel(DELTA_T_MODEL, &DeltaT_model);
    submodel(DD_MODEL, &DD_model);
    submodel(IH_MODEL, &IH_model);
    submodel(LIGULO_VISU_MODEL, &LiguloVisu_model);
    submodel(PHENO_STAGE_MODEL, &PhenoStage_model);
    submodel(PLASTO_VISU_MODEL, &PlastoVisu_model);
    submodel(TT_MODEL, &TT_model);
    submodel(TT_LIG_MODEL, &TT_lig_model);
    submodel(MANAGER_MODEL, &ThermalTimeManager_model);

     // internals
    internal(DD, &DD_model, Dd::DD);
    internal(DELTA_T, &DeltaT_model, DeltaT::DELTA_T);
    internal(EDD, &DD_model, Dd::EDD);
    internal(IH, &IH_model, Ih::IH);
    internal(LIGULO_VISU, &LiguloVisu_model, LiguloVisu::LIGULO_VISU);
    internal(PHENO_STAGE, &PhenoStage_model, PhenoStage::PHENO_STAGE);
    internal(PLASTO_VISU, &PlastoVisu_model, PlastoVisu::PLASTO_VISU);
    internal(TT, &TT_model, Tt::TT);
    internal(TT_LIG, &TT_lig_model, TT_lig::TT_LIG);
    internal(BOOL_CROSSED_PLASTO, &DD_model, Dd::BOOL_CROSSED_PLASTO);

     // externals
    external(STOCK, &Model::_stock);
    external(PHASE, &Model::_phase);
    external(TA, &Model::_Ta);
    external(GROW, &Model::_grow);
    external(LIG, &Model::_lig);
    external(PLASTO_DELAY, &Model::_plasto_delay);
}

void Model::init(double t, const model::models::ModelParameters& parameters)
{
    DeltaT_model.init(t, parameters);
    DD_model.init(t, parameters);
    IH_model.init(t, parameters);
    LiguloVisu_model.init(t, parameters);
    TT_model.init(t, parameters);
    TT_lig_model.init(t, parameters);
    PlastoVisu_model.init(t, parameters);
    ThermalTimeManager_model.init(t, parameters);
    PhenoStage_model.init(t, parameters);
}

void Model::compute(double t, bool /* update */)
{
    DeltaT_model.put(t, DeltaT::TA, _Ta);
    DeltaT_model(t);

    TT_model.put(t, Tt::DELTA_T, DeltaT_model.get(t, DeltaT::DELTA_T));
    TT_model(t);

    ThermalTimeManager_model.put(t, ThermalTimeManager::PHASE, _phase);
    if (is_ready(t, STOCK)) {
        ThermalTimeManager_model.put(t, ThermalTimeManager::STOCK, _stock);
    } else {
        ThermalTimeManager_model(t);
    }

    DD_model.put(t, Dd::DELTA_T, DeltaT_model.get(t, DeltaT::DELTA_T));
    DD_model.put(t, Dd::GROW, _grow);
    DD_model.put(t, Dd::PHASE,
                 ThermalTimeManager_model.get(t, ThermalTimeManager::STATE));
    DD_model.put(t, Dd::PLASTO_DELAY, _plasto_delay);
    DD_model(t);

    TT_lig_model.put(t, TT_lig::PHASE,
                     ThermalTimeManager_model.get(
                         t, ThermalTimeManager::STATE));
    TT_lig_model.put(t, TT_lig::EDD, DD_model.get(t, Dd::EDD));
    TT_lig_model.put(t, TT_lig::LIG, _lig);
    TT_lig_model(t);

    IH_model.put(t, Ih::TT_LIG, TT_lig_model.get(t, TT_lig::TT_LIG));
    PlastoVisu_model.put(t, PlastoVisu::EDD, DD_model.get(t, Dd::EDD));
    PlastoVisu_model.put(t, PlastoVisu::PHASE,
                         ThermalTimeManager_model.get(
                             t, ThermalTimeManager::STATE));
    PlastoVisu_model.put(t, PlastoVisu::PLASTO_DELAY, _plasto_delay);
    PlastoVisu_model(t);

    PhenoStage_model.put(t, PhenoStage::BOOL_CROSSED_PLASTO,
                         DD_model.get(t, Dd::BOOL_CROSSED_PLASTO));
    PhenoStage_model.put(t, PhenoStage::PHASE,
                         ThermalTimeManager_model.get(
                             t, ThermalTimeManager::STATE));
    PhenoStage_model(t);

    LiguloVisu_model.put(t, LiguloVisu::EDD, DD_model.get(t, Dd::EDD));
    LiguloVisu_model.put(t, LiguloVisu::PHASE,
                         ThermalTimeManager_model.get(
                             t, ThermalTimeManager::STATE));
    LiguloVisu_model.put(t, LiguloVisu::PLASTO_DELAY, _plasto_delay);
    LiguloVisu_model(t);

    IH_model.put(t, Ih::LIG, _lig);
    IH_model.put(t, Ih::PHASE,
                 ThermalTimeManager_model.get(t, ThermalTimeManager::STATE));
    IH_model.put(t, Ih::LIGULO_VISU,
                 LiguloVisu_model.get(t, LiguloVisu::LIGULO_VISU));
    IH_model(t);
}

} } } // namespace ecomeristem plant thermal_time

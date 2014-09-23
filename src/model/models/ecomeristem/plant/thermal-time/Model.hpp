/**
 * @file ecomeristem/plant/thermal-time/Model.hpp
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

class Model : public AbstractCoupledModel < Model >
{
public:
    static const int DD = 0;
    static const int DELTA_T = 1;
    static const int EDD = 2;
    static const int IH = 3;
    static const int LIGULO_VISU = 4;
    static const int PHENO_STAGE = 5;
    static const int PLASTO_VISU = 6;
    static const int TT = 7;
    static const int TT_LIG = 8;
    static const int BOOL_CROSSED_PLASTO = 9;

    static const int STOCK = 0;
    static const int TA = 1;
    static const int GROW = 2;
    static const int LIG = 3;
    static const int PLASTO_DELAY = 4;

    Model()
    {
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

        external(STOCK, &Model::_stock);
        external(TA, &Model::_Ta);
        external(GROW, &Model::_grow);
        external(LIG, &Model::_lig);
        external(PLASTO_DELAY, &Model::_plasto_delay);
    }

    virtual ~Model()
    { }

    void build()
    { }

    void init(double t, const model::models::ModelParameters& parameters)
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

    void compute(double t)
    {
        DeltaT_model.put(t, DeltaT::TA, _Ta);
        DeltaT_model.compute(t);

        TT_model.put(t, Tt::DELTA_T, DeltaT_model.get(DeltaT::DELTA_T));
        TT_model.compute(t);

        ThermalTimeManager_model.put(t, ThermalTimeManager::STOCK, _stock);
        ThermalTimeManager_model.compute(t);

        DD_model.put(t, Dd::DELTA_T, DeltaT_model.get(DeltaT::DELTA_T));
        DD_model.put(t, Dd::GROW, _grow);
        DD_model.put(t, Dd::PHASE,
                     ThermalTimeManager_model.get(ThermalTimeManager::PHASE));
        DD_model.put(t, Dd::PLASTO_DELAY, _plasto_delay);
        DD_model.compute(t);

        TT_lig_model.put(t, TT_lig::EDD, DD_model.get(Dd::EDD));
        TT_lig_model.compute(t);

        IH_model.put(t, Ih::TT_LIG, TT_lig_model.get(TT_lig::TT_LIG));
        IH_model.put(t, Ih::LIG, _lig);
        IH_model.compute(t);

        PlastoVisu_model.put(t, PlastoVisu::EDD, DD_model.get(Dd::EDD));
        PlastoVisu_model.put(t, PlastoVisu::PHASE,
                             ThermalTimeManager_model.get(
                                 ThermalTimeManager::PHASE));
        PlastoVisu_model.put(t, PlastoVisu::PLASTO_DELAY, _plasto_delay);
        PlastoVisu_model.compute(t);

        PhenoStage_model.put(t, PhenoStage::BOOL_CROSSED_PLASTO,
                             DD_model.get(Dd::BOOL_CROSSED_PLASTO));
        PhenoStage_model.put(t, PhenoStage::PHASE,
                             ThermalTimeManager_model.get(
                                 ThermalTimeManager::PHASE));
        PhenoStage_model.compute(t);

        LiguloVisu_model.put(t, LiguloVisu::EDD, DD_model.get(Dd::EDD));
        LiguloVisu_model.put(t, LiguloVisu::PHASE,
                             ThermalTimeManager_model.get(
                                 ThermalTimeManager::PHASE));
        LiguloVisu_model.put(t, LiguloVisu::PLASTO_DELAY, _plasto_delay);
        LiguloVisu_model.compute(t);
    }

    // virtual void put(double t, unsigned int index, double value)
    // {
    //     AbstractAtomicModel < Model >::put(t, index, value);
    //     if (index == GROW) {
    //     } else if (index == PHASE) {
    //     }
    // }

private:
// external variables
    double _stock;
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
    ecomeristem::plant::thermal_time::ThermalTimeManager ThermalTimeManager_model;
    ecomeristem::plant::thermal_time::PhenoStage PhenoStage_model;

};

} } } // namespace ecomeristem plant thermal_time

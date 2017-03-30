/**
 * @file ecomeristem/leaf/Model.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2017 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2017 ULCO http://www.univ-littoral.fr
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

#include <model/models/ecomeristem/leaf/LeafTimeFromApp.hpp>
#include <model/models/ecomeristem/leaf/Biomass.hpp>
#include <model/models/ecomeristem/leaf/LeafExpTime.hpp>
#include <model/models/ecomeristem/leaf/LeafLen.hpp>
#include <model/models/ecomeristem/leaf/LeafPredim.hpp>
#include <model/models/ecomeristem/leaf/Width.hpp>
#include <model/models/ecomeristem/leaf/BladeArea.hpp>
#include <model/models/ecomeristem/leaf/LeafLastDemand.hpp>
#include <model/models/ecomeristem/leaf/LER.hpp>
#include <model/models/ecomeristem/leaf/ReductionLER.hpp>
#include <model/models/ecomeristem/leaf/LeafDemand.hpp>
#include <model/models/ecomeristem/leaf/LeafManager.hpp>
#include <model/models/ecomeristem/leaf/PlastoDelay.hpp>
#include <model/models/ecomeristem/leaf/LifeSpan.hpp>
#include <model/models/ecomeristem/leaf/ThermalTimeSinceLigulation.hpp>

namespace ecomeristem { namespace leaf {

class LeafModel : public ecomeristem::AbstractCoupledModel < LeafModel >
{
public:
    enum submodels { TIME_FROM_APP, BIOMASS_, EXP_TIME, LEN_, PREDIM_, WIDTH,
                     BLADE_AREA_, LAST_DEMAND_, LER, REDUCTION_LER,
                     DEMAND_, MANAGER, PLASTO_DELAY_, LIFE_SPAN,
                     THERMAL_TIME_SINCE_LIGULATION };
    enum internals { BIOMASS, BLADE_AREA, DEMAND, LAST_DEMAND, PREDIM,
                     PLASTO_DELAY, REALLOC_BIOMASS, SENESC_DW,
                     SENESC_DW_SUM, CORRECTED_BIOMASS, CORRECTED_BLADE_AREA,
                     LEN };
    enum externals { DD, DELTA_T, FTSW, FCSTR, P, PHENO_STAGE,
                     PREDIM_LEAF_ON_MAINSTEM, PREDIM_PREVIOUS_LEAF,
                     SLA, GROW, PHASE, STATE, STOP, TEST_IC };

    LeafModel(int index, bool is_on_mainstem);

    virtual ~LeafModel()
    { }

    void compute(double t, bool /* update */);
    void init(double t,
              const model::models::ModelParameters& parameters);

    double get_blade_area() const
    { return blade_area_model.get_blade_area(); }

private:
// parameters
    int _index;
    bool _is_first_leaf;
    bool _is_on_mainstem;

// submodels
    LeafTimeFromApp time_from_app_model;
    LeafBiomass biomass_model;
    LeafExpTime exp_time_model;
    LeafLen len_model;
    LeafPredim predim_model;
    Width width_model;
    BladeArea blade_area_model;
    LeafLastDemand last_demand_model;
    Ler ler_model;
    ReductionLER reduction_ler_model;
    LeafDemand leaf_demand_model;
    LeafManager manager_model;
    PlastoDelay plasto_delay_model;
    LifeSpan life_span_model;
    ThermalTimeSinceLigulation thermal_time_since_ligulation_model;

// external variables
    double _dd;
    double _delta_t;
    double _ftsw;
    double _fcstr;
    double _p;
    double _pheno_stage;
    double _predim_leaf_on_mainstem;
    double _predim_previous_leaf;
    double _sla;
    double _grow;
    double _phase;
    double _state;
    double _stop;
    double _test_ic;
};

} } // namespace ecomeristem leaf

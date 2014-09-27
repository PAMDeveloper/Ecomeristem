/**
 * @file ecomeristem/leaf/Model.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
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

#include <model/kernel/AbstractCoupledModel.hpp>

#include <model/models/ecomeristem/leaf/TimeFromApp.hpp>
#include <model/models/ecomeristem/leaf/Biomass.hpp>
#include <model/models/ecomeristem/leaf/ExpTime.hpp>
#include <model/models/ecomeristem/leaf/Len.hpp>
#include <model/models/ecomeristem/leaf/Predim.hpp>
#include <model/models/ecomeristem/leaf/Width.hpp>
#include <model/models/ecomeristem/leaf/BladeArea.hpp>
#include <model/models/ecomeristem/leaf/LastDemand.hpp>
#include <model/models/ecomeristem/leaf/LER.hpp>
#include <model/models/ecomeristem/leaf/ReductionLER.hpp>
#include <model/models/ecomeristem/leaf/LeafDemand.hpp>
#include <model/models/ecomeristem/leaf/Manager.hpp>
#include <model/models/ecomeristem/leaf/PlastoDelay.hpp>

namespace ecomeristem { namespace leaf {

class Model : public AbstractCoupledModel < Model >
{
public:
    enum internals { BIOMASS, BLADE_AREA, DEMAND, LAST_DEMAND, PREDIM,
                     PLASTO_DELAY };
    enum externals { DD, DELTA_T, FTSW, FCSTR, P, PHENO_STAGE,
                     PREDIM_LEAF_ON_MAINSTEM, PREDIM_PREVIOUS_LEAF,
                     SLA, GROW, PHASE, STOP, TEST_IC };

    Model(int index, bool is_on_mainstem) :
        _index(index),
        _is_first_leaf(_index == 1), _is_on_mainstem(is_on_mainstem),
        exp_time_model(_is_first_leaf, _is_on_mainstem),
        predim_model(_is_first_leaf, _is_on_mainstem),
        ler_model(index)
    {
        internal(BIOMASS, &biomass_model, Biomass::BIOMASS);
        internal(BLADE_AREA, &blade_area_model, BladeArea::BLADE_AREA);
        internal(DEMAND, &leaf_demand_model, LeafDemand::DEMAND);
        internal(LAST_DEMAND, &last_demand_model, LastDemand::LAST_DEMAND);
        internal(PREDIM, &predim_model, Predim::PREDIM);
        internal(PLASTO_DELAY, &plasto_delay_model, PlastoDelay::PLASTO_DELAY);

        external(DD, &Model::_dd);
        external(DELTA_T, &Model::_delta_t);
        external(FTSW, &Model::_ftsw);
        external(FCSTR, &Model::_fcstr);
        external(P, &Model::_p);
        external(PHENO_STAGE, &Model::_pheno_stage);
        external(PREDIM_LEAF_ON_MAINSTEM, &Model::_predim_leaf_on_mainstem);
        external(PREDIM_PREVIOUS_LEAF, &Model::_predim_previous_leaf);
        external(SLA, &Model::_sla);
        external(GROW, &Model::_grow);
        external(PHASE, &Model::_phase);
        external(STOP, &Model::_stop);
        external(TEST_IC, &Model::_test_ic);
    }

    virtual ~Model()
    { }

    void init(double t,
              const model::models::ModelParameters& parameters)
    {
        time_from_app_model.init(t, parameters);
        biomass_model.init(t, parameters);
        exp_time_model.init(t, parameters);
        len_model.init(t, parameters);
        predim_model.init(t, parameters);
        width_model.init(t, parameters);
        blade_area_model.init(t, parameters);
        last_demand_model.init(t, parameters);
        ler_model.init(t, parameters);
        reduction_ler_model.init(t, parameters);
        leaf_demand_model.init(t, parameters);
        manager_model.init(t, parameters);
        plasto_delay_model.init(t, parameters);
    }

    void compute(double t, bool /* update */)
    {
        predim_model.put(t, Predim::FCSTR, _fcstr);
        predim_model.put(t, Predim::PREDIM_LEAF_ON_MAINSTEM,
                         _predim_leaf_on_mainstem);
        predim_model.put(t, Predim::PREDIM_PREVIOUS_LEAF,
                         _predim_previous_leaf);
        predim_model.put(t, Predim::TEST_IC, _test_ic);
        predim_model(t);

        reduction_ler_model.put(t, ReductionLER::FTSW, _ftsw);
        reduction_ler_model.put(t, ReductionLER::P, _p);
        reduction_ler_model(t);

        ler_model.put(t, Ler::PREDIM,
                      predim_model.get(Predim::PREDIM));
        ler_model.put(t, Ler::REDUCTION_LER,
                      reduction_ler_model.get(ReductionLER::REDUCTION_LER));
        ler_model(t);

        exp_time_model.put(t, ExpTime::LER, ler_model.get(Ler::LER));
        exp_time_model.put(t, ExpTime::DD, _dd);
        exp_time_model.put(t, ExpTime::PREDIM,
                           predim_model.get(Predim::PREDIM));
        exp_time_model.put(t, ExpTime::LEN, len_model.get(Len::LEN));
        exp_time_model(t);

        len_model.put(t, Len::DD, _dd);
        len_model.put(t, Len::DELTA_T, _delta_t);
        len_model.put(t, Len::EXP_TIME,
                      exp_time_model.get(ExpTime::EXP_TIME));
        len_model.put(t, Len::LER, ler_model.get(Ler::LER));
        len_model.put(t, Len::GROW, _grow);
        len_model.put(t, Len::PHASE, _phase);
        len_model(t);

        manager_model.put(t, Manager::LEN, len_model.get(Len::LEN));
        manager_model.put(t, Manager::PREDIM, predim_model.get(Predim::PREDIM));
        manager_model.put(t, Manager::PHASE, _phase);
        manager_model.put(t, Manager::STOP, _stop);

        plasto_delay_model.put(t, PlastoDelay::DELTA_T, _delta_t);
        plasto_delay_model.put(t, PlastoDelay::REDUCTION_LER,
                               reduction_ler_model.get(
                                   ReductionLER::REDUCTION_LER));
        plasto_delay_model.put(t, PlastoDelay::EXP_TIME,
                               exp_time_model.get(ExpTime::EXP_TIME));
        plasto_delay_model(t);

        width_model.put(t, Width::LEN, len_model.get(Len::LEN));
        width_model(t);

        blade_area_model.put(t, BladeArea::LEN, len_model.get(Len::LEN));
        blade_area_model.put(t, BladeArea::WIDTH,
                             width_model.get(Width::WIDTH));
        blade_area_model(t);

        biomass_model.put(t, Biomass::GROW, _grow);
        biomass_model.put(t, Biomass::SLA, _sla);
        biomass_model.put(t, Biomass::PHASE,
                          manager_model.get(Manager::LEAF_PHASE));
        biomass_model.put(t, Biomass::BLADE_AREA,
                          blade_area_model.get(BladeArea::BLADE_AREA));
        biomass_model(t);

        leaf_demand_model.put(t, LeafDemand::GROW, _grow);
        leaf_demand_model.put(t, LeafDemand::PHASE,
                              manager_model.get(Manager::LEAF_PHASE));
        leaf_demand_model.put(t, LeafDemand::BIOMASS,
                              biomass_model.get(Biomass::BIOMASS));
        leaf_demand_model(t);

        last_demand_model.put(t, LastDemand::PHASE,
                              manager_model.get(Manager::LEAF_PHASE));
        last_demand_model.put(t, LastDemand::BIOMASS,
                              biomass_model.get(Biomass::BIOMASS));
        last_demand_model(t);

        time_from_app_model.put(t, TimeFromApp::PHASE,
                                manager_model.get(Manager::LEAF_PHASE));
        time_from_app_model.put(t, TimeFromApp::DD, _dd);
        time_from_app_model.put(t, TimeFromApp::DELTA_T, _delta_t);
        time_from_app_model(t);
    }

private:
// parameters
    int _index;
    bool _is_first_leaf;
    bool _is_on_mainstem;

// submodels
    TimeFromApp time_from_app_model;
    Biomass biomass_model;
    ExpTime exp_time_model;
    Len len_model;
    Predim predim_model;
    Width width_model;
    BladeArea blade_area_model;
    LastDemand last_demand_model;
    Ler ler_model;
    ReductionLER reduction_ler_model;
    LeafDemand leaf_demand_model;
    Manager manager_model;
    PlastoDelay plasto_delay_model;

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
    double _stop;
    double _test_ic;
};

} } // namespace ecomeristem leaf

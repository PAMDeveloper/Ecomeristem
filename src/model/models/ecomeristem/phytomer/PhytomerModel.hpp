/**
 * @file ecomeristem/phytomer/Model.hpp
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
#include <model/models/ecomeristem/internode/InternodeModel.hpp>
#include <model/models/ecomeristem/leaf/LeafModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace phytomer {

class PhytomerModel : public ecomeristem::AbstractCoupledModel < PhytomerModel >
{
public:
    enum submodels { LEAF, INTERNODE };

    enum internals { LEAF_BIOMASS, LEAF_BLADE_AREA, LEAF_DEMAND,
                     INTERNODE_DEMAND, INTERNODE_LAST_DEMAND, INTERNODE_BIOMASS,
                     INTERNODE_LEN, LEAF_LAST_DEMAND, PREDIM, PLASTO_DELAY,
                     REALLOC_BIOMASS, SENESC_DW, SENESC_DW_SUM,
                     LEAF_CORRECTED_BIOMASS, LEAF_CORRECTED_BLADE_AREA,
                     LEAF_LEN };
    enum externals { DD, DELTA_T, FTSW, FCSTR, P, PHENO_STAGE,
                     PREDIM_LEAF_ON_MAINSTEM, PREDIM_PREVIOUS_LEAF,
                     SLA, GROW, PHASE, STATE, STOP, TEST_IC };

    PhytomerModel(int index, bool is_on_mainstem) :
        _index(index), _is_first_leaf(index == 1),
        _is_on_mainstem(is_on_mainstem),
        internode_model(new internode::InternodeModel(_index, _is_on_mainstem)),
        leaf_model(new leaf::LeafModel(_index, _is_on_mainstem))
    {
        S({ { LEAF, leaf_model }, { INTERNODE, internode_model } });

        internal(LEAF_BIOMASS, leaf_model, leaf::LeafModel::BIOMASS);
        internal(LEAF_BLADE_AREA, leaf_model, leaf::LeafModel::BLADE_AREA);
        internal(LEAF_DEMAND, leaf_model, leaf::LeafModel::DEMAND);
        internal(LEAF_LAST_DEMAND, leaf_model, leaf::LeafModel::LAST_DEMAND);
        internal(PREDIM, leaf_model, leaf::LeafModel::PREDIM);
        internal(PLASTO_DELAY, leaf_model, leaf::LeafModel::PLASTO_DELAY);
        internal(REALLOC_BIOMASS, leaf_model, leaf::LeafModel::REALLOC_BIOMASS);
        internal(SENESC_DW, leaf_model, leaf::LeafModel::SENESC_DW);
        internal(SENESC_DW_SUM, leaf_model, leaf::LeafModel::SENESC_DW_SUM);
        internal(LEAF_CORRECTED_BIOMASS, leaf_model,
                 leaf::LeafModel::CORRECTED_BIOMASS);
        internal(LEAF_CORRECTED_BLADE_AREA, leaf_model,
                 leaf::LeafModel::CORRECTED_BLADE_AREA);
        internal(LEAF_LEN, leaf_model, leaf::LeafModel::LEN);

        internal(INTERNODE_LAST_DEMAND, internode_model,
                 internode::InternodeModel::LAST_DEMAND);
        internal(INTERNODE_DEMAND, internode_model, internode::InternodeModel::DEMAND);
        internal(INTERNODE_BIOMASS, internode_model,
                 internode::InternodeModel::BIOMASS);
        internal(INTERNODE_LEN, internode_model,
                 internode::InternodeModel::LEN);

        external(DD, &PhytomerModel::_dd);
        external(DELTA_T, &PhytomerModel::_delta_t);
        external(FTSW, &PhytomerModel::_ftsw);
        external(FCSTR, &PhytomerModel::_fcstr);
        external(P, &PhytomerModel::_p);
        external(PHENO_STAGE, &PhytomerModel::_pheno_stage);
        external(PREDIM_LEAF_ON_MAINSTEM, &PhytomerModel::_predim_leaf_on_mainstem);
        external(PREDIM_PREVIOUS_LEAF, &PhytomerModel::_predim_previous_leaf);
        external(SLA, &PhytomerModel::_sla);
        external(GROW, &PhytomerModel::_grow);
        external(PHASE, &PhytomerModel::_phase);
        external(STATE, &PhytomerModel::_state);
        external(STOP, &PhytomerModel::_stop);
        external(TEST_IC, &PhytomerModel::_test_ic);
    }

    virtual ~PhytomerModel()
    {
        if (internode_model) delete internode_model;
        if (leaf_model) delete leaf_model;
    }

    void init(double t, const model::models::ModelParameters& parameters)
    {
        internode_model->init(t, parameters);
        leaf_model->init(t, parameters);
        _lig = 0;
        _leaf_predim = 0;
        _first_day = t;
        _null = 0;
    }

    void compute(double t, bool /* update */)
    {

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("PHYTOMER", t, artis::utils::COMPUTE)
            << "COMPUTE : index = " << _index;
        utils::Trace::trace().flush();
#endif

        if (leaf_model) {
            leaf_model->put(t, leaf::LeafModel::DD, _dd);
            leaf_model->put(t, leaf::LeafModel::DELTA_T, _delta_t);
            leaf_model->put(t, leaf::LeafModel::FTSW, _ftsw);
            leaf_model->put(t, leaf::LeafModel::FCSTR, _fcstr);
            leaf_model->put(t, leaf::LeafModel::P, _p);
            leaf_model->put(t, leaf::LeafModel::PHENO_STAGE, _pheno_stage);
            leaf_model->put(t, leaf::LeafModel::PREDIM_LEAF_ON_MAINSTEM,
                            _predim_leaf_on_mainstem);
            leaf_model->put(t, leaf::LeafModel::PREDIM_PREVIOUS_LEAF,
                            _predim_previous_leaf);
            leaf_model->put(t, leaf::LeafModel::SLA, _sla);
            leaf_model->put(t, leaf::LeafModel::GROW, _grow);
            leaf_model->put(t, leaf::LeafModel::PHASE, _phase);
            leaf_model->put(t, leaf::LeafModel::STATE, _state);
            leaf_model->put(t, leaf::LeafModel::STOP, _stop);
            if (is_ready(t, TEST_IC)) {
                leaf_model->put(t, leaf::LeafModel::TEST_IC, _test_ic);
            }
            (*leaf_model)(t);

            if (_lig == 0) {
                if (leaf_model->is_computed(t, leaf::LeafModel::PREDIM) and
                    leaf_model->is_computed(t, leaf::LeafModel::LEN) and
                    leaf_model->get < double, leaf::LeafPredim >(
                        t, leaf::LeafModel::PREDIM) ==
                    leaf_model->get < double, leaf::LeafLen >(
                        t, leaf::LeafModel::LEN)) {
                    _lig = t;
                }
            }
        }

        internode_model->put(t, internode::InternodeModel::DD, _dd);
        internode_model->put(t, internode::InternodeModel::DELTA_T, _delta_t);
        internode_model->put(t, internode::InternodeModel::FTSW, _ftsw);
        internode_model->put(t, internode::InternodeModel::P, _p);
        internode_model->put(t, internode::InternodeModel::PHASE, _phase);
        internode_model->put(t, internode::InternodeModel::STATE, _state);
        internode_model->put(t, internode::InternodeModel::LIG, _lig);
        if (leaf_model and leaf_model->is_computed(t, leaf::LeafModel::PREDIM)) {
            internode_model->put(t, internode::InternodeModel::PREDIM_LEAF,
                                 leaf_model->get < double,
                                 leaf::LeafPredim >(t, leaf::LeafModel::PREDIM));
            _leaf_predim = leaf_model->get < double, leaf::LeafPredim >(
                t, leaf::LeafModel::PREDIM);
        } else {
            if (t != _first_day) {
                internode_model->put(
                    t, internode::InternodeModel::PREDIM_LEAF, _leaf_predim);
            }
        }
        (*internode_model)(t);
    }

    void delete_leaf(double t)
    {

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM", t, artis::utils::COMPUTE)
            << "ADD LIG ; DELETE index = " << _index;
        utils::Trace::trace().flush();
#endif

        delete leaf_model;
        leaf_model = 0;

        change_internal(LEAF_BIOMASS, &PhytomerModel::_null);
        change_internal(LEAF_BLADE_AREA, &PhytomerModel::_null);
        change_internal(LEAF_DEMAND, &PhytomerModel::_null);
        change_internal(LEAF_LAST_DEMAND, &PhytomerModel::_null);
        change_internal(PREDIM, &PhytomerModel::_null);
        change_internal(PLASTO_DELAY, &PhytomerModel::_null);
        change_internal(REALLOC_BIOMASS, &PhytomerModel::_null);
        change_internal(SENESC_DW, &PhytomerModel::_null);
        change_internal(SENESC_DW_SUM, &PhytomerModel::_null);
        change_internal(LEAF_CORRECTED_BIOMASS, &PhytomerModel::_null);
        change_internal(LEAF_CORRECTED_BLADE_AREA, &PhytomerModel::_null);
        change_internal(LEAF_LEN, &PhytomerModel::_null);
    }

    double get_blade_area() const
    { return leaf_model->get_blade_area(); }

    const leaf::LeafModel& leaf() const
    { return *leaf_model; }

    const internode::InternodeModel& internode() const
    { return *internode_model; }

    int get_index() const
    { return _index; }

    bool is_leaf_dead() const
    { return leaf_model == 0; }

private:
// parameters
    int _index;
    bool _is_first_leaf;
    bool _is_on_mainstem;

// submodels
    internode::InternodeModel* internode_model;
    leaf::LeafModel* leaf_model;

// internal variables
    double _lig;
    double _leaf_predim;
    double _first_day;
    double _null;

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

} } // namespace ecomeristem phytomer

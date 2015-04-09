/**
 * @file ecomeristem/culm/Model.cpp
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

#include <model/models/ecomeristem/culm/Model.hpp>

namespace ecomeristem { namespace culm {

Model::Model(int index) : _index(index), _is_first_culm(index == 1)
{
    internal(LEAF_BIOMASS_SUM, &Model::_leaf_biomass_sum);
    internal(LEAF_LAST_DEMAND_SUM, &Model::_leaf_last_demand_sum);
    internal(LEAF_DEMAND_SUM, &Model::_leaf_demand_sum);
    internal(INTERNODE_LAST_DEMAND_SUM, &Model::_internode_last_demand_sum);
    internal(INTERNODE_DEMAND_SUM, &Model::_internode_demand_sum);
    internal(INTERNODE_BIOMASS_SUM, &Model::_internode_biomass_sum);
    internal(LEAF_BLADE_AREA_SUM, &Model::_leaf_blade_area_sum);
    internal(LEAF_PREDIM, &Model::_leaf_predim);
    internal(REALLOC_BIOMASS_SUM, &Model::_realloc_biomass_sum);
    internal(SENESC_DW_SUM, &Model::_senesc_dw_sum);
    internal(LIG, &Model::_lig);

    external(DD, &Model::_dd);
    external(DELTA_T, &Model::_delta_t);
    external(FTSW, &Model::_ftsw);
    external(FCSTR, &Model::_fcstr);
    external(P, &Model::_p);
    external(PHENO_STAGE, &Model::_pheno_stage);
    external(PREDIM_LEAF_ON_MAINSTEM, &Model::_predim_leaf_on_mainstem);
    external(SLA, &Model::_sla);
    external(GROW, &Model::_grow);
    external(PHASE, &Model::_phase);
    external(STATE, &Model::_state);
    external(STOP, &Model::_stop);
    external(TEST_IC, &Model::_test_ic);
}

void Model::init(double t, const model::models::ModelParameters& parameters)
{
    phytomer::Model* first_phytomer = new phytomer::Model(1,
                                                          _is_first_culm);

    first_phytomer->init(t, parameters);
    phytomer_models.push_back(first_phytomer);

    _parameters = &parameters;
    _first_day = t;

    _leaf_biomass_sum = 0;
    _leaf_last_demand_sum = 0;
    _leaf_demand_sum = 0;
    _internode_last_demand_sum = 0;
    _internode_demand_sum = 0;
    _internode_biomass_sum = 0;
    _leaf_blade_area_sum = 0;

    _grow = 0;
    _lig = 0;
    _deleted_leaf_number = 0;
}

bool Model::is_stable(double t) const
{
    std::deque < phytomer::Model* >::const_iterator it =
        phytomer_models.begin();
    bool stable = true;

    while (stable and it != phytomer_models.end()) {
        stable = (*it)->is_stable(t);
        ++it;
    }
    return stable;
}

void Model::compute(double t, bool /* update */)
{
    std::deque < phytomer::Model* >::iterator it =
        phytomer_models.begin();
    std::deque < phytomer::Model* >::iterator previous_it;
    int i = 0;
    double old_lig = _lig;
    bool ok = true;

    _leaf_biomass_sum = 0;
    _leaf_last_demand_sum = 0;
    _leaf_demand_sum = 0;
    _internode_last_demand_sum = 0;
    _internode_demand_sum = 0;
    _internode_biomass_sum = 0;
    _leaf_blade_area_sum = 0;
    _realloc_biomass_sum = 0;
    _senesc_dw_sum = 0;
    _lig = _deleted_leaf_number;
    while (it != phytomer_models.end()) {
        (*it)->put(t, phytomer::Model::DD, _dd);
        (*it)->put(t, phytomer::Model::DELTA_T, _delta_t);
        (*it)->put(t, phytomer::Model::FTSW, _ftsw);
        (*it)->put(t, phytomer::Model::FCSTR, _fcstr);
        (*it)->put(t, phytomer::Model::P, _p);
        (*it)->put(t, phytomer::Model::PHENO_STAGE, _pheno_stage);
        if (_is_first_culm) {
            if (i == 0) {
                (*it)->put(t, phytomer::Model::PREDIM_LEAF_ON_MAINSTEM, 0);
            } else {
                if ((*previous_it)->is_stable(t)) {
                    (*it)->put(
                        t, phytomer::Model::PREDIM_LEAF_ON_MAINSTEM,
                        (*previous_it)->get(t, phytomer::Model::PREDIM));
                }
            }
        } else {
            (*it)->put(t, phytomer::Model::PREDIM_LEAF_ON_MAINSTEM,
                       _predim_leaf_on_mainstem);
        }
        if (i == 0) {
            (*it)->put(t, phytomer::Model::PREDIM_PREVIOUS_LEAF, 0);
        } else {
            if ((*previous_it)->is_stable(t)) {
                (*it)->put(t, phytomer::Model::PREDIM_PREVIOUS_LEAF,
                           (*previous_it)->get(t, phytomer::Model::PREDIM));
            }
            // else {
            //     (*it)->put(t, phytomer::Model::PREDIM_PREVIOUS_LEAF, 0);
            // }
        }
        (*it)->put(t, phytomer::Model::SLA, _sla);
        (*it)->put(t, phytomer::Model::GROW, _grow);
        (*it)->put(t, phytomer::Model::PHASE, _phase);
        (*it)->put(t, phytomer::Model::STATE, _state);
        (*it)->put(t, phytomer::Model::STOP, _stop);
        if (is_ready(t, TEST_IC)) {
            (*it)->put(t, phytomer::Model::TEST_IC, _test_ic);
        }
        (**it)(t);

        if ((*it)->get(t, phytomer::Model::LEAF_CORRECTED_BIOMASS) == 0) {
            _leaf_biomass_sum +=
                (*it)->get(t, phytomer::Model::LEAF_BIOMASS);
        } else {
            _leaf_biomass_sum +=
                (*it)->get(t, phytomer::Model::LEAF_CORRECTED_BIOMASS);
        }

        _leaf_last_demand_sum +=
            (*it)->get(t, phytomer::Model::LEAF_LAST_DEMAND);
        _leaf_demand_sum += (*it)->get(t, phytomer::Model::LEAF_DEMAND);
        _internode_last_demand_sum += (*it)->get(
            t, phytomer::Model::INTERNODE_LAST_DEMAND);
        _internode_demand_sum += (*it)->get(
            t, phytomer::Model::INTERNODE_DEMAND);
        _internode_biomass_sum += (*it)->get(
            t, phytomer::Model::INTERNODE_BIOMASS);

        if ((*it)->get(t
                       , phytomer::Model::LEAF_CORRECTED_BLADE_AREA) == 0) {
            _leaf_blade_area_sum +=
                (*it)->get(t, phytomer::Model::LEAF_BLADE_AREA);
        } else {
            _leaf_blade_area_sum +=
                (*it)->get(t, phytomer::Model::LEAF_CORRECTED_BLADE_AREA);
        }

        _realloc_biomass_sum +=
            (*it)->get(t, phytomer::Model::REALLOC_BIOMASS);
        _senesc_dw_sum +=
            (*it)->get(t, phytomer::Model::SENESC_DW);

        if ((*it)->is_computed(t, phytomer::Model::PREDIM)) {
            // if leaf state = lig
            if ((*it)->get(t, phytomer::Model::LEAF_LEN) ==
                (*it)->get(t, phytomer::Model::PREDIM)) {
                ++_lig;
            }
            if (i == 0) {
                _leaf_predim = (*it)->get(t, phytomer::Model::PREDIM);
            } else {
                // if leaf state = lig
                if ((*it)->get(t, phytomer::Model::LEAF_LEN) ==
                    (*it)->get(t, phytomer::Model::PREDIM)) {
                    _leaf_predim = (*it)->get(t, phytomer::Model::PREDIM);
                }
            }
        } else {
            ok = false;
        }
        previous_it = it;
        ++it;
        ++i;
    }

    if (not ok) {
        _lig = old_lig;
    }

#ifdef WITH_TRACE
    utils::Trace::trace()
        << utils::TraceElement("CULM", t, utils::COMPUTE)
        << "Predim = " << _leaf_predim
        << " ; index = " << _index
        << " ; lig = " << _lig
        << " ; leaf biomass sum = " << _leaf_biomass_sum
        << " ; intenade biomass sum = " << _internode_biomass_sum
        << " ; leaf number = "
        << (_deleted_leaf_number + phytomer_models.size())
        << " ; deleted leaf number = " << _deleted_leaf_number;
    utils::Trace::trace().flush();
#endif

}

void Model::create_phytomer(double t)
{
    if (t != _first_day) {

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM", t, utils::COMPUTE)
            << "CREATE PHYTOMER: " << (phytomer_models.size() + 1)
            << " ; index = " << _index;
        utils::Trace::trace().flush();
#endif

        phytomer::Model* phytomer = new phytomer::Model(
            phytomer_models.size() + 1, _is_first_culm);

        phytomer->init(t, *_parameters);
        phytomer_models.push_back(phytomer);
        compute(t, true);
    }
}

void Model::delete_leaf(int index)
{
    delete phytomer_models[index];
    phytomer_models.erase(phytomer_models.begin() + index);
    ++_deleted_leaf_number;
}

double Model::get_leaf_biomass(double t, int index) const
{
    double biomass = phytomer_models[index]->get(
        t, phytomer::Model::LEAF_BIOMASS);
    double corrected_biomass =
        phytomer_models[index]->get(
            t, phytomer::Model::LEAF_CORRECTED_BIOMASS);

    if (corrected_biomass > 0) {
        return corrected_biomass;
    } else {
        return biomass;
    }
}

int Model::get_first_ligulated_leaf_index(double t) const
{
    std::deque < phytomer::Model* >::const_iterator it =
        phytomer_models.begin();
    int i = 0;

    while (it != phytomer_models.end() and
           (*it)->get(t, phytomer::Model::LEAF_LEN) !=
           (*it)->get(t, phytomer::Model::PREDIM)) {
        ++it;
        ++i;
    }
    if (it != phytomer_models.end()) {
        return i;
    } else {
        return -1;
    }
}

} } // namespace ecomeristem culm

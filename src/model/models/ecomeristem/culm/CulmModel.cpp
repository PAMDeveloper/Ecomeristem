/**
 * @file ecomeristem/culm/Model.cpp
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

#include <model/models/ecomeristem/culm/CulmModel.hpp>

namespace ecomeristem { namespace culm {

CulmModel::CulmModel(int index) : _index(index), _is_first_culm(index == 1)
{
    internal(LEAF_BIOMASS_SUM, &CulmModel::_leaf_biomass_sum);
    internal(LEAF_LAST_DEMAND_SUM, &CulmModel::_leaf_last_demand_sum);
    internal(LEAF_DEMAND_SUM, &CulmModel::_leaf_demand_sum);
    internal(INTERNODE_LAST_DEMAND_SUM, &CulmModel::_internode_last_demand_sum);
    internal(INTERNODE_DEMAND_SUM, &CulmModel::_internode_demand_sum);
    internal(INTERNODE_BIOMASS_SUM, &CulmModel::_internode_biomass_sum);
    internal(INTERNODE_LEN_SUM, &CulmModel::_internode_len_sum);
    internal(LEAF_BLADE_AREA_SUM, &CulmModel::_leaf_blade_area_sum);
    internal(LEAF_PREDIM, &CulmModel::_leaf_predim);
    internal(REALLOC_BIOMASS_SUM, &CulmModel::_realloc_biomass_sum);
    internal(SENESC_DW_SUM, &CulmModel::_senesc_dw_sum);
    internal(LIG, &CulmModel::_lig);
    internal(CULM_STOCK, &stock_model, CulmStock::STOCK);
    internal(CULM_DEFICIT, &deficit_model, Deficit::DEFICIT);
    internal(CULM_SURPLUS_SUM, &surplus_model, CulmSurplus::SURPLUS);

    external(DD, &CulmModel::_dd);
    external(DELTA_T, &CulmModel::_delta_t);
    external(FTSW, &CulmModel::_ftsw);
    external(FCSTR, &CulmModel::_fcstr);
    external(P, &CulmModel::_p);
    external(PHENO_STAGE, &CulmModel::_pheno_stage);
    external(PREDIM_LEAF_ON_MAINSTEM, &CulmModel::_predim_leaf_on_mainstem);
    external(SLA, &CulmModel::_sla);
    external(GROW, &CulmModel::_grow);
    external(PHASE, &CulmModel::_phase);
    external(STATE, &CulmModel::_state);
    external(STOP, &CulmModel::_stop);
    external(TEST_IC, &CulmModel::_test_ic);
    external(PLANT_STOCK, &CulmModel::_plant_stock);
    external(PLANT_DEFICIT, &CulmModel::_plant_deficit);
    external(PLANT_BIOMASS_SUM, &CulmModel::_plant_biomass_sum);
    external(PLANT_LEAF_BIOMASS_SUM, &CulmModel::_plant_leaf_biomass_sum);
    external(PLANT_BLADE_AREA_SUM, &CulmModel::_plant_blade_area_sum);
    external(ASSIM, &CulmModel::_assim);
}

void CulmModel::init(double t, const model::models::ModelParameters& parameters)
{
    phytomer::PhytomerModel* first_phytomer = new phytomer::PhytomerModel(1, _is_first_culm);

    setsubmodel(PHYTOMERS, first_phytomer);
    first_phytomer->init(t, parameters);
    phytomer_models.push_back(first_phytomer);

    deficit_model.init(t, parameters);
    intermediate_model.init(t, parameters);
    stock_model.init(t, parameters);
    surplus_model.init(t, parameters);
    supply_model.init(t, parameters);
    max_reservoir_dispo_model.init(t, parameters);

    _parameters = &parameters;
    _first_day = t;

    _leaf_biomass_sum = 0;
    _leaf_last_demand_sum = 0;
    _leaf_demand_sum = 0;
    _internode_last_demand_sum = 0;
    _internode_demand_sum = 0;
    _internode_biomass_sum = 0;
    _internode_len_sum = 0;
    _leaf_blade_area_sum = 0;

    _grow = 0;
    _lig = 0;
    _deleted_leaf_number = 0;
    _deleted_senesc_dw = 0;
    _deleted_senesc_dw_computed = false;
}

bool CulmModel::is_stable(double t) const
{
    std::deque < phytomer::PhytomerModel* >::const_iterator it =
        phytomer_models.begin();
    bool stable = true;

    while (stable and it != phytomer_models.end()) {
        stable = (*it)->is_stable(t);
        ++it;
    }
    return stable;
}

void CulmModel::compute(double t, bool update)
{
    std::deque < phytomer::PhytomerModel* >::iterator it =
        phytomer_models.begin();
    std::deque < phytomer::PhytomerModel* >::iterator previous_it;
    int i = 0;
    double old_lig = _lig;
    bool ok = true;

    if (not update and not _deleted_senesc_dw_computed) {
        _deleted_senesc_dw = 0;
    }

    _leaf_biomass_sum = 0;
    _leaf_last_demand_sum = 0;
    _leaf_demand_sum = 0;
    _internode_last_demand_sum = 0;
    _internode_demand_sum = 0;
    _internode_biomass_sum = 0;
    _internode_len_sum = 0;
    _leaf_blade_area_sum = 0;
    _realloc_biomass_sum = 0;
    _senesc_dw_sum = 0;
    _lig = _deleted_leaf_number;
    while (it != phytomer_models.end()) {
        (*it)->put(t, phytomer::PhytomerModel::DD, _dd);
        (*it)->put(t, phytomer::PhytomerModel::DELTA_T, _delta_t);
        (*it)->put(t, phytomer::PhytomerModel::FTSW, _ftsw);
        (*it)->put(t, phytomer::PhytomerModel::FCSTR, _fcstr);
        (*it)->put(t, phytomer::PhytomerModel::P, _p);
        (*it)->put(t, phytomer::PhytomerModel::PHENO_STAGE, _pheno_stage);
        if (_is_first_culm) {
            if (i == 0) {
                (*it)->put(t, phytomer::PhytomerModel::PREDIM_LEAF_ON_MAINSTEM, 0.);
            } else {
                if ((*previous_it)->is_stable(t)) {
                    (*it)->put(
                        t, phytomer::PhytomerModel::PREDIM_LEAF_ON_MAINSTEM,
                        (*previous_it)->get < double, leaf::LeafPredim >(
                            t, phytomer::PhytomerModel::PREDIM));
                }
            }
        } else {
            (*it)->put(t, phytomer::PhytomerModel::PREDIM_LEAF_ON_MAINSTEM,
                       _predim_leaf_on_mainstem);
        }
        if (i == 0) {
            (*it)->put(t, phytomer::PhytomerModel::PREDIM_PREVIOUS_LEAF, 0.);
        } else {
            if ((*previous_it)->is_stable(t)) {
                (*it)->put(t, phytomer::PhytomerModel::PREDIM_PREVIOUS_LEAF,
                           (*previous_it)->get < double, leaf::LeafPredim >(
                               t, phytomer::PhytomerModel::PREDIM));
            }
            // else {
            //     (*it)->put(t, phytomer::Model::PREDIM_PREVIOUS_LEAF, 0.);
            // }
        }
        (*it)->put(t, phytomer::PhytomerModel::SLA, _sla);
        (*it)->put(t, phytomer::PhytomerModel::GROW, _grow);
        (*it)->put(t, phytomer::PhytomerModel::PHASE, _phase);
        (*it)->put(t, phytomer::PhytomerModel::STATE, _state);
        (*it)->put(t, phytomer::PhytomerModel::STOP, _stop);
        if (is_ready(t, TEST_IC)) {
            (*it)->put(t, phytomer::PhytomerModel::TEST_IC, _test_ic);
        }
        (**it)(t);

        if ((*it)->get < double, leaf::LeafBiomass >(
                t, phytomer::PhytomerModel::LEAF_CORRECTED_BIOMASS) == 0) {
            _leaf_biomass_sum +=
                (*it)->get < double, leaf::LeafBiomass >(
                    t, phytomer::PhytomerModel::LEAF_BIOMASS);
        } else {
            _leaf_biomass_sum +=
                (*it)->get < double, leaf::LeafBiomass >(
                    t, phytomer::PhytomerModel::LEAF_CORRECTED_BIOMASS);
        }

        _leaf_last_demand_sum +=
            (*it)->get < double, leaf::LeafLastDemand >(
                t, phytomer::PhytomerModel::LEAF_LAST_DEMAND);
        _leaf_demand_sum += (*it)->get < double, leaf::LeafDemand >(
            t, phytomer::PhytomerModel::LEAF_DEMAND);
        _internode_last_demand_sum +=
            (*it)->get < double, internode::InternodeLastDemand >(
                t, phytomer::PhytomerModel::INTERNODE_LAST_DEMAND);
        _internode_demand_sum +=
            (*it)->get < double, internode::InternodeDemand >(
                t, phytomer::PhytomerModel::INTERNODE_DEMAND);
        _internode_biomass_sum += (*it)->get < double, internode::Biomass >(
            t, phytomer::PhytomerModel::INTERNODE_BIOMASS);
        _internode_len_sum += (*it)->get < double, internode::InternodeLen >(
            t, phytomer::PhytomerModel::INTERNODE_LEN);

        if ((*it)->get < double, leaf::BladeArea >(
                t, phytomer::PhytomerModel::LEAF_CORRECTED_BLADE_AREA) == 0) {
            _leaf_blade_area_sum +=
                (*it)->get < double, leaf::BladeArea >(
                    t, phytomer::PhytomerModel::LEAF_BLADE_AREA);
        } else {
            _leaf_blade_area_sum +=
                (*it)->get < double, leaf::BladeArea >(
                    t, phytomer::PhytomerModel::LEAF_CORRECTED_BLADE_AREA);
        }

        _realloc_biomass_sum +=
            (*it)->get < double, leaf::LeafBiomass >(
                t, phytomer::PhytomerModel::REALLOC_BIOMASS);
        _senesc_dw_sum +=
            (*it)->get < double, leaf::LeafBiomass >(
                t, phytomer::PhytomerModel::SENESC_DW);

        if (not (*it)->is_leaf_dead()) {
            if ((*it)->is_computed(t, phytomer::PhytomerModel::PREDIM)) {
                // if leaf state = lig
                if ((*it)->get < double, leaf::LeafLen >(
                        t, phytomer::PhytomerModel::LEAF_LEN) ==
                    (*it)->get < double, leaf::LeafPredim >(
                        t, phytomer::PhytomerModel::PREDIM)) {
                    ++_lig;

#ifdef WITH_TRACE
    utils::Trace::trace()
        << utils::TraceElement("CULM", t, artis::utils::COMPUTE)
        << "ADD LIG ; index = " << (*it)->get_index()
        << " ; lig = " << _lig
        << " ; deleted leaf number = " << _deleted_leaf_number;
    utils::Trace::trace().flush();
#endif

                }
                if (i == 0) {
                    _leaf_predim = (*it)->get < double, leaf::LeafPredim >(
                        t, phytomer::PhytomerModel::PREDIM);
                } else {
                    // if leaf state = lig
                    if ((*it)->get < double, leaf::LeafLen >(
                            t, phytomer::PhytomerModel::LEAF_LEN) ==
                        (*it)->get < double, leaf::LeafPredim >(
                            t, phytomer::PhytomerModel::PREDIM)) {
                        _leaf_predim = (*it)->get < double, leaf::LeafPredim >(
                            t, phytomer::PhytomerModel::PREDIM);
                    }
                }
            } else {
                ok = false;
            }
        }
        previous_it = it;
        ++it;
        ++i;
    }

    // if (is_ready(t, PLANT_DEFICIT) and is_ready(t, PLANT_STOCK)) {
    intermediate_model.put(t, culm::Intermediate::PLANT_DEFICIT,
                           _plant_deficit);
    intermediate_model.put(t, culm::Intermediate::PLANT_STOCK,
                           _plant_stock);
    // }
    if (_state == plant::ELONG and is_ready(t, PLANT_BIOMASS_SUM) and
        is_ready(t, ASSIM)) {
        max_reservoir_dispo_model.put(
            t, culm::MaxReservoirDispo::LEAF_BIOMASS_SUM,
            _leaf_biomass_sum);
        max_reservoir_dispo_model.put(
            t, culm::MaxReservoirDispo::INTERNODE_BIOMASS_SUM,
            _internode_biomass_sum);
        max_reservoir_dispo_model(t);

        supply_model.put(t, culm::CulmSupply::PLANT_LEAF_BIOMASS_SUM,
                         _plant_leaf_biomass_sum);
        supply_model.put(t, culm::CulmSupply::LEAF_BIOMASS_SUM,
                         _leaf_biomass_sum);
        supply_model.put(t, culm::CulmSupply::ASSIM, _assim);
        supply_model(t);
        intermediate_model.put(t, culm::Intermediate::SUPPLY,
                               supply_model.get < double >(
                                   t, culm::CulmSupply::SUPPLY));
        intermediate_model.put(t, culm::Intermediate::LEAF_BIOMASS_SUM,
                               _leaf_biomass_sum);
        intermediate_model.put(t, culm::Intermediate::INTERNODE_BIOMASS_SUM,
                               _internode_biomass_sum);
        intermediate_model.put(t, culm::Intermediate::PLANT_BIOMASS_SUM,
                               _plant_biomass_sum);
        intermediate_model.put(t, culm::Intermediate::LEAF_DEMAND_SUM,
                               _leaf_demand_sum);
        intermediate_model.put(t, culm::Intermediate::INTERNODE_DEMAND_SUM,
                               _internode_demand_sum);
        intermediate_model.put(t, culm::Intermediate::LEAF_LAST_DEMAND_SUM,
                               _leaf_last_demand_sum);
        intermediate_model.put(t,
                               culm::Intermediate::INTERNODE_LAST_DEMAND_SUM,
                               _internode_last_demand_sum);
        intermediate_model.put(t,
                               culm::Intermediate::REALLOC_BIOMASS_SUM,
                               _realloc_biomass_sum);
        intermediate_model(t);

        deficit_model.put < double >(
            t, culm::Deficit::INTERMEDIATE,
            intermediate_model.get < double >(
                t, culm::Intermediate::INTERMEDIATE));
        deficit_model(t);

        surplus_model.put(t, culm::CulmSurplus::PLANT_STATE, _state);
        surplus_model.put(t, culm::CulmSurplus::SUPPLY,
                          supply_model.get < double >(t, culm::CulmSupply::SUPPLY));
        surplus_model.put(t, culm::CulmSurplus::PLANT_STOCK,
                               _plant_stock);
        surplus_model.put(
            t, culm::CulmSurplus::MAX_RESERVOIR_DISPO,
            max_reservoir_dispo_model.get < double >(
                t, culm::MaxReservoirDispo::MAX_RESERVOIR_DISPO));
        surplus_model.put(t, culm::CulmSurplus::LEAF_DEMAND_SUM,
                          _leaf_demand_sum);
        surplus_model.put(t, culm::CulmSurplus::INTERNODE_DEMAND_SUM,
                          _internode_demand_sum);
        surplus_model.put(t, culm::CulmSurplus::LEAF_LAST_DEMAND_SUM,
                          _leaf_last_demand_sum);
        surplus_model.put(t,
                          culm::CulmSurplus::INTERNODE_LAST_DEMAND_SUM,
                          _internode_last_demand_sum);
        surplus_model.put(t,
                          culm::CulmSurplus::REALLOC_BIOMASS_SUM,
                          _realloc_biomass_sum);
        surplus_model(t);

        stock_model.put < double >(
            t, culm::CulmStock::MAX_RESERVOIR_DISPO,
            max_reservoir_dispo_model.get < double >(
                t, culm::MaxReservoirDispo::MAX_RESERVOIR_DISPO));
        stock_model.put < double >(
            t, culm::CulmStock::INTERMEDIATE,
            intermediate_model.get < double >(
                t, culm::Intermediate::INTERMEDIATE));
        stock_model(t);

        surplus_model.put(t, culm::CulmSurplus::STOCK,
                          stock_model.get < double >(t, culm::CulmStock::STOCK));
    } else {
        surplus_model.put(t, culm::CulmSurplus::PLANT_STOCK,
                               _plant_stock);
    }

    if (not ok) {
        _lig = old_lig;
    }

    _senesc_dw_sum += _deleted_senesc_dw;
    _deleted_senesc_dw_computed = false;

#ifdef WITH_TRACE
    utils::Trace::trace()
        << utils::TraceElement("CULM", t, artis::utils::COMPUTE)
        << "Predim = " << _leaf_predim
        << " ; index = " << _index
        << " ; assim = " << _assim
        << " ; stock = " << _plant_stock
        << " ; deficit = " << _plant_deficit
        << " ; lig = " << _lig
        << " ; leaf biomass sum = " << _leaf_biomass_sum
        << " ; leaf blade area sum = " << _leaf_blade_area_sum
        << " ; internode biomass sum = " << _internode_biomass_sum
        << " ; leaf number = "
        << (_deleted_leaf_number + phytomer_models.size())
        << " ; deleted leaf number = " << _deleted_leaf_number;
    utils::Trace::trace().flush();
#endif

}

void CulmModel::create_phytomer(double t)
{
    if (t != _first_day) {
        int index;

        if (phytomer_models.empty()) {
            index = 1;
        } else {
            index = phytomer_models.back()->get_index() + 1;
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM", t, artis::utils::COMPUTE)
            << "CREATE PHYTOMER: " << index
            << " ; index = " << _index;
        utils::Trace::trace().flush();
#endif

        phytomer::PhytomerModel* phytomer = new phytomer::PhytomerModel(index, _is_first_culm);

        setsubmodel(PHYTOMERS, phytomer);
        phytomer->init(t, *_parameters);
        phytomer_models.push_back(phytomer);
        compute(t, true);
    }
}

void CulmModel::delete_leaf(double t, int index)
{
    _deleted_senesc_dw =
        (1 - _parameters->get < double > ("realocationCoeff")) *
        get_leaf_biomass(t - 1, index);
    _deleted_senesc_dw_computed = true;

//    delete phytomer_models[index];
//    phytomer_models.erase(phytomer_models.begin() + index);

    phytomer_models[index]->delete_leaf(t);

    ++_deleted_leaf_number;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM", t, artis::utils::COMPUTE)
            << "DELETE LEAF: " << _index
            << " ; index = " << index
            << " ; nb = " << _deleted_leaf_number;
        utils::Trace::trace().flush();
#endif

}

double CulmModel::get_leaf_biomass(double t, int index) const
{
    double biomass = phytomer_models[index]->get < double, leaf::LeafBiomass >(
        t, phytomer::PhytomerModel::LEAF_BIOMASS);
    double corrected_biomass =
        phytomer_models[index]->get < double, leaf::LeafBiomass >(
            t, phytomer::PhytomerModel::LEAF_CORRECTED_BIOMASS);

    if (corrected_biomass > 0) {
        return corrected_biomass;
    } else {
        return biomass;
    }
}

double CulmModel::get_leaf_blade_area(double t, int index) const
{
    double blade_area = phytomer_models[index]->get < double, leaf::BladeArea >(
        t, phytomer::PhytomerModel::LEAF_BLADE_AREA);
    double corrected_blade_area =
        phytomer_models[index]->get < double, leaf::BladeArea >(
            t, phytomer::PhytomerModel::LEAF_CORRECTED_BLADE_AREA);

    if (corrected_blade_area > 0) {
        return corrected_blade_area;
    } else {
        return blade_area;
    }
}

double CulmModel::get_leaf_len(double t, int index) const
{
    return phytomer_models[index]->get < double, leaf::LeafLen >(
        t, phytomer::PhytomerModel::LEAF_LEN);
}

int CulmModel::get_first_ligulated_leaf_index(double t) const
{
    std::deque < phytomer::PhytomerModel* >::const_iterator it =
        phytomer_models.begin();
    int i = 0;

    while (it != phytomer_models.end()) {
        if (not (*it)->is_leaf_dead() and
            (*it)->get < double, leaf::LeafLen >(
                t, phytomer::PhytomerModel::LEAF_LEN) ==
            (*it)->get < double, leaf::LeafPredim >(t, phytomer::PhytomerModel::PREDIM)) {
            break;
        }
        ++it;
        ++i;
    }
    if (it != phytomer_models.end()) {
        return i;
    } else {
        return -1;
    }
}

int CulmModel::get_last_ligulated_leaf_index(double t) const
{
    std::deque < phytomer::PhytomerModel* >::const_iterator it =
        phytomer_models.begin();
    int i = 0;
    int index = -1;

    while (it != phytomer_models.end()) {
        if (not (*it)->is_leaf_dead() and
            (*it)->get < double, leaf::LeafLen >(
                t, phytomer::PhytomerModel::LEAF_LEN) ==
            (*it)->get < double, leaf::LeafPredim >(t, phytomer::PhytomerModel::PREDIM)) {
            index = i;
        }
        ++it;
        ++i;
    }
    return index;
}

int CulmModel::get_first_alive_leaf_index(double /* t */) const
{
    std::deque < phytomer::PhytomerModel* >::const_iterator it =
        phytomer_models.begin();
    int i = 0;
    int index = -1;

    while (it != phytomer_models.end()) {
        if (not (*it)->is_leaf_dead()) {
            index = i;
            break;
        }
        ++it;
        ++i;
    }
    return index;
}

} } // namespace ecomeristem culm

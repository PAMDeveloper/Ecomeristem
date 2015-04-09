/**
 * @file ecomeristem/culm/Model.hpp
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
#include <model/models/ecomeristem/phytomer/Model.hpp>
#include <utils/Trace.hpp>

#include <deque>

namespace ecomeristem { namespace culm {

class Model : public AbstractCoupledModel < Model >
{
public:
    enum internals { LEAF_BIOMASS_SUM, LEAF_LAST_DEMAND_SUM, LEAF_DEMAND_SUM,
                     INTERNODE_DEMAND_SUM, INTERNODE_LAST_DEMAND_SUM,
                     INTERNODE_BIOMASS_SUM,
                     LEAF_BLADE_AREA_SUM, LEAF_PREDIM,
                     REALLOC_BIOMASS_SUM, SENESC_DW_SUM, LIG };
    enum externals { DD, DELTA_T, FTSW, FCSTR, P, PHENO_STAGE,
                     PREDIM_LEAF_ON_MAINSTEM, SLA, GROW, PHASE, STATE,
                     STOP, TEST_IC };

    Model(int index);

    virtual ~Model()
    {
        std::deque < phytomer::Model* >::iterator it = phytomer_models.begin();

        while (it != phytomer_models.end()) {
            delete *it;
            ++it;
        }
    }

    void init(double t, const model::models::ModelParameters& parameters);
    bool is_stable(double t) const;
    void compute(double t, bool update);
    void create_phytomer(double t);
    void delete_leaf(int index);
    double get_leaf_biomass(double t, int index) const;

    int get_phytomer_number() const
    { return phytomer_models.size(); }

    int get_first_ligulated_leaf_index(double t) const;

private:
// parameters
    int _index;
    double _first_day;
    bool _is_first_culm;

    const model::models::ModelParameters* _parameters;

//submodels
    std::deque < phytomer::Model* > phytomer_models;

// internal
    double _leaf_biomass_sum;
    double _leaf_last_demand_sum;
    double _leaf_demand_sum;
    double _internode_last_demand_sum;
    double _internode_demand_sum;
    double _internode_biomass_sum;
    double _leaf_blade_area_sum;
    double _leaf_predim;
    double _realloc_biomass_sum;
    double _senesc_dw_sum;
    double _lig;
    double _deleted_leaf_number;

// external variables
    double _dd;
    double _delta_t;
    double _ftsw;
    double _fcstr;
    double _p;
    double _pheno_stage;
    double _predim_leaf_on_mainstem;
    double _sla;
    double _grow;
    double _phase;
    double _state;
    double _stop;
    double _test_ic;
};

} } // namespace ecomeristem culm

/**
 * @file ecomeristem/internode/Model.hpp
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

#include <model/models/ecomeristem/internode/TimeFromApp.hpp>
#include <model/models/ecomeristem/internode/Biomass.hpp>
#include <model/models/ecomeristem/internode/ExpTime.hpp>
#include <model/models/ecomeristem/internode/Len.hpp>
#include <model/models/ecomeristem/internode/DiameterPredim.hpp>
#include <model/models/ecomeristem/internode/Predim.hpp>
#include <model/models/ecomeristem/internode/Volume.hpp>
#include <model/models/ecomeristem/internode/LastDemand.hpp>
#include <model/models/ecomeristem/internode/INER.hpp>
#include <model/models/ecomeristem/internode/ReductionINER.hpp>
#include <model/models/ecomeristem/internode/InternodeDemand.hpp>
#include <model/models/ecomeristem/internode/Manager.hpp>

namespace ecomeristem { namespace internode {

class Model : public ecomeristem::AbstractCoupledModel < Model >
{
public:
    enum submodels { TIME_FROM_APP, BIOMASS_, EXP_TIME, LEN_, VOLUME, PREDIM,
                     DIAMETER_PREDIM, LAST_DEMAND_, INER, REDUCTION_INER,
                     DEMAND_, MANAGER };
    enum internals { BIOMASS, DEMAND, LAST_DEMAND, LEN };
    enum externals { DD, DELTA_T, FTSW, P, PHASE, STATE, PREDIM_LEAF,
                     LIG };

    Model(int index, bool is_on_mainstem);

    virtual ~Model()
    { }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */);

    void compute(double /* t */, bool /* update */);

private:
// parameters
    int _index;
    bool _is_first_internode;
    bool _is_on_mainstem;

// submodels
    TimeFromApp time_from_app_model;
    Biomass biomass_model;
    ExpTime exp_time_model;
    Len len_model;
    Volume volume_model;
    Predim predim_model;
    DiameterPredim diameter_predim_model;
    LastDemand last_demand_model;
    Iner iner_model;
    ReductionINER reduction_iner_model;
    InternodeDemand internode_demand_model;
    Manager manager_model;

// external variables
    double _dd;
    double _delta_t;
    double _ftsw;
    double _p;
    double _phase;
    double _state;
    double _test_ic;
    double _predim_leaf;
    double _lig;
};

} } // namespace ecomeristem internode

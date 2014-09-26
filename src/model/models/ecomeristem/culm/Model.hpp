/**
 * @file ecomeristem/culm/Model.hpp
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
#include <model/models/ecomeristem/phytomer/Model.hpp>

namespace ecomeristem { namespace culm {

class Model : public AbstractCoupledModel < Model >
{
public:
    enum externals { DD, DELTA_T, FTSW, FCSTR, P, PHENO_STAGE,
                     PREDIM_LEAF_ON_MAINSTEM, SLA, GROW, PHASE, STOP, TEST_IC };

    Model(bool is_first_culm) : _is_first_culm(is_first_culm)
    {
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
        external(STOP, &Model::_stop);
        external(TEST_IC, &Model::_test_ic);
    }

    virtual ~Model()
    { }

    void init(double t, const model::models::ModelParameters& parameters)
    {
        phytomer::Model* first_phytomer = new phytomer::Model(1,
                                                              _is_first_culm);

        first_phytomer->init(t, parameters);
        phytomer_models.push_back(first_phytomer);
    }

    void compute(double t)
    {
        std::vector < phytomer::Model* >::iterator it =
            phytomer_models.begin();

        while (it != phytomer_models.end()) {
            (*it)->put(t, phytomer::Model::DD, _dd);
            (*it)->put(t, phytomer::Model::DELTA_T, _delta_t);
            (*it)->put(t, phytomer::Model::FTSW, _ftsw);
            (*it)->put(t, phytomer::Model::FCSTR, _fcstr);
            (*it)->put(t, phytomer::Model::P, _p);
            (*it)->put(t, phytomer::Model::PHENO_STAGE, _pheno_stage);
            (*it)->put(t, phytomer::Model::PREDIM_LEAF_ON_MAINSTEM,
                _predim_leaf_on_mainstem);
            // TODO
            (*it)->put(t, phytomer::Model::PREDIM_PREVIOUS_LEAF, 0);
            (*it)->put(t, phytomer::Model::SLA, _sla);
            (*it)->put(t, phytomer::Model::GROW, _grow);
            (*it)->put(t, phytomer::Model::PHASE, _phase);
            (*it)->put(t, phytomer::Model::STOP, _stop);
            (*it)->put(t, phytomer::Model::TEST_IC, _test_ic);
            (*it)->compute(t);
            ++it;
        }
    }

private:
// parameters
    bool _is_first_culm;

//submodels
    std::vector < phytomer::Model* > phytomer_models;

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
    double _stop;
    double _test_ic;
};

} } // namespace ecomeristem culm

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
    Model()
    { }

    virtual ~Model()
    { }

    void init(double t, const model::models::ModelParameters& parameters)
    {
        phytomer::Model* first_phytomer = new phytomer::Model();

        first_phytomer->init(t, parameters);
        phytomer_models.push_back(first_phytomer);
    }

    void compute(double t)
    {
        std::vector < phytomer::Model* >::iterator it =
            phytomer_models.begin();

        while (it != phytomer_models.end()) {
            (*it)->compute(t);
            ++it;
        }
    }

private:
//submodels
    std::vector < phytomer::Model* > phytomer_models;
};

} } // namespace ecomeristem culm

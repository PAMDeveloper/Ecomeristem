/**
 * @file ecomeristem/phytomer/Model.hpp
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
#include <model/models/ecomeristem/internode/Model.hpp>
#include <model/models/ecomeristem/leaf/Model.hpp>

namespace ecomeristem { namespace phytomer {

class Model : public AbstractCoupledModel < Model >
{
public:
    Model()
    { }

    virtual ~Model()
    { }

    void init(double t, const model::models::ModelParameters& parameters)
    {
        internode_model.init(t, parameters);
        leaf_model.init(t, parameters);
    }

    void compute(double t)
    {
        internode_model.compute(t);
        leaf_model.compute(t);
    }

private:
    internode::Model internode_model;
    leaf::Model leaf_model;
};

} } // namespace ecomeristem phytomer

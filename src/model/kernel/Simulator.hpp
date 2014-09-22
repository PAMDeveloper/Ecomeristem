/**
 * @file model/kernel/Simulator.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS file
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

#ifndef MODEL_KERNEL_SIMULATOR_HPP
#define MODEL_KERNEL_SIMULATOR_HPP

#include <model/models/ModelParameters.hpp>
#include <model/observer/Observer.hpp>

namespace model { namespace kernel {

class Simulator
{
public:
    Simulator(model::kernel::Model* model)
        : model(model), observer(model)
    {
        model->build();
    }

    virtual ~Simulator()
    { delete model; }

    void init(const model::models::ModelParameters& parameters)
    {
        model->init(parameters);
        observer.init();
    }

    void run(double begin, double end);

private:
    model::kernel::Model* model;
    observer::Observer observer;
};

} } // namespace model kernel

#endif

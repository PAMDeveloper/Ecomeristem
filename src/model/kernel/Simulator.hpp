/**
 * @file model/kernel/Simulator.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS file
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

#ifndef MODEL_KERNEL_SIMULATOR_HPP
#define MODEL_KERNEL_SIMULATOR_HPP

#include <model/kernel/Model.hpp>
#include <model/kernel/AbstractCoupledModel.hpp>
#include <model/models/ModelParameters.hpp>

#include <artis/kernel/Simulator.hpp>

namespace model { namespace kernel {

typedef artis::kernel::Simulator < model::kernel::Model,
                                   artis::utils::DoubleTime,
                                   model::models::ModelParameters,
                                   ecomeristem::GlobalParameters > Simulator;

} } // namespace model kernel

#endif

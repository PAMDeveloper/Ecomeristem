/**
 * @file model/kernel/AbstractModel.hpp
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

#ifndef __ECOMERISTEM_ABSTRACT_MODEL_HPP
#define __ECOMERISTEM_ABSTRACT_MODEL_HPP

#include <model/models/ModelParameters.hpp>
#include <vector>

namespace ecomeristem {

class AbstractModel
{
public:
    AbstractModel()
    { }

    virtual ~AbstractModel()
    { }

    virtual void compute(double t) = 0;

    virtual double get(unsigned int index) const = 0;

    virtual void init(double t,
                      const model::models::ModelParameters& parameters) = 0;

    virtual void put(double t, unsigned int index, double value) = 0;
};

}

#endif

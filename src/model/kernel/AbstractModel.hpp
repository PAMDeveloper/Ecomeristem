/**
 * @file model/kernel/AbstractModel.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2015 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2015 ULCO http://www.univ-littoral.fr
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
    AbstractModel() : last_time(-1), updated(false)
    { }

    virtual ~AbstractModel()
    { }

    virtual bool check(double /* t */) const
    { return true; }

    virtual void operator()(double t)
    {
        if (check(t) and ((last_time != t) or (last_time == t and updated))) {
            compute(t, last_time == t);
            last_time = t;
            updated = false;
        }
    }

    virtual void compute(double t, bool update) = 0;

    virtual double get(double t, unsigned int index) const = 0;

    virtual void init(double t,
                      const model::models::ModelParameters& parameters) = 0;

    virtual bool is_computed(double t) const
    { return last_time == t; }

    virtual bool is_stable(double t) const = 0;

    virtual bool is_computed(double t, unsigned int index) const = 0;

protected:
    double last_time;
    std::vector < double > externalDates;
    bool updated;
};

}

#endif

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

#ifndef __ECOMERISTEM_ABSTRACT_ATOMIC_MODEL_HPP
#define __ECOMERISTEM_ABSTRACT_ATOMIC_MODEL_HPP

#include <model/kernel/AbstractModel.hpp>
#include <utils/Exception.hpp>

#include <vector>

namespace ecomeristem {

template < typename T >
class AbstractAtomicModel : public AbstractModel
{
public:
    AbstractAtomicModel()
    { }

    virtual ~AbstractAtomicModel()
    { }

    virtual void compute(double t, bool update) = 0;

    virtual double get(double t, unsigned int index) const
    {
        if (last_time != t) {
            throw utils::InvalidGet("Variable not computed");
        }
        return static_cast < const T* >(this)->*internals.at(index);
    }

    virtual void init(double t,
                      const model::models::ModelParameters& parameters) = 0;

    bool is_computed(double t, unsigned int /* index */) const
    { return last_time == t; }

    bool is_ready(double t, unsigned int index) const
    { return externalDates.at(index) == t; }

    bool is_stable(double t) const
    { return last_time == t; }

    void put(double t, unsigned int index, double value)
    {
        if (externalDates.at(index) != t) {
            static_cast < T* >(this)->*externals.at(index) = value;
            externalDates.at(index) = t;
            updated = true;
        } else {
            if (static_cast < T* >(this)->*externals.at(index) != value) {
                static_cast < T* >(this)->*externals.at(index) = value;
                updated = true;
            }
        }
    }

protected:
    void external(unsigned int index, double T::* var)
    {
        if (externals.size() <= index) {
            externals.resize(index + 1);
            externalDates.resize(index + 1);
        }
        externals[index] = var;
        externalDates[index] = -1;
    }

    void internal(unsigned int index, double T::* var)
    {
        if (internals.size() <= index) {
            internals.resize(index + 1);
        }
        internals[index] = var;
    }

private:
    std::vector < double T::* > internals;
    std::vector < double T::* > externals;
};

}

#endif

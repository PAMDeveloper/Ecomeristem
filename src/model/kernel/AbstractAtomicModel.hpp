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

#include <vector>

namespace ecomeristem {

template < typename T >
class AbstractAtomicModel : public AbstractModel
{
public:
    AbstractAtomicModel() : received(0)
    { }

    virtual ~AbstractAtomicModel()
    { }

    virtual double get(unsigned int index) const
    { return static_cast < const T* >(this)->*internals.at(index); }

    bool is_ready() const
    { return received == externals.size(); }

    bool is_ready(double t, unsigned int index) const
    { return externalDates.at(index) == t; }

    virtual void put(double t, unsigned int index, double value)
    {
        static_cast < T* >(this)->*externals.at(index) = value;
        externalDates.at(index) = t;
        ++received;
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
    std::vector < double T::* > externals;
    std::vector < double > externalDates;
    std::vector < double T::* > internals;
    unsigned int received;
};

}

#endif

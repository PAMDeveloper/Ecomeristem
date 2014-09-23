/**
 * @file model/kernel/AbstractCoupledModel.hpp
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

#ifndef __ECOMERISTEM_ABSTRACT_COUPLED_MODEL_HPP
#define __ECOMERISTEM_ABSTRACT_COUPLED_MODEL_HPP

#include <functional>
#include <vector>

#include <model/kernel/AbstractModel.hpp>

namespace ecomeristem {

template < typename T >
class AbstractCoupledModel : public AbstractModel
{
public:
    AbstractCoupledModel()
    { }

    virtual ~AbstractCoupledModel()
    { }

    virtual double get(unsigned int index) const
    {
        return internals.at(index).first->get(internals.at(index).second);
    }

    virtual void put(double /* t */, unsigned int index, double value)
    {
        static_cast < T* >(this)->*externals.at(index) = value;
    }

protected:
    void external(unsigned int index, double T::* var)
    {
        if (externals.size() <= index) {
            externals.resize(index + 1);
        }
        externals[index] = var;
    }

    void internal(unsigned int index, AbstractModel* model, int sub_index)
    {
        if (internals.size() <= index) {
            internals.resize(index + 1);
        }
        internals[index] =
            std::pair < AbstractModel*, int >(model, sub_index);
    }

private:
    std::vector < double T::* > externals;
    std::vector < std::pair < AbstractModel*, int > > internals;
};

}

#endif

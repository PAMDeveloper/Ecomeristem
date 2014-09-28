/**
 * @file model/kernel/AbstractCoupledModel.hpp
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

    virtual void compute(double t, bool update) = 0;

    virtual double get(double t, unsigned int index) const
    {
        std::map < int, std::pair < AbstractModel*,
                                    int > >::const_iterator it =
            sub_model_internals.find(index);

        if (it == sub_model_internals.end()) {
            return static_cast < const T* >(this)->*(
                internals.find(index)->second);
        } else {
            return it->second.first->get(t, it->second.second);
        }
    }

    virtual void init(double t,
                      const model::models::ModelParameters& parameters) = 0;

    bool is_computed(double t, unsigned int index) const
    {
        std::map < int, std::pair < AbstractModel*,
                                    int > >::const_iterator it =
            sub_model_internals.find(index);

        if (it == sub_model_internals.end()) {
            return false;
        } else {
            return it->second.first->is_computed(t, it->second.second);
        }
    }

    bool is_ready(double t, unsigned int index) const
    { return externalDates.at(index) == t; }

    bool is_stable(double t) const
    {
        std::map < int,
                   std::pair < AbstractModel*,
                               int > >::const_iterator it =
            sub_model_internals.begin();
        bool stable = true;

        while (it != sub_model_internals.end() and stable) {
            stable = it->second.first->is_stable(t);
            ++it;
        }
        return stable;
    }

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

    void internal(unsigned int index, AbstractModel* model, int sub_index)
    {
        sub_model_internals[index] =
            std::pair < AbstractModel*, int >(model, sub_index);
    }

    void internal(unsigned int index, double T::* var)
    {
        internals[index] = var;
    }

private:
    std::map < int, std::pair < AbstractModel*,
                                int > > sub_model_internals;
    std::map < int, double T::* > internals;
    std::vector < double T::* > externals;
};

}

#endif

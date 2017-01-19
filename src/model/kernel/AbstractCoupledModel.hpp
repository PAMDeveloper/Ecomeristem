/**
 * @file model/kernel/AbstractCoupledModel.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2017 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2017 ULCO http://www.univ-littoral.fr
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
// #include <typeinfo>
#include <vector>

#include <artis/kernel/AbstractCoupledModel.hpp>
#include <artis/utils/DateTime.hpp>

#include <model/kernel/AbstractModel.hpp>
#include <model/models/ModelParameters.hpp>

namespace ecomeristem {

struct GlobalParameters
{ };

template < typename T >
class AbstractCoupledModel : public artis::kernel::AbstractCoupledModel <
    T, artis::utils::DoubleTime, model::models::ModelParameters,
    GlobalParameters >
{
public:
    AbstractCoupledModel(const ecomeristem::AbstractModel* parent = 0) :
        artis::kernel::AbstractCoupledModel <
    T, artis::utils::DoubleTime, model::models::ModelParameters,
    GlobalParameters >(parent)
    { }

    virtual ~AbstractCoupledModel()
    { }

    virtual bool check(double /* t */) const
    {
        // *** code for debug
        // bool OK = true;
        // typename std::vector <
        //     std::pair < double,
        //                 double T::* > >::const_iterator it =
        //     artis::kernel::Externals <
        //     T, artis::utils::DoubleTime >::externalsD.begin();

        // while (it != artis::kernel::Externals < T,
        //        artis::utils::DoubleTime >::externalsD.end() and OK) {
        //     OK = it->first == t;
        //     ++it;
        // }
        // if (not OK) {
        //     std::cout << artis::utils::DateTime::toJulianDay(t)
        //               << " " << typeid(*this).name() << std::endl;
        // }
        return true;
    }

    virtual void operator()(double t)
    {
        artis::kernel::AbstractCoupledModel <
            T, artis::utils::DoubleTime, model::models::ModelParameters,
            GlobalParameters >::operator()(t);
    }
};

}

#endif

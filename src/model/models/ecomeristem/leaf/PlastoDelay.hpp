/**
 * @file leaf/PlastoDelay.hpp
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

#ifndef __ECOMERISTEM_LEAF_PLASTO_DELAY_HPP
#define __ECOMERISTEM_LEAF_PLASTO_DELAY_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace leaf {

class PlastoDelay : public AbstractAtomicModel < PlastoDelay >
{
public:
    // static const unsigned int TT_LIG = 0;

    // static const unsigned int EDD = 0;

    PlastoDelay()
    {
        // internal(TT_LIG, &TT_lig::_TT_lig);
        // external(EDD, &TT_lig::_EDD);
    }

    virtual ~PlastoDelay()
    { }

    void compute(double /* t */)
    {
    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
    }

    // void put(double t, unsigned int index, double value)
    // {
        // if (index == LIG and !is_ready(t, LIG)) {
        //     _lig_1 = _lig;
        // }
        // AbstractAtomicModel < TT_lig >::put(t, index, value);
    // }

private:
// internal variable
    // double _TT_lig;

// external variables
    // double _EDD;
};

} } // namespace ecomeristem leaf

#endif

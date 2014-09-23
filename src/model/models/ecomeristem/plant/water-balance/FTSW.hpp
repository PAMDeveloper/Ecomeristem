/**
 * @file plant/water-balance/FTSW.hpp
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

#ifndef __ECOMERISTEM_PLANT_WATER_BALANCE_FTSW_HPP
#define __ECOMERISTEM_PLANT_WATER_BALANCE_FTSW_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace water_balance {

class Ftsw : public AbstractAtomicModel < Ftsw >
{
public:
    static const unsigned int FTSW = 0;
    static const unsigned int SWC = 0;

    Ftsw()
    {
        internal(FTSW, &Ftsw::_ftsw);
        external(SWC, &Ftsw::_swc);
    }

    virtual ~Ftsw()
    { }

    void compute(double /* t */)
    { _ftsw = _swc_1 / RU1; }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        RU1 = parameters.get < double >("RU1");
        _ftsw = 0;
        _swc_1 = 0;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == SWC) {
            _swc_1 = _swc;
        }
        AbstractAtomicModel < Ftsw >::put(t, index, value);
    }

private:
    // parameters
    double RU1;

    // internal variable
    double _ftsw;

    // external variable
    double _swc;
    double _swc_1;
};

} } } // namespace ecomeristem plant water_balance

#endif

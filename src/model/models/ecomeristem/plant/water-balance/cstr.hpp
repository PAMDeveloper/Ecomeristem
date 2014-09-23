/**
 * @file plant/water-balance/cstr.hpp
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

#ifndef __ECOMERISTEM_PLANT_WATER_BALANCE_CSTR_HPP
#define __ECOMERISTEM_PLANT_WATER_BALANCE_CSTR_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace water_balance {

class cstr : public AbstractAtomicModel < cstr >
{
public:
    static const unsigned int CSTR = 0;
    static const unsigned int FTSW = 0;

    cstr()
    {
        internal(CSTR, &cstr::_cstr);
        external(FTSW, &cstr::_ftsw);
    }

    virtual ~cstr()
    { }

    void compute(double /* t */)
    { _cstr = (_ftsw < ThresTransp) ?
            std::max(1e-4, _ftsw * 1. / ThresTransp) : 1; }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        ThresTransp = parameters.get < double >("ThresTransp");
        _cstr = 0;
    }

private:
    // parameters
    double ThresTransp;

    // internal variable
    double _cstr;

    // external variable
    double _ftsw;
};

} } } // namespace ecomeristem plant water_balance

#endif

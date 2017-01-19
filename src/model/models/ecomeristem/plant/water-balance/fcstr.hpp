/**
 * @file plant/water-balance/Fcstr.hpp
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

#ifndef __ECOMERISTEM_PLANT_WATER_BALANCE_FCSTR_HPP
#define __ECOMERISTEM_PLANT_WATER_BALANCE_FCSTR_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace water_balance {

class Fcstr : public ecomeristem::AbstractAtomicModel < Fcstr >
{
public:
    enum internals { FCSTR };
    enum externals { CSTR };

    Fcstr()
    {
        internal(FCSTR, &Fcstr::_fcstr);
        external(CSTR, &Fcstr::_cstr);
    }

    virtual ~Fcstr()
    { }

    bool check(double t) const
    { return is_ready(t, CSTR); }

    void compute(double t, bool /* update */)
    {
        _fcstr = std::sqrt(_cstr);

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("FCSTR", t, artis::utils::COMPUTE)
            << "fcstr = " << _fcstr << " ; cstr = " << _cstr;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _fcstr = 0;
    }

private:
    // internal variable
    double _fcstr;

    // external variable
    double _cstr;
};

} } } // namespace ecomeristem plant water_balance

#endif

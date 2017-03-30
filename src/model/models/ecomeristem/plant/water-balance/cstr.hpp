/**
 * @file plant/water-balance/cstr.hpp
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

#ifndef __ECOMERISTEM_PLANT_WATER_BALANCE_CSTR_HPP
#define __ECOMERISTEM_PLANT_WATER_BALANCE_CSTR_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace water_balance {

class cstr : public ecomeristem::AbstractAtomicModel < cstr >
{
public:
    enum internals { CSTR };
    enum externals { FTSW };

    cstr()
    {
        internal(CSTR, &cstr::_cstr);
        external(FTSW, &cstr::_ftsw);
    }

    virtual ~cstr()
    { }

    bool check(double t) const
    { return is_ready(t, FTSW); }

    void compute(double t, bool /* update */)
    {
        _cstr = (_ftsw < ThresTransp) ?
            std::max(1e-4, _ftsw * 1. / ThresTransp) : 1;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CSTR", t, artis::utils::COMPUTE)
            << "cstr = " << _cstr << " ; FTSW = " << _ftsw
            << " ; ThresTransp = " << ThresTransp;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        ThresTransp = parameters.get < double >("thresTransp");
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

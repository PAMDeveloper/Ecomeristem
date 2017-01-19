/**
 * @file plant/water-balance/FTSW.hpp
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

#ifndef __ECOMERISTEM_PLANT_WATER_BALANCE_FTSW_HPP
#define __ECOMERISTEM_PLANT_WATER_BALANCE_FTSW_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace water_balance {

class Ftsw : public ecomeristem::AbstractAtomicModel < Ftsw >
{
public:
    enum internals { FTSW };
    enum externals { SWC };

    Ftsw()
    {
        internal(FTSW, &Ftsw::_ftsw);
        external(SWC, &Ftsw::_swc);
    }

    virtual ~Ftsw()
    { }

    virtual bool check(double /* t */) const
    { return true; }

    void compute(double t, bool /* update */)
    {
        _ftsw = _swc_1 / RU1;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("FTSW", t, artis::utils::COMPUTE)
            << "FTSW = " << _ftsw << " ; swc_1 = " << _swc_1
            << " ; swc = " << _swc << " ; RU1 = "
            << RU1;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        RU1 = parameters.get < double >("RU1");
        _ftsw = 0;
        _swc = RU1;
        _swc_1 = RU1;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == SWC and !is_ready(t, SWC)) {
            _swc_1 = _swc;
        }
        ecomeristem::AbstractAtomicModel < Ftsw >::put(t, index, value);
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

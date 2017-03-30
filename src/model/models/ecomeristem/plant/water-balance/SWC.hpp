/**
 * @file plant/water-balance/SWC.hpp
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

#ifndef __ECOMERISTEM_PLANT_WATER_BALANCE_SWC_HPP
#define __ECOMERISTEM_PLANT_WATER_BALANCE_SWC_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace water_balance {

class Swc : public ecomeristem::AbstractAtomicModel < Swc >
{
public:
    enum internals { SWC };
    enum externals { DELTA_P, WATER_SUPPLY };

    Swc()
    {
        internal(SWC, &Swc::_swc);

        external(DELTA_P, &Swc::_delta_p);
        external(WATER_SUPPLY, &Swc::_water_supply);
    }

    virtual ~Swc()
    { }

    bool check(double t) const
    { return is_ready(t, DELTA_P) and is_ready(t, WATER_SUPPLY); }

    void compute(double t, bool /* update */)
    {
        _swc = _swc - _delta_p + _water_supply;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("SWC", t, artis::utils::COMPUTE)
            << "swc = " << _swc << " ; delta_p = " << _delta_p
            << " ; water_supply = " << _water_supply << " ; RU1 = "
            << RU1;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        RU1 = parameters.get < double >("RU1");
        _swc = RU1;
    }

private:
    // parameters
    double RU1;

    // internal variable
    double _swc;

    // external variable
    double _delta_p;
    double _water_supply;
};

} } } // namespace ecomeristem plant water_balance

#endif

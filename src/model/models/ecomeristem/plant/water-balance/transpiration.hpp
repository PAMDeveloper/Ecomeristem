/**
 * @file plant/water-balance/transpiration.hpp
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

#ifndef __ECOMERISTEM_PLANT_WATER_BALANCE_TRANSPIRATION_HPP
#define __ECOMERISTEM_PLANT_WATER_BALANCE_TRANSPIRATION_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace water_balance {

class Transpiration : public ecomeristem::AbstractAtomicModel < Transpiration >
{
public:
    enum internals { TRANSPIRATION };
    enum externals { ETP, INTERC, SWC, CSTR };

    Transpiration()
    {
        internal(TRANSPIRATION, &Transpiration::_transpiration);
        external(ETP, &Transpiration::_etp);
        external(INTERC, &Transpiration::_interc);
        external(SWC, &Transpiration::_swc);
        external(CSTR, &Transpiration::_cstr);
    }

    virtual ~Transpiration()
    { }

    bool check(double t) const
    { return is_ready(t, ETP) and is_ready(t, INTERC) and is_ready(t, CSTR); }

    void compute(double t, bool /* update */)
    {
        _transpiration = std::min(_swc_1, (Kcpot * std::min(_etp, ETPmax) *
                                        _interc * _cstr) / density);

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("TRANSPIRATION", t, artis::utils::COMPUTE)
            << "transpiration = " << _transpiration << " ; SCW[-1] = "
            << _swc_1 << " ; SWC = " << _swc << " ; ETP = "
            << _etp << " ; Interc = " << _interc << " ; cstr = "
            << _cstr << " ; Kcpot = " << Kcpot << " ; ETPmax = " << ETPmax
            << " ; density = " << density;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        ETPmax = parameters.get < double >("ETPmax");
        Kcpot = parameters.get < double >("Kcpot");
        density = parameters.get < double >("density");
        _transpiration = 0;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == SWC and !is_ready(t, SWC)) {
            _swc_1 = _swc;
        }
        ecomeristem::AbstractAtomicModel < Transpiration >::put(t, index,
                                                                value);
    }

private:
    // parameters
    double ETPmax;
    double Kcpot;
    double density;

    // internal variable
    double _transpiration;

    // external variable
    double _etp;
    double _interc;
    double _swc;
    double _swc_1;
    double _cstr;
};

} } } // namespace ecomeristem plant water_balance

#endif

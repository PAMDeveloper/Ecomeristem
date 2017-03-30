/**
 * @file thermal-time/IH.hpp
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_IH_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_IH_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/thermal-time/ThermalTimeManager.hpp>
#include <utils/DateTime.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class Ih : public ecomeristem::AbstractAtomicModel < Ih >
{
public:
    static const unsigned int IH = 0;
    static const unsigned int LIG = 0;
    static const unsigned int TT_LIG = 1;
    static const unsigned int PHASE = 2;
    static const unsigned int LIGULO_VISU = 3;

    Ih()
    {
        internal(IH, &Ih::_IH);
        external(LIG, &Ih::_lig);
        external(TT_LIG, &Ih::_TT_lig);
        external(PHASE, &Ih::_phase);
        external(LIGULO_VISU, &Ih::_ligulo_visu);
    }

    virtual ~Ih()
    { }

    bool check(double t) const
    { return is_ready(t, LIG) and is_ready(t, TT_LIG); }

    void compute(double t, bool update)
    {
        if (not update or (update and _previous_phase == _phase)) {
            _previous_phase = _phase;
            if (_phase == ThermalTimeManager::STOCK_AVAILABLE) {
                _IH = _lig + std::min(1., _TT_lig / _ligulo_visu);
            }
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("IH", t, artis::utils::COMPUTE)
            << "IH = " << _IH
            << " ; phase = " << _phase
            << " ; lig = " << _lig
            << " ; TT_lig = " << _TT_lig
            << " ; ligulo = " << _ligulo;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _coef_ligulo = parameters.get < double >("coef_ligulo1");
        _plasto = parameters.get < double >("plasto_init");
        _ligulo = _plasto * _coef_ligulo;
        _IH = 0;
    }

private:
// parameters
    double _coef_ligulo;
    double _plasto;

// internal variable
    double _IH;
    double _ligulo;
    double _previous_phase;

// external variables
    double _lig;
    double _TT_lig;
    double _phase;
    double _ligulo_visu;
};

} } } // namespace ecomeristem plant thermal_time

#endif

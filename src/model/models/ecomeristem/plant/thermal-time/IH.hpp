/**
 * @file thermal-time/IH.hpp
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_IH_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_IH_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/thermal-time/ThermalTimeManager.hpp>
#include <utils/DateTime.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class Ih : public AbstractAtomicModel < Ih >
{
public:
    static const unsigned int IH = 0;
    static const unsigned int LIG = 0;
    static const unsigned int TT_LIG = 1;
    static const unsigned int PHASE = 2;

    Ih()
    {
        internal(IH, &Ih::_IH);
        external(LIG, &Ih::_lig);
        external(TT_LIG, &Ih::_TT_lig);
        external(PHASE, &Ih::_phase);
    }

    virtual ~Ih()
    { }

    void compute(double /* t */, bool /* update */)
    {
        if (_phase == ThermalTimeManager::STOCK_AVAILABLE) {
            _IH = _lig + std::min(1., _TT_lig / _ligulo);
        }

        // std::cout << utils::DateTime::toJulianDay(t)
        //           << " - IH: " << _IH << " " << _lig << " " << _TT_lig
        //           << " " << _ligulo << std::endl;

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

// external variables
    double _lig;
    double _TT_lig;
    double _phase;
};

} } } // namespace ecomeristem plant thermal_time

#endif

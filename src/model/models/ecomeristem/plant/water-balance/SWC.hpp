/**
 * @file plant/water-balance/SWC.hpp
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

#ifndef __ECOMERISTEM_PLANT_WATER_BALANCE_SWC_HPP
#define __ECOMERISTEM_PLANT_WATER_BALANCE_SWC_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace water_balance {

class Swc : public AbstractAtomicModel < Swc >
{
public:
    static const unsigned int SWC = 0;
    static const unsigned int DELTA_P = 0;
    static const unsigned int WATER_SUPPLY = 1;

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

    void compute(double /* t */, bool /* update */)
    {
        _swc = _swc - _delta_p + _water_supply;

        std::cout << "SWC: " << _swc << " " << _delta_p << " "
                  << _water_supply << " " << RU1 << std::endl;
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

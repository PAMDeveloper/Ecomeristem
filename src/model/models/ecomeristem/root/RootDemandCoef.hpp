/**
 * @file root/RootDemandCoef.hpp
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

#ifndef __ECOMERISTEM_ROOT_ROOT_DEMAND_COEF_HPP
#define __ECOMERISTEM_ROOT_ROOT_DEMAND_COEF_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace root {

class RootDemandCoef : public ecomeristem::AbstractAtomicModel < RootDemandCoef >
{
public:
    static const unsigned int ROOT_DEMAND_COEF = 0;
    static const unsigned int P = 0;

    RootDemandCoef()
    {
        internal(ROOT_DEMAND_COEF, &RootDemandCoef::_rootDemandCoef);
        external(P, &RootDemandCoef::_P);
    }

    virtual ~RootDemandCoef()
    { }

    bool check(double t) const
    { return is_ready(t, P); }

    void compute(double /* t */, bool /* update */)
    {
        ++_day;
        _rootDemandCoef = _coeff1_R_d * std::exp(_coeff2_R_d * _day) *
            (_P * _resp_R_d + 1);
    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _coeff1_R_d = parameters.get < double >("coeff1_R_d");
        _coeff2_R_d = parameters.get < double >("coeff2_R_d");
        _resp_R_d = parameters.get < double >("resp_R_d");
        _rootDemandCoef = 0;
        _day = 0;
    }

private:
// parameters
    double _coeff1_R_d;
    double _coeff2_R_d;
    double _resp_R_d;

// internal variable
    double _rootDemandCoef;
    double _day;

// external variables
    double _P;
};

} } // namespace ecomeristem root

#endif

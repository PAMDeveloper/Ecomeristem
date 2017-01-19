/**
 * @file leaf/PlastoDelay.hpp
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

#ifndef __ECOMERISTEM_LEAF_PLASTO_DELAY_HPP
#define __ECOMERISTEM_LEAF_PLASTO_DELAY_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace leaf {

class PlastoDelay : public ecomeristem::AbstractAtomicModel < PlastoDelay >
{
public:
    enum internals { PLASTO_DELAY };
    enum externals { DELTA_T, EXP_TIME, REDUCTION_LER };

    PlastoDelay()
    {
        internal(PLASTO_DELAY, &PlastoDelay::_plasto_delay);
        external(DELTA_T, &PlastoDelay::_delta_t);
        external(EXP_TIME, &PlastoDelay::_exp_time);
        external(REDUCTION_LER, &PlastoDelay::_reduction_ler);
    }

    virtual ~PlastoDelay()
    { }

    virtual bool check(double t) const
    {
        return is_ready(t, DELTA_T) and is_ready(t, EXP_TIME) and
            is_ready(t, REDUCTION_LER);
    }

    void compute(double /* t */, bool /* update */)
    {
        _plasto_delay = std::min(((_delta_t > _exp_time) ? _exp_time :
                                  _delta_t) * (-1. + _reduction_ler), 0.);
    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _plasto_delay = 0;
    }

private:
// internal variable
    double _plasto_delay;

// external variables
    double _delta_t;
    double _exp_time;
    double _reduction_ler;
};

} } // namespace ecomeristem leaf

#endif

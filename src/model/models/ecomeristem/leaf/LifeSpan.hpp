/**
 * @file leaf/LifeSpan.hpp
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

#ifndef __ECOMERISTEM_LEAF_LIFE_SPAN_HPP
#define __ECOMERISTEM_LEAF_LIFE_SPAN_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace leaf {

class LifeSpan : public ecomeristem::AbstractAtomicModel < LifeSpan >
{
public:
    enum internals { LIFE_SPAN };
    enum externals { };

    LifeSpan(int index) : _index(index)
    {
        internal(LIFE_SPAN, &LifeSpan::_life_span);
    }

    virtual ~LifeSpan()
    { }

    void compute(double t, bool /* update */)
    {
        if (t == _first_day) {
            _life_span = _coeffLifespan * std::exp(_mu * _index);
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LIFE_SPAN", t, artis::utils::COMPUTE)
            << "LifeSpan = " << _life_span
            << " ; mu = " << _mu
            << " ; coeffLifespan = " << _coeffLifespan
            << " ; index = " << _index;
        utils::Trace::trace().flush();
#endif

    }

    void init(double t,
              const model::models::ModelParameters& parameters)
    {
        _coeffLifespan = parameters.get < double >("coeff_lifespan");
        _mu = parameters.get < double >("mu");
        _first_day = t;
        _life_span = 0;
    }

private:
// parameters
    double _coeffLifespan;
    double _mu;

// internal variable
    double _life_span;
    int _index;
    double _first_day;
};

} } // namespace ecomeristem leaf

#endif

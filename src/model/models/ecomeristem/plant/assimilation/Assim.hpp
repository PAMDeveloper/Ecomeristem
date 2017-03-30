/**
 * @file assimilation/Assim.hpp
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

#ifndef __ECOMERISTEM_PLANT_ASSIMILATION_ASSIM_HPP
#define __ECOMERISTEM_PLANT_ASSIMILATION_ASSIM_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace assimilation {

class Assim : public ecomeristem::AbstractAtomicModel < Assim >
{
public:
    enum internals { ASSIM };
    enum externals { RESP_MAINT, ASSIM_POT };

    Assim() : _assim(0)
    {
        internal(ASSIM, &Assim::_assim);

        external(RESP_MAINT, &Assim::_resp_maint);
        external(ASSIM_POT, &Assim::_assim_pot);
    }

    virtual ~Assim()
    { }

    bool check(double t) const
    { return is_ready(t, RESP_MAINT) and is_ready(t, ASSIM_POT); }

    void compute(double t, bool /* update */)
    {
        _assim = std::max(0., _assim_pot / _density - _resp_maint);

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("ASSIM", t, artis::utils::COMPUTE)
            << "assim = " << _assim << " ; assim_pot = " << _assim_pot
            << " ; resp_maint = " << _resp_maint << " ; density = "
            << _density;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _density = parameters.get < double >("density");
        _assim = 0;
    }

private:
// parameters
    double _density;

// internal variable
    double _assim;

// external variables
    double _resp_maint;
    double _assim_pot;
};

} } } // namespace ecomeristem plant assimilation

#endif

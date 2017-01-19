/**
 * @file ecomeristem/culm/Deficit.hpp
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

#ifndef __ECOMERISTEM_CULM_DEFICIT_HPP
#define __ECOMERISTEM_CULM_DEFICIT_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace culm {

class Deficit : public ecomeristem::AbstractAtomicModel < Deficit >
{
public:
    enum internals { DEFICIT };
    enum externals { INTERMEDIATE };

    Deficit()
    {
        internal(DEFICIT, &Deficit::_deficit);

        external(INTERMEDIATE, &Deficit::_intermediate);
    }

    virtual ~Deficit()
    { }

    void compute(double t, bool /* update */)
    {
        _deficit = std::min(0., _intermediate);

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM_DEFICIT", t, artis::utils::COMPUTE)
            << "Deficit = " << _deficit
            << " ; Intermediate = " << _intermediate;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _deficit = 0;
    }

private:
// internal variables
     double _deficit;

// // external variables
    double _intermediate;
};

} } // namespace ecomeristem culm

#endif

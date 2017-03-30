/**
 * @file leaf/Width.hpp
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

#ifndef __ECOMERISTEM_LEAF_WIDTH_HPP
#define __ECOMERISTEM_LEAF_WIDTH_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

class Width : public ecomeristem::AbstractAtomicModel < Width >
{
public:
    enum internals { WIDTH };
    enum externals { LEN };

    Width()
    {
        internal(WIDTH, &Width::_width);
        external(LEN, &Width::_len);
    }

    virtual ~Width()
    { }

    void compute(double t, bool /* update */)
    {
        _width = _len * _WLR / _LL_BL;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_WIDTH", t, artis::utils::COMPUTE)
            << "Width = " << _width
            << " ; len = " << _len
            << " ; WLR = " << _WLR
            << " ; LL_BL = " << _LL_BL;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _WLR = parameters.get < double >("WLR");
        _LL_BL = parameters.get < double >("LL_BL_init");
        _width = 0;
    }

private:
// parameters
    double _WLR;
    double _LL_BL;

// internal variable
    double _width;

// external variables
    double _len;
};

} } // namespace ecomeristem leaf

#endif

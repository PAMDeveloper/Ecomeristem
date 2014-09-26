/**
 * @file leaf/BladeArea.hpp
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

#ifndef __ECOMERISTEM_LEAF_BLADE_AREA_HPP
#define __ECOMERISTEM_LEAF_BLADE_AREA_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace leaf {

class BladeArea : public AbstractAtomicModel < BladeArea >
{
public:
    enum internals { BLADE_AREA };
    enum externals { LEN, WIDTH };

    BladeArea()
    {
        internal(BLADE_AREA, &BladeArea::_blade_area);
        external(LEN, &BladeArea::_len);
        external(WIDTH, &BladeArea::_width);
    }

    virtual ~BladeArea()
    { }

    void compute(double /* t */)
    {
        _blade_area = _len * _width * _allo_area / _LL_BL;
    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _allo_area = parameters.get < double >("allo_area");
        _LL_BL = parameters.get < double >("LL_BL_init");
        _width = 0;
    }

private:
// parameters
    double _allo_area;
    double _LL_BL;

// internal variable
    double _blade_area;

// external variables
    double _len;
    double _width;
};

} } // namespace ecomeristem leaf

#endif

/**
 * @file leaf/BladeArea.hpp
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

#ifndef __ECOMERISTEM_LEAF_BLADE_AREA_HPP
#define __ECOMERISTEM_LEAF_BLADE_AREA_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

class BladeArea : public ecomeristem::AbstractAtomicModel < BladeArea >
{
public:
    enum internals { BLADE_AREA, CORRECTED_BLADE_AREA };
    enum externals { LEN, WIDTH, PHASE, LIFE_SPAN, TT };

    BladeArea(int index) : _index(index)
    {
        internal(BLADE_AREA, &BladeArea::_blade_area);
        internal(CORRECTED_BLADE_AREA, &BladeArea::_corrected_blade_area);

        external(LEN, &BladeArea::_len);
        external(WIDTH, &BladeArea::_width);
        external(PHASE, &BladeArea::_phase);
        external(LIFE_SPAN, &BladeArea::_life_span);
        external(TT, &BladeArea::_TT);
    }

    virtual ~BladeArea()
    { }

    void compute(double t, bool update)
    {
        if (update) {
            _lig = _lig_1;
        }
        _blade_area = _len * _width * _allo_area / _LL_BL;
        if (not update) {
            _lig_1 = _lig;
        }
        if (not _lig) {
            _corrected_blade_area = 0;
            _lig = _phase == leaf::LIG;
        } else {
            if (_blade_area < 0) {
                _blade_area = 0;
            }
            _corrected_blade_area = _blade_area * (1 - _TT / _life_span);
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_BLADE_AREA", t, artis::utils::COMPUTE)
            << "BladeArea = " << _blade_area
            << " ; correctedBladeArea = " << _corrected_blade_area
            << " ; index = " << _index
            << " ; Len = " << _len
            << " ; Width = " << _width
            << " ; allo_area = " << _allo_area
            << " ; LL_BL = " << _LL_BL
            << " ; TT = " << _TT
            << " ; lig = " << _lig
            << " ; life_span = " << _life_span;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _allo_area = parameters.get < double >("allo_area");
        _LL_BL = parameters.get < double >("LL_BL_init");
        _width = 0;
        _phase = leaf::INITIAL;
        _lig = false;
        _lig_1 = false;
        _corrected_blade_area = 0;
    }

    double get_blade_area() const
    { return _blade_area; }

private:
// parameters
    double _allo_area;
    double _LL_BL;

// internal variable
    double _blade_area;
    double _blade_area_1;
    double _corrected_blade_area;
    bool _lig;
    bool _lig_1;
    int _index;

// external variables
    double _len;
    double _width;
    double _phase;
    double _life_span;
    double _TT;
};

} } // namespace ecomeristem leaf

#endif

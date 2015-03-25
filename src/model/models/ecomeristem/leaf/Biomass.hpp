/**
 * @file leaf/Biomass.hpp
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

#ifndef __ECOMERISTEM_LEAF_BIOMASS_HPP
#define __ECOMERISTEM_LEAF_BIOMASS_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/Manager.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

class Biomass : public AbstractAtomicModel < Biomass >
{
public:
    enum internals { BIOMASS, REALLOC_BIOMASS, SENESC_DW, CORRECTED_BIOMASS };
    enum externals { BLADE_AREA, SLA, GROW, PHASE, TT, LIFE_SPAN,
                     CORRECTED_BLADE_AREA };

    Biomass(int index) : _index(index)
    {
        internal(BIOMASS, &Biomass::_biomass);
        internal(REALLOC_BIOMASS, &Biomass::_realloc_biomass);
        internal(SENESC_DW, &Biomass::_senesc_dw);
        internal(CORRECTED_BIOMASS, &Biomass::_corrected_biomass);

        external(BLADE_AREA, &Biomass::_blade_area);
        external(SLA, &Biomass::_sla);
        external(GROW, &Biomass::_grow);
        external(PHASE, &Biomass::_phase);
        external(TT, &Biomass::_TT);
        external(LIFE_SPAN, &Biomass::_life_span);
        external(CORRECTED_BLADE_AREA, &Biomass::_corrected_blade_area);
    }

    virtual ~Biomass()
    { }

    void compute(double t, bool update)
    {
        double _old_biomass = 0;

        if (not update) {
            _stop = false;
        }
        if (_first_day == t) {
            _biomass = (1. / _G_L) * _blade_area / _sla;
            _corrected_biomass = 0;
            _realloc_biomass = 0;
            _sla_cste = _sla;
            _old_biomass = _biomass;
        } else {
            if (_phase != plant::NOGROWTH and _phase != plant::NOGROWTH3
                and _phase != plant::NOGROWTH4 and not _stop) {
                if (not _lig) {
                    _lig = _phase == plant::LIG;
                    _biomass = (1. / _G_L) * _blade_area / _sla_cste;
                    _corrected_biomass = 0;
                    _realloc_biomass = 0;
                    _old_biomass = _biomass;
                } else {
                    if (not update) {
                        if (_corrected_biomass > 0) {
                            _old_biomass = _corrected_biomass;
                        } else {
                            _old_biomass = _biomass;
                        }
                    }
                    // _corrected_biomass = _biomass - _blade_area *
                    //     (1 + _G_L) * (_TT / _life_span) / _sla_cste;
                    _corrected_biomass = _biomass * (1. - _TT / _life_span);
                    _realloc_biomass = (_old_biomass - _corrected_biomass) *
                        _realocationCoeff;
                    _senesc_dw = (_old_biomass - _corrected_biomass) *
                        (1 - _realocationCoeff);
                }
                _stop = _phase == plant::NOGROWTH4;
            }
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_BIOMASS", t, utils::COMPUTE)
            << "Biomass = " << _biomass
            << " ; correctedBiomass = " << _corrected_biomass
            << " ; index = " << _index
            << " ; phase = " << _phase
            << " ; BladeArea = " << _blade_area
            << " ; SLA = " << _sla_cste
            << " ; G_L = " << _G_L
            << " ; TT = " << _TT
            << " ; life_span = " << _life_span
            << " ; old_biomass = " << _old_biomass
            << " ; realloc_biomass = " << _realloc_biomass
            << " ; senesc_dw = " << _senesc_dw
            << " ; lig = " << _lig;
        utils::Trace::trace().flush();
#endif

    }

    void init(double t,
              const model::models::ModelParameters& parameters)
    {
        _G_L = parameters.get < double >("G_L");
        _realocationCoeff = parameters.get < double >("realocationCoeff");
        _first_day = t;
        _lig = false;
        _biomass = 0;
        _corrected_biomass = 0;
    }

private:
// parameters
    double _G_L;
    double _realocationCoeff;

// internal variable
    double _biomass;
    double _corrected_biomass;
    double _realloc_biomass;
    double _senesc_dw;
    double _first_day;
    bool _lig;
    int _index;
    bool _stop;

// external variables
    double _blade_area;
    double _corrected_blade_area;
    double _sla;
    double _sla_cste;
    double _grow;
    double _phase;
    double _life_span;
    double _TT;
};

} } // namespace ecomeristem leaf

#endif

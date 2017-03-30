/**
 * @file leaf/Biomass.hpp
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

#ifndef __ECOMERISTEM_LEAF_BIOMASS_HPP
#define __ECOMERISTEM_LEAF_BIOMASS_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

class LeafBiomass : public ecomeristem::AbstractAtomicModel < LeafBiomass >
{
public:
    enum internals { BIOMASS, REALLOC_BIOMASS, SENESC_DW, SENESC_DW_SUM,
                     CORRECTED_BIOMASS };
    enum externals { BLADE_AREA, SLA, GROW, PHASE, TT, LIFE_SPAN,
                     CORRECTED_BLADE_AREA };

    LeafBiomass(int index) : _index(index)
    {
        internal(BIOMASS, &LeafBiomass::_biomass);
        internal(REALLOC_BIOMASS, &LeafBiomass::_realloc_biomass);
        internal(SENESC_DW, &LeafBiomass::_senesc_dw);
        internal(SENESC_DW_SUM, &LeafBiomass::_senesc_dw_sum);
        internal(CORRECTED_BIOMASS, &LeafBiomass::_corrected_biomass);

        external(BLADE_AREA, &LeafBiomass::_blade_area);
        external(SLA, &LeafBiomass::_sla);
        external(GROW, &LeafBiomass::_grow);
        external(PHASE, &LeafBiomass::_phase);
        external(TT, &LeafBiomass::_TT);
        external(LIFE_SPAN, &LeafBiomass::_life_span);
        external(CORRECTED_BLADE_AREA, &LeafBiomass::_corrected_blade_area);
    }

    virtual ~LeafBiomass()
    { }

    void compute(double t, bool update)
    {
        if (not update) {
            _stop = false;
            _old_biomass = 0;
        } else {
            _lig = _lig_1;
            if (not _lig) {
                _biomass = _biomass_1;
                _corrected_biomass = _corrected_biomass_1;
                _realloc_biomass = _realloc_biomass_1;
                _old_biomass = _old_biomass_1;
            }
        }
        if (_first_day == t) {
            _biomass = (1. / _G_L) * _blade_area / _sla;
            _corrected_biomass = 0;
            _realloc_biomass = 0;
            _sla_cste = _sla;
            _old_biomass = _biomass;
        } else {
            if (not update) {
                _lig_1 = _lig;
                _biomass_1 = _biomass;
                _corrected_biomass_1 = _corrected_biomass;
                _realloc_biomass_1 = _realloc_biomass;
                _old_biomass_1 = _old_biomass;
                _senesc_dw_sum_1 = _senesc_dw_sum;
            }
            if (_phase != leaf::NOGROWTH and not _stop) {
                if (not _lig) {
                    _lig = _phase == leaf::LIG;
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
                    _corrected_biomass = _biomass * (1. - _TT / _life_span);
                    _realloc_biomass = (_old_biomass - _corrected_biomass) *
                        _realocationCoeff;
                    _senesc_dw = (_old_biomass - _corrected_biomass) *
                        (1 - _realocationCoeff);
                    _senesc_dw_sum = _senesc_dw_sum_1 + _senesc_dw;
                }
                _stop = _phase == leaf::NOGROWTH;
            } else {
                _biomass = _biomass_1;
            }
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_BIOMASS", t, artis::utils::COMPUTE)
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
            << " ; senesc_dw_sum = " << _senesc_dw_sum
            << " ; lig = " << _lig
            << " ; lig[-1] = " << _lig_1
            << " ; update = " << update
            << " ; stop = " << _stop;
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
        _lig_1 = false;
        _biomass = 0;
        _biomass_1 = 0;
        _corrected_biomass = 0;
        _corrected_biomass_1 = 0;
        _senesc_dw = 0;
        _senesc_dw_sum = 0;
        _senesc_dw_sum_1 = 0;
    }

private:
// parameters
    double _G_L;
    double _realocationCoeff;

// internal variable
    double _biomass;
    double _biomass_1;
    double _corrected_biomass;
    double _corrected_biomass_1;
    double _realloc_biomass;
    double _realloc_biomass_1;
    double _old_biomass;
    double _old_biomass_1;
    double _senesc_dw;
    double _senesc_dw_sum;
    double _senesc_dw_sum_1;
    double _first_day;
    bool _lig;
    bool _lig_1;
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

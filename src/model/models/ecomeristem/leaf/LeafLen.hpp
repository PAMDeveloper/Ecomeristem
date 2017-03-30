/**
 * @file leaf/Len.hpp
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

#ifndef __ECOMERISTEM_LEAF_LEN_HPP
#define __ECOMERISTEM_LEAF_LEN_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/leaf/LeafManager.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

class LeafLen : public ecomeristem::AbstractAtomicModel < LeafLen >
{
public:
    enum internals { LEN };
    enum externals { DD, DELTA_T, GROW, PHASE, LER, EXP_TIME, PREDIM };

    LeafLen(int index) : _index(index)
    {
        internal(LEN, &LeafLen::_len);
        external(DD, &LeafLen::_dd);
        external(DELTA_T, &LeafLen::_delta_t);
        external(GROW, &LeafLen::_grow);
        external(PHASE, &LeafLen::_phase);
        external(LER, &LeafLen::_ler);
        external(EXP_TIME, &LeafLen::_exp_time);
        external(PREDIM, &LeafLen::_predim);
    }

    virtual ~LeafLen()
    { }

    void compute(double t, bool update)
    {
        if (not update) {
            _stop = false;
        } else {
            _len = _len_1;
        }
        if (_first_day == t) {
            _len = _ler * _dd;
        } else {
            if (not update) {
                _len_1 = _len;
            }
            if (not (_phase == plant::NOGROWTH or _phase == plant::NOGROWTH3
                or _phase == plant::NOGROWTH4) and not _stop) {
                _len = std::min(_predim,
                                _len_1 + _ler * std::min(_delta_t, _exp_time));
            }
            _stop = _phase == plant::NOGROWTH or _phase == plant::NOGROWTH3 or
                _phase == plant::NOGROWTH4;
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_LEN", t, artis::utils::COMPUTE)
            << "Len = " << _len
            << " ; index = " << _index
            << " ; len[-1] = " << _len_1
            << " ; phase = " << _phase
            << " ; phase[-1] = " << _phase_1
            << " ; DeltaT = " << _delta_t
            << " ; ExpTime = " << _exp_time
            << " ; LER = " << _ler
            << " ; DD = " << _dd
            << " ; update = " << update
            << " ; first_day = " << (_first_day == t);
        utils::Trace::trace().flush();
#endif

    }

    void init(double t,
              const model::models::ModelParameters& /* parameters */)
    {
        _len = 0;
        _len_1 = 0;
        _first_day = t;
        _stop = false;
        _phase = plant::INITIAL;
        _phase_1 = plant::INITIAL;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == PHASE and !is_ready(t, PHASE)) {
            _phase_1 = _phase;
        }

        ecomeristem::AbstractAtomicModel < LeafLen >::put(t, index, value);
    }

private:
// parameters
    int _index;

// internal variable
    double _len;
    double _len_1;
    double _first_day;
    bool _stop;

// external variables
    double _dd;
    double _delta_t;
    double _grow;
    double _phase;
    double _phase_1;
    double _ler;
    double _exp_time;
    double _predim;
};

} } // namespace ecomeristem leaf

#endif

/**
 * @file internode/Len.hpp
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

#ifndef __ECOMERISTEM_INTERNODE_LEN_HPP
#define __ECOMERISTEM_INTERNODE_LEN_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/internode/Manager.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace internode {

class InternodeLen : public ecomeristem::AbstractAtomicModel < InternodeLen >
{
public:
    enum internals { LEN };
    enum externals { DD, DELTA_T, PHASE, INER, EXP_TIME, PREDIM };

    InternodeLen(int index) : _index(index)
    {
        internal(LEN, &InternodeLen::_len);

        external(DD, &InternodeLen::_dd);
        external(DELTA_T, &InternodeLen::_delta_t);
        external(PHASE, &InternodeLen::_phase);
        external(INER, &InternodeLen::_iner);
        external(EXP_TIME, &InternodeLen::_exp_time);
        external(PREDIM, &InternodeLen::_predim);
    }

    virtual ~InternodeLen()
    { }

    bool check(double t) const
    {
        if (_phase == internode::VEGETATIVE) {
            return true;
        } else {
            if (_phase_1 == internode::VEGETATIVE and
                _phase == internode::REALIZATION) {
                return is_ready(t, DD) and is_ready(t, INER);
            } else {
                return is_ready(t, DD) and is_ready(t, INER) and
                    is_ready(t, PREDIM) and is_ready(t, DELTA_T) and
                    is_ready(t, EXP_TIME);
            }
        }
    }

    void compute(double t, bool update)
    {
        if (not update) {
            _stop = false;
        } else {
            _len = _len_1;
        }
        if (_phase == internode::VEGETATIVE) {
            _len = 0;
        } else {
            if (_phase_1 == internode::VEGETATIVE and
                _phase == internode::REALIZATION) {
                _len = _iner * _dd;
            } else {
                if (not update) {
                    _len_1 = _len;
                }
                if (_phase != internode::REALIZATION_NOGROWTH and
                    _phase != internode::MATURITY_NOGROWTH and not _stop) {
                    _len = std::min(_predim,
                                    _len_1 + _iner * std::min(_delta_t,
                                                              _exp_time));
                }
                _stop = _phase == internode::REALIZATION_NOGROWTH;
            }
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("INTERNODE_LEN", t, artis::utils::COMPUTE)
            << "Len = " << _len
            << " ; index = " << _index
            << " ; len[-1] = " << _len_1
            << " ; phase[-1] = " << _phase_1
            << " ; phase = " << _phase
            << " ; DeltaT = " << _delta_t
            << " ; ExpTime = " << _exp_time
            << " ; INER = " << _iner
            << " ; DD = " << _dd;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _phase = internode::INIT;
        _phase_1 = internode::INIT;
        _len = 0;
        _len_1 = 0;
    }

    void put(double t, unsigned int index, double value)
    {
#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("INTERNODE_LEN", t, artis::utils::PUT)
            << "Index = " << index
            << " ; index = " << _index
            << " ; value = " << value;
        utils::Trace::trace().flush();
#endif

        if (index == PHASE and not is_ready(t, PHASE)) {
            _phase_1 = _phase;
        }
        ecomeristem::AbstractAtomicModel < InternodeLen >::put(t, index, value);
    }

private:
// parameters
    int _index;

// internal variable
    double _len;
    double _len_1;
    bool _stop;

// external variables
    double _dd;
    double _delta_t;
    double _phase;
    double _phase_1;
    double _iner;
    double _exp_time;
    double _predim;
};

} } // namespace ecomeristem internode

#endif

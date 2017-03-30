/**
 * @file internode/ExpTime.hpp
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

#ifndef __ECOMERISTEM_INTERNODE_EXP_TIME_HPP
#define __ECOMERISTEM_INTERNODE_EXP_TIME_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace internode {

class InternodeExpTime : public ecomeristem::AbstractAtomicModel < InternodeExpTime >
{
public:
    enum internals { EXP_TIME };
    enum externals { PREDIM, LEN, INER, PHASE };

    InternodeExpTime(int index) : _index(index)
    {
        internal(EXP_TIME, &InternodeExpTime::_exp_time);

        external(PREDIM, &InternodeExpTime::_predim);
        external(LEN, &InternodeExpTime::_len);
        external(INER, &InternodeExpTime::_iner);
        external(PHASE, &InternodeExpTime::_phase);
    }

    virtual ~InternodeExpTime()
    { }

    bool check(double t) const
    {
        if (_phase == internode::VEGETATIVE) {
            return true;
        } else {
            if (_phase_1 == internode::VEGETATIVE and
                _phase == internode::REALIZATION) {
                return is_ready(t, PREDIM) and is_ready(t, LEN) and
                    is_ready(t, INER);
            } else {
                return is_ready(t, PREDIM) and is_ready(t, INER);
            }
        }
    }

    void compute(double t, bool /* update */)
    {
        if (_phase == internode::VEGETATIVE) {
            _exp_time = 0;
        } else {
            if (_phase_1 == internode::VEGETATIVE and
                _phase == internode::REALIZATION) {
                _exp_time = (_predim - _len) / _iner;
            } else {
                _exp_time = (_predim - _len_1) / _iner;
            }
        }


#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("INTERNODE_EXP_TIME", t, artis::utils::COMPUTE)
            << "ExpTime = " << _exp_time
            << " ; index = " << _index
            << " ; len = " << _len
            << " ; len[-1] = " << _len_1
            << " ; Predim = " << _predim
            << " ; INER = " << _iner;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _exp_time = 0;
        _len_1 = 0;
        _len = 0;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == LEN and !is_ready(t, LEN)) {
            _len_1 = _len;
        }
        if (index == PHASE and !is_ready(t, PHASE)) {
            _phase_1 = _phase;
        }
        ecomeristem::AbstractAtomicModel < InternodeExpTime >::put(t, index, value);
    }

private:
// parameters
    int _index;

// internal variable
    double _exp_time;

// external variables
    double _iner;
    double _len;
    double _len_1;
    double _predim;
    double _phase;
    double _phase_1;
};

} } // namespace ecomeristem internode

#endif

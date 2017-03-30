/**
 * @file leaf/ExpTime.hpp
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

#ifndef __ECOMERISTEM_LEAF_EXP_TIME_HPP
#define __ECOMERISTEM_LEAF_EXP_TIME_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

class LeafExpTime : public ecomeristem::AbstractAtomicModel < LeafExpTime >
{
public:
    enum internals { EXP_TIME };
    enum externals { /* DD, */ LER, LEN, PREDIM };

    LeafExpTime(bool is_first_leaf, bool is_on_mainstem) :
        _is_first_leaf(is_first_leaf), _is_on_mainstem(is_on_mainstem)
    {
        internal(EXP_TIME, &LeafExpTime::_exp_time);

        // external(DD, &ExpTime::_dd);
        external(LER, &LeafExpTime::_ler);
        external(LEN, &LeafExpTime::_len);
        external(PREDIM, &LeafExpTime::_predim);
    }

    virtual ~LeafExpTime()
    { }

    virtual bool check(double t) const
    { return is_ready(t, LER) and is_ready(t, PREDIM); }

    void compute(double t, bool /* update */)
    {
/*        if (_first_day == t) {
            _exp_time = (_predim - _len_1) / _ler;
            _is_first_leaf = false;
        } else {
            if (_is_first_leaf and _is_on_mainstem) {
                _exp_time = _predim / _ler;
            } else {
                _exp_time = (_predim - _ler * _dd) / _ler;
            }
            } */

        if (_is_first_leaf and _is_on_mainstem) {
            _exp_time = _predim / _ler;
            _is_first_leaf = false;
        } else {
            _exp_time = (_predim - _len_1) / _ler;
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_EXP_TIME", t, artis::utils::COMPUTE)
            << "ExpTime = " << _exp_time
            << " ; len = " << _len
            << " ; len[-1] = " << _len_1
            << " ; Predim = " << _predim
            << " ; LER = " << _ler
            // << " ; DD = " << _dd
            << " ; is_first_leaf = " << _is_first_leaf
            << " ; is_on_mainstem = " << _is_on_mainstem;
        utils::Trace::trace().flush();
#endif

    }

    void init(double t,
              const model::models::ModelParameters& /* parameters */)
    {
        _exp_time = 0;
        _first_day = t;
        _len_1 = 0;
        _len = 0;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == LEN and !is_ready(t, LEN)) {
            _len_1 = _len;
        }
        ecomeristem::AbstractAtomicModel < LeafExpTime >::put(t, index, value);
    }

private:
// parameters
    bool _is_first_leaf;
    bool _is_on_mainstem;

// internal variable
    double _exp_time;
    double _first_day;

// external variables
    // double _dd;
    double _ler;
    double _len;
    double _len_1;
    double _predim;
};

} } // namespace ecomeristem leaf

#endif

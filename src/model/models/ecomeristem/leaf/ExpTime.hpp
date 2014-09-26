/**
 * @file leaf/ExpTime.hpp
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

#ifndef __ECOMERISTEM_LEAF_EXP_TIME_HPP
#define __ECOMERISTEM_LEAF_EXP_TIME_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace leaf {

class ExpTime : public AbstractAtomicModel < ExpTime >
{
public:
    enum internals { EXP_TIME };
    enum externals { DD, LER, LEN, PREDIM };

    ExpTime(bool is_first_leaf, bool is_on_mainstem) :
        _is_first_leaf(is_first_leaf), _is_on_mainstem(is_on_mainstem)
    {
        internal(EXP_TIME, &ExpTime::_exp_time);

        external(DD, &ExpTime::_dd);
        external(LER, &ExpTime::_ler);
        external(LEN, &ExpTime::_len);
        external(PREDIM, &ExpTime::_predim);
    }

    virtual ~ExpTime()
    { }

    void compute(double /* t */)
    {
        if (_is_first_step) {
            _exp_time = (_predim - _len_1) / _ler;
            _is_first_step = false;
        } else {
            if (_is_first_leaf and _is_on_mainstem) {
                _exp_time = _predim / _ler;
            } else {
                _exp_time = (_predim - _ler * _dd) / _ler;
            }
        }
    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _exp_time = 0;
        _is_first_step = true;
        _len_1 = 0;
        _len = 0;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == LEN and !is_ready(t, LEN)) {
            _len_1 = _len;
        }
        AbstractAtomicModel < ExpTime >::put(t, index, value);
    }

private:
// parameters
    bool _is_first_leaf;
    bool _is_on_mainstem;

// internal variable
    double _exp_time;
    bool _is_first_step;

// external variables
    double _dd;
    double _ler;
    double _len;
    double _len_1;
    double _predim;
};

} } // namespace ecomeristem leaf

#endif

/**
 * @file leaf/Manager.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2015 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2015 ULCO http://www.univ-littoral.fr
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

#ifndef __ECOMERISTEM_LEAF_MANAGER_HPP
#define __ECOMERISTEM_LEAF_MANAGER_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/Manager.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

enum Phase { INIT, INITIAL, LIG, NOGROWTH };

class Manager : public ecomeristem::AbstractAtomicModel < Manager >
{
public:
    enum internals { LEAF_PHASE };
    enum externals { PHASE, STOP, LEN, PREDIM };

    Manager(int index) : _index(index)
    {
        internal(LEAF_PHASE, &Manager::_phase_);
        external(PHASE, &Manager::_phase);
        external(STOP, &Manager::_stop);
        external(LEN, &Manager::_len);
        external(PREDIM, &Manager::_predim);
    }

    virtual ~Manager()
    { }

    virtual bool check(double /* t */) const
    { return true; }

    void compute(double t, bool /* update */)
    {
        if (_phase_ == leaf::INIT) {
            _phase_ = leaf::INITIAL;
        } else if (_phase_ == leaf::INITIAL and _len >= _predim) {
            _phase_ = leaf::LIG;
        } else if (_phase_ == leaf::LIG and _len < _predim) {
            _phase_ = leaf::INITIAL;
        } else if (_phase_ == leaf::INITIAL and
                   (_phase == plant::NOGROWTH or _phase == plant::NOGROWTH3
                    or _phase == plant::NOGROWTH4)) {
            _phase_ = leaf::NOGROWTH;
        } else if (_phase_ == leaf::NOGROWTH and
                   (_phase == plant::GROWTH or
                    _phase == plant::NEW_PHYTOMER3)) {
            _phase_ = leaf::INITIAL;
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_MANAGER", t, artis::utils::COMPUTE)
            << "phase = " << _phase_
            << " ; index = " << _index
            << " ; plant phase = " << _phase
            << " ; len = " << _len
            << " ; predim = " << _predim;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _phase = plant::INIT;
        _phase_ = leaf::INIT;
        _predim_init = false;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == PREDIM) {
            _predim_init = true;
        }

        ecomeristem::AbstractAtomicModel < Manager >::put(t, index, value);
        if (_phase_ == leaf::INIT or (is_ready(t, LEN) and _predim_init)) {
            (*this)(t);
        }
    }

private:
// internal variable
    double _phase_;
    bool   _predim_init;
    int    _index;

// external variables
    double _phase;
    double _stop;
    double _len;
    double _predim;
};

} } // namespace ecomeristem leaf

#endif

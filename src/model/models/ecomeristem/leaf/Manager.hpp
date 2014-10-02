/**
 * @file leaf/Manager.hpp
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

#ifndef __ECOMERISTEM_LEAF_MANAGER_HPP
#define __ECOMERISTEM_LEAF_MANAGER_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/Manager.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

class Manager : public AbstractAtomicModel < Manager >
{
public:
    enum internals { LEAF_PHASE };
    enum externals { PHASE, STOP, LEN, PREDIM };

    Manager()
    {
        internal(LEAF_PHASE, &Manager::_phase_);
        external(PHASE, &Manager::_phase);
        external(STOP, &Manager::_stop);
        external(LEN, &Manager::_len);
        external(PREDIM, &Manager::_predim);
    }

    virtual ~Manager()
    { }

    void compute(double t, bool /* update */)
    {
        if (_phase_ == plant::INIT) {
            _phase_ = plant::INITIAL;
        } else if (_phase_ == plant::INITIAL and _len >= _predim) {
            _phase_ = plant::LIG;
        } else if (_phase_ == plant::INITIAL and _phase == plant::NOGROWTH) {
            _phase_ = plant::NOGROWTH;
        } else if (_phase_ == plant::NOGROWTH and
                   _phase == plant::PHYTOMER_MORPHO_GENESIS) {
            _phase_ = plant::INITIAL;
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_MANAGER", t, utils::COMPUTE)
            << "phase = " << _phase_ << " ; phase = " << _phase
            << " ; len = " << _len << " ; predim = " << _predim;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _phase = plant::INIT;
        _phase_ = plant::INIT;
        _predim_init = false;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == PREDIM) {
            _predim_init = true;
        }

        AbstractAtomicModel < Manager >::put(t, index, value);
        if (_phase_ == plant::INIT or
            (is_ready(t, LEN) and _predim_init)) {
            (*this)(t);
        }
    }

private:
// internal variable
    double _phase_;
    bool _predim_init;

// external variables
    double _phase;
    double _stop;
    double _len;
    double _predim;
};

} } // namespace ecomeristem leaf

#endif

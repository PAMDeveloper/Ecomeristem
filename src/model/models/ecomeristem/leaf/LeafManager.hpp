/**
 * @file leaf/Manager.hpp
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

#ifndef __ECOMERISTEM_LEAF_MANAGER_HPP
#define __ECOMERISTEM_LEAF_MANAGER_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/PlantManager.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

enum Phase { INIT, INITIAL, LIG, NOGROWTH };

class LeafManager : public ecomeristem::AbstractAtomicModel < LeafManager >
{
public:
    enum internals { LEAF_PHASE };
    enum externals { PHASE, STOP, LEN, PREDIM };

    LeafManager(int index) : _index(index)
    {
        internal(LEAF_PHASE, &LeafManager::_phase_);
        external(PHASE, &LeafManager::_phase);
        external(STOP, &LeafManager::_stop);
        external(LEN, &LeafManager::_len);
        external(PREDIM, &LeafManager::_predim);
    }

    virtual ~LeafManager()
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

        ecomeristem::AbstractAtomicModel < LeafManager >::put(t, index, value);
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

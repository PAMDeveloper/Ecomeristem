/**
 * @file waterbal/cstr.hpp
 * @author The PARADEVS Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2013 ULCO http://www.univ-littoral.fr
 * Copyright (C) 2013 Cirad http://www.cirad.fr
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

#include <bag.hpp>
#include <dynamics.hpp>
#include <external_event.hpp>
#include <time.hpp>

namespace ecomeristem { namespace water_balance {

class cstr : public ecomeristem::Dynamics < >
{
public:
    cstr(const std::string& name,
         const paradevs::common::NoParameters& parameters) :
        ecomeristem::Dynamics < >(name, parameters)
    {
        // ThresTransp = parameters.ThresTransp;
        ThresTransp = 0.62;
    }

    virtual ~cstr()
    { }

    void receive(const Bag& x, Time /* t */)
    {
        for (auto & event : x) {
            if (event.get_port_name() == "FTSW") {
                _FTSW = get_content(event);
            }
        }
    }

    paradevs::common::DoubleTime::type start(Time /* t */)
    {
        _cstr = 0;
        return 0;
    }

    Bag lambda(Time /* t */) const
    { return build_bag("cstr", &_cstr_1); }

    void update_buffer(Time /* t */)
    { _cstr_1 = _cstr; }

private:
    void compute(Time /* t */)
    {
        _cstr = (_FTSW < ThresTransp) ?
            std::max(1e-4, _FTSW * 1. / ThresTransp) : 1;
    }

// parameters
    double ThresTransp;

// internal variables
    double _cstr;
    double _cstr_1;

// external variables
    double _FTSW;
};

} } // namespace ecomeristem water_balance

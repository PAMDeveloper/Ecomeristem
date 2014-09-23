/**
 * @file waterbal/fcstr.hpp
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

class Fcstr : public ecomeristem::Dynamics  < >
{
public:
    Fcstr(const std::string& name,
          const paradevs::common::NoParameters& parameters) :
        ecomeristem::Dynamics < >(name, parameters)
    { }

    virtual ~Fcstr()
    { }

    void receive(const Bag& events, Time /* t */)
    {
        for (auto & event : events) {
            if (event.get_port_name() == "cstr") {
                _cstr = get_content(event);
            }
        }
    }

    paradevs::common::DoubleTime::type start(Time /* t */)
    {
        _fcstr = 0;
        return 0;
    }

    Bag lambda(Time /* t */) const
    { return build_bag("fcstr", &_fcstr_1); }

    void update_buffer(Time /* t */)
    { _fcstr_1 = _fcstr; }

private:
    void compute(Time /* t */)
    { _fcstr = std::sqrt(_cstr); }

// internal variable
    double _fcstr;
    double _fcstr_1;

// external variables
    double _cstr;
};

} } // namespace ecomeristem water_balance

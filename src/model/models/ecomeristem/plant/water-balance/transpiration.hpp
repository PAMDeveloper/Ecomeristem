/**
 * @file waterbal/transpiration.hpp
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

class Transpiration : public ecomeristem::Dynamics  < >
{
public:
    Transpiration(const std::string& name,
          const paradevs::common::NoParameters& parameters) :
        ecomeristem::Dynamics < >(name, parameters)
    {
        // ETPmax = parameters.ETPmax;
        // Kcpot = parameters.Kcpot;
        // density = parameters.density;

        ETPmax = 8;
        Kcpot = 1.3;
        density = 30;
    }

    virtual ~Transpiration()
    { }

    void receive(const Bag& events, Time /* t */)
    {
        for (auto & event : events) {
            if (event.get_port_name() == "cstr") {
                _cstr = get_content(event);
            }
            if (event.get_port_name() == "Interc") {
                _interc = get_content(event);
            }
            if (event.get_port_name() == "ETP") {
                _ETP = get_content(event);
            }
            if (event.get_port_name() == "SWC") {
                _SWC = get_content(event);
            }
        }
    }

    paradevs::common::DoubleTime::type start(Time /* t */)
    {
        _transpiration = 0;
        _SWC_1 = 0;
        return 0;
    }

    Bag lambda(Time /* t */) const
    { return build_bag("deltap", &_transpiration_1); }

    void update_buffer(Time /* t */)
    {
        _transpiration_1 = _transpiration;
        _SWC_1 = _SWC;
    }

private:
    void compute(Time /* t */)
    {
        _transpiration =  std::min(_SWC_1,
                                   (Kcpot * std::min(_ETP, ETPmax) *
                                    _interc * _cstr) / density);
    }

// parameters
    double ETPmax;
    double Kcpot;
    double density;

// internal variable
    double _transpiration;
    double _transpiration_1;

// external variables
    double _cstr;
    double _interc;
    double _ETP;
    double _SWC;
    double _SWC_1;
};

} } // namespace ecomeristem water_balance

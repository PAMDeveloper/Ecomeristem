/**
 * @file ecomeristem/plant/stock/Supply.hpp
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

#ifndef __ECOMERISTEM_PLANT_STOCK_SUPPLY_HPP
#define __ECOMERISTEM_PLANT_STOCK_SUPPLY_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace stock {

class PlantSupply : public ecomeristem::AbstractAtomicModel < PlantSupply >
{
public:
    static const unsigned int SUPPLY = 0;
    static const unsigned int ASSIM = 0;

    PlantSupply()
    {
        internal(SUPPLY, &PlantSupply::_supply);
        external(ASSIM, &PlantSupply::_assim);
    }

    virtual ~PlantSupply()
    { }

    bool check(double t) const
    { return is_ready(t, ASSIM); }

    void compute(double t, bool /* update */)
    {
        _supply = _assim;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("SUPPLY", t, artis::utils::COMPUTE)
            << "supply = " << _supply << " ; Assim = " << _assim;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _supply = 0;
    }

private:
// internal variable
    double _supply;

// external variables
    double _assim;
};

} } } // namespace ecomeristem plant stock

#endif

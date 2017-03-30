/**
 * @file ecomeristem/culm/Stock.hpp
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

#ifndef __ECOMERISTEM_CULM_STOCK_HPP
#define __ECOMERISTEM_CULM_STOCK_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace culm {

class CulmStock : public ecomeristem::AbstractAtomicModel < CulmStock >
{
public:
    enum internals { STOCK };
    enum externals { INTERMEDIATE, MAX_RESERVOIR_DISPO };

    CulmStock()
    {
        internal(STOCK, &CulmStock::_stock);

        external(INTERMEDIATE, &CulmStock::_intermediate);
        external(MAX_RESERVOIR_DISPO, &CulmStock::_max_reversoir_dispo);
    }

    virtual ~CulmStock()
    { }

    void compute(double t, bool /* update */)
    {

        _stock = std::max(0., std::min(_max_reversoir_dispo, _intermediate));

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM_STOCK", t, artis::utils::COMPUTE)
            << "Stock = " << _stock
            << " ; Intermediate = " << _intermediate
            << " ; MaxReservoirDispo = " << _max_reversoir_dispo;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _stock = 0;
    }

private:
// internal variables
    double _stock;

// external variables
    double _intermediate;
    double _max_reversoir_dispo;
};

} } // namespace ecomeristem culm

#endif

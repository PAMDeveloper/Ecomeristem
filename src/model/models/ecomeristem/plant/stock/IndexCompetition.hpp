/**
 * @file ecomeristem/plant/stock/IndexCompetition.hpp
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

#ifndef __ECOMERISTEM_PLANT_STOCK_INDEX_COMPETITION_HPP
#define __ECOMERISTEM_PLANT_STOCK_INDEX_COMPETITION_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace stock {

class IndexCompetition : public ecomeristem::AbstractAtomicModel < IndexCompetition >
{
public:
    enum internals { IC, TEST_IC };
    enum externals { DAY_DEMAND, SEED_RES, SUPPLY };

    IndexCompetition()
    {
        internal(IC, &IndexCompetition::_ic);
        internal(TEST_IC, &IndexCompetition::_test_ic);

        external(DAY_DEMAND, &IndexCompetition::_day_demand);
        external(SEED_RES, &IndexCompetition::_seed_res);
        external(SUPPLY, &IndexCompetition::_supply);
    }

    virtual ~IndexCompetition()
    { }

    bool check(double t) const
    { return is_ready(t, DAY_DEMAND) and is_ready(t, SEED_RES)
            and is_ready(t, SUPPLY); }

    void compute(double t, bool /* update */)
    {
        // if (not update) {
            if (not _is_first_day) {
                double resDiv, mean;
                double total = 0.;
                int n = 0;

                if (_day_demand_[0] != 0) {
                    resDiv = (std::max(0., _seed_res_[0]) + _supply_[0]) /
                        _day_demand_[0];
                    total += resDiv;
                    ++n;
                }

                if (_day_demand_[0] != 0) {
                    resDiv = (std::max(0., _seed_res_[0]) + _supply_[0]) /
                        _day_demand_[0];
                    total += resDiv;
                    ++n;
                }

                if (_day_demand_[1] != 0) {
                    resDiv = (std::max(0., _seed_res_[1]) + _supply_[1]) /
                        _day_demand_[1];
                    total += resDiv;
                    ++n;
                }

                if (_day_demand_[2] != 0) {
                    resDiv = (std::max(0., _seed_res_[2]) + _supply_[2]) /
                        _day_demand_[2];
                    total += resDiv;
                    ++n;
                }

                if (n != 0) {
                    mean = total / n;
                } else {
                    mean = _ic_1;
                }

                double tmp = std::min(5., mean);

                _ic_1 = _ic;
                if (tmp == 0 and _seed_res_[0] == 0 and _seed_res_[1] == 0 and
                    _seed_res_[2] == 0) {
                    _ic = 0.001;
                    _test_ic = 0.001;
                } else {
                    _ic = tmp;
                    _test_ic = std::min(1., std::sqrt(tmp));
                }
            } else {
                _is_first_day = false;
            }
        // }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("IC", t, artis::utils::COMPUTE)
            << "IC = " << _ic
            << " ; testIC = " << _test_ic
            << " ; SeedRes = " << _seed_res
            << " ; SeedRes[0] = " << _seed_res_[0]
            << " ; SeedRes[-1] = " << _seed_res_[1]
            << " ; SeedRes[-2] = " << _seed_res_[2]
            << " ; Supply = " << _supply
            << " ; Supply[0] = " << _supply_[0]
            << " ; Supply[-1] = " << _supply_[1]
            << " ; Supply[-2] = " << _supply_[2]
            << " ; DayDemand = " << _day_demand
            << " ; DayDemand[0] = " << _day_demand_[0]
            << " ; DayDemand[-1] = " << _day_demand_[1]
            << " ; DayDemand[-2] = " << _day_demand_[2];
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _ic = 0;
        _test_ic = 0;
        _supply_[2] = _supply_[1] = _supply_[0] = _supply = 0;
        _seed_res_[2] = _seed_res_[1] = _seed_res_[0] = _seed_res = 0;
        _day_demand_[2] = _day_demand_[1] = _day_demand_[0] = _day_demand = 0;
        _is_first_day = true;
    }

    void put(double t, unsigned int index, double value)
    {

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("IC", t, artis::utils::PUT)
            << "index = " << index
            << " ; value = " << value;
        utils::Trace::trace().flush();
#endif

        if (index == SUPPLY and !is_ready(t, SUPPLY)) {
            _supply_[2] = _supply_[1];
            _supply_[1] = _supply_[0];
            _supply_[0] = _supply;
        }
        if (index == SEED_RES and !is_ready(t, SEED_RES)) {
            _seed_res_[2] = _seed_res_[1];
            _seed_res_[1] = _seed_res_[0];
            _seed_res_[0] = _seed_res;
        }
        if (index == DAY_DEMAND and !is_ready(t, DAY_DEMAND)) {
            _day_demand_[2] = _day_demand_[1];
            _day_demand_[1] = _day_demand_[0];
            _day_demand_[0] = _day_demand;
        }

        ecomeristem::AbstractAtomicModel < IndexCompetition >::put(t, index,
                                                                   value);
    }

private:
// internal variables
    double _ic;
    double _ic_1;
    double _test_ic;
    bool _is_first_day;

// external variables
    double _day_demand;
    double _day_demand_[3];
    double _seed_res;
    double _seed_res_[3];
    double _supply;
    double _supply_[3];
};

} } } // namespace ecomeristem plant stock

#endif

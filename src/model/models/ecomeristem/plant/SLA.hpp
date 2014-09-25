/**
 * @file plant/SLA.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2014 INRA http://www.cirad.fr
 * Copyright (C) 2014 ULCO http://www.univ-littoral.fr
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

#ifndef __ECOMERISTEM_PLANT_SLA_HPP
#define __ECOMERISTEM_PLANT_SLA_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant {

class Sla : public AbstractAtomicModel < Sla >
{
public:
    static const unsigned int SLA = 0;
    static const unsigned int PHENO_STAGE = 0;

    Sla()
    {
        internal(SLA, &Sla::_sla);
        external(PHENO_STAGE, &Sla::_phenoStage);
    }

    virtual ~Sla()
    { }

    void compute(double /* t */)
    { _sla = FSLA - SLAp * std::log(_phenoStage); }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        FSLA = parameters.get < double >("FSLA");
        SLAp = parameters.get < double >("SLAp");
        _sla = 0;
    }

private:
    // parameters
    double FSLA;
    double SLAp;

    // internal variable
    double _sla;

    // external variable
    double _phenoStage;
};

} } // namespace ecomeristem plant

#endif

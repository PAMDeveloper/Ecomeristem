/**
 * @file assimilation/RespMaint.hpp
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

namespace ecomeristem { namespace plant { namespace assimilation {

class RespMaint
{
public:
    RespMaint()
    {
        Kresp_leaf = 0.015;
        Kresp_internode = 0.007;
        Tresp = 25;
    }

    virtual ~RespMaint()
    { }

    void assign_LeafBiomass(double value)
    {
        LeafBiomass = value;
    }

    void assign_InternodeBiomass(double value)
    {
        InternodeBiomass = value;
    }

    void assign_Ta(double value)
    {
        Ta = value;
    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        Kresp_leaf = parameters.get("Kresp_leaf");
        Kresp_internode = parameters.get("Kresp_internode");
        Tresp = parameters.get("Tresp");
        _RespMaint = 0;
    }

    void compute(double /* t */)
    {
        _RespMaint = (Kresp_leaf * LeafBiomass +
                      Kresp_internode * InternodeBiomass) *
            std::pow(2., (Ta - Tresp) / 10.);
    }

private:
// parameters
    double Kresp_leaf;
    double Kresp_internode;
    double Tresp;

// internal variable
    double _RespMaint;

// external variables
    double LeafBiomass;
    double InternodeBiomass;
    double Ta;
};

} } } // namespace ecomeristem plant assimilation

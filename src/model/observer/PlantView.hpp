/**
 * @file model/observer/PlantView.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS file
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

#ifndef MODEL_OBSERVER_PLANT_VIEW_HPP
#define MODEL_OBSERVER_PLANT_VIEW_HPP

#include <model/observer/View.hpp>
#include <utils/DateTime.hpp>

#include <fstream>

namespace model { namespace observer {

class PlantView : public View
{
public:
    PlantView()
    {
        values["LAI"] = std::map < double, double >();
        values["DELTA_T"] = std::map < double, double >();
        values["BOOL_CROSSED_PLASTO"] = std::map < double, double >();
        values["DD"] = std::map < double, double >();
        values["IH"] = std::map < double, double >();
        values["LIGULO_VISU"] = std::map < double, double >();
        values["PHENO_STAGE"] = std::map < double, double >();
        values["PLASTO_VISU"] = std::map < double, double >();
        values["TT"] = std::map < double, double >();
        values["TT_LIG"] = std::map < double, double >();
        values["CSTR"] = std::map < double, double >();
    }

    virtual ~PlantView()
    { }

    double get(double t, const std::string& name) const
    {
        return values.find(name)->second.find(t)->second;
    }

    virtual void observe(double t)
    {
        values["LAI"][t] = model->get(model::kernel::Model::LAI);
        values["DELTA_T"][t] = model->get(model::kernel::Model::DELTA_T);
        values["BOOL_CROSSED_PLASTO"][t] =
            model->get(model::kernel::Model::BOOL_CROSSED_PLASTO);
        values["DD"][t] = model->get(model::kernel::Model::DD);
        values["EDD"][t] = model->get(model::kernel::Model::EDD);
        values["IH"][t] = model->get(model::kernel::Model::IH);
        values["LIGULO_VISU"][t] =
            model->get(model::kernel::Model::LIGULO_VISU);
        values["PHENO_STAGE"][t] =
            model->get(model::kernel::Model::PHENO_STAGE);
        values["PLASTO_VISU"][t] =
            model->get(model::kernel::Model::PLASTO_VISU);
        values["TT"][t] = model->get(model::kernel::Model::TT);
        values["TT_LIG"][t] = model->get(model::kernel::Model::TT_LIG);
        values["ASSIM"][t] = model->get(model::kernel::Model::ASSIM);
        values["CSTR"][t] = model->get(model::kernel::Model::CSTR);
    }

private:
    std::map < std::string, std::map < double, double > > values;
};

} }

#endif

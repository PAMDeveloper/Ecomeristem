/**
 * @file model/observer/View.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS file
 */

/*
 * Copyright (C) 2005-2015 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2015 ULCO http://www.univ-littoral.fr
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

#ifndef MODEL_OBSERVER_VIEW_HPP
#define MODEL_OBSERVER_VIEW_HPP

#include <model/kernel/Model.hpp>

namespace model { namespace observer {

class View
{
    typedef std::vector < unsigned int > Selector;

public:
    View();
    virtual ~View();

    void attachModel(const model::kernel::Model* m)
    { _model = m; }

    double get(double t, const std::string& name) const;

    virtual void observe(double time);

    void selector(const std::string& name, const Selector& chain);

private:
    typedef std::map < std::string, Selector > Selectors;
    typedef std::vector < std::pair < double, double > > Value;
    typedef std::map < std::string, Value > Values;

    Selectors                   _selectors;
    Values                      _values;
    const model::kernel::Model* _model;
};

} }

#endif

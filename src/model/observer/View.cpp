/**
 * @file model/observer/View.cpp
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

#include <model/observer/View.hpp>

namespace model { namespace observer {

View::View() : _model(0)
{ }

View::~View()
{ }

double View::get(double t, const std::string& name) const
{
    Values::const_iterator it = _values.find(name);

    if (it != _values.end()) {
        Value::const_iterator itp = it->second.begin();

        while (itp != it->second.end() and itp->first < t) {
            ++itp;
        }
        if (itp != it->second.end()) {
            return itp->second;
        } else {
            return 0;
        }
    }
    return 0;
}

void View::observe(double time)
{
    for (Selectors::const_iterator it = _selectors.begin();
         it != _selectors.end(); ++it) {
        const ecomeristem::AbstractModel* model = _model;

        if (it->second.size() > 1) {
            size_t i = 0;

            while (i < it->second.size() - 1 and model) {
                model = model->submodel(it->second[i]);
                ++i;
            }
        }
        if (model) {
            _values[it->first].push_back(
                std::make_pair(time, model->get(time, it->second.back())));
        }
    }
}

void View::selector(const std::string& name, const Selector& chain)
{
    _selectors[name] = chain;
    _values[name] = Value();
}

} }

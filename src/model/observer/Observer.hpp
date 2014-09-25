/**
 * @file model/observer/Observer.hpp
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

#ifndef MODEL_OBSERVER_OBSERVER_HPP
#define MODEL_OBSERVER_OBSERVER_HPP

#include <model/kernel/Model.hpp>
#include <model/observer/View.hpp>
#include <model/observer/PlantView.hpp>

#include <vector>

namespace model { namespace observer {

class Observer
{
    typedef std::map < std::string, View* > Views;

public:
    Observer(const model::kernel::Model* model) :
        model(model)
    { }

    virtual ~Observer()
    {
        for (typename Views::iterator it = views.begin(); it != views.end();
             ++it) {
            delete it->second;
        }
    }

    void attachView(const std::string& name, View* view)
    {
        views[name] = view;
        view->attachModel(model);
    }

    const View& view(const std::string& name) const
    { return *views.find(name)->second; }

    void init()
    {
        attachView("plant", new PlantView);
    }

    void observe(double t)
    {
        for (typename Views::iterator it = views.begin(); it != views.end();
             ++it) {
            it->second->observe(t);
        }
    }

private:
    const model::kernel::Model* model;
    Views views;
};

} } // namespace tnt model

#endif

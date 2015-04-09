/**
 * @file utils/Trace.cpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2012-2014 ULCO http://www.univ-littoral.fr
 * Copyright (C) 2005-2014 Cirad http://www.cirad.fr
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

#include <utils/Trace.hpp>

namespace utils {

    Trace* Trace::_instance = 0;

} // namespace utils

utils::Trace& operator<<(utils::Trace& trace, const utils::TraceElement& e)
{
    trace.set_element(e);
    return trace;
}

utils::Trace& operator<<(utils::Trace& trace, const std::string& str)
{
    trace.sstream() << str;
    return trace;
}

utils::Trace& operator<<(utils::Trace& trace, double t)
{
    trace.sstream().precision(10);
    trace.sstream() << t;
    return trace;
}

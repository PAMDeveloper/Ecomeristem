/**
 * @file ModelParameters.hpp
 * @author The TNT Development Team
 * See the AUTHORS file
 */

/*
 * Copyright (C) 2013-2014 ULCO http://www.univ-littoral.fr
 * Copyright (C) 2013-2014 INRA http://www.inra.fr
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

#ifndef MODELPARAMETERS_HPP
#define MODELPARAMETERS_HPP 1

#include <iostream>
#include <map>
#include <string>
#include <boost/lexical_cast.hpp>

namespace model { namespace models {

class ModelParameters
{
public:
    /**
     * Default constructor.
     */
    ModelParameters()
    { }

    /**
     * Destructor.
     */
    virtual ~ModelParameters()
    { }

    /**
     * Get the requested parameter.
     * @param[in] paramName The name of the needed parameter.
     * @return T The data if readable for this type, an empty data otherwise.
     */
    template < typename T >
    T get(const std::string& paramName) const
    {
        std::map < std::string, std::string >::const_iterator it;
        it = mParams.find(paramName);

        if (it == mParams.end()) {
            std::cout << "Warning: no value for " << paramName << std::endl;
        }

        return boost::lexical_cast<T>((it == mParams.end()) ? "0" : it->second);
    }

    /**
     * Set (update or create) the given parameter/
     * @param[in] key   The parameter name.
     * @param[in] value The value of this parameter.
     * @return void.
     */
    template < typename T >
    inline void set(const std::string& key, const T& value)
    { mParams[key] = boost::lexical_cast < std::string >(value); }

    /**
     * Removes all parameters.
     * @param void.
     * @return void.
     */
    inline void clear()
    { mParams.clear(); }

private:
    /*
     * We could use std::map < std::string, boost::any > params; but it doesn't
     * accept to change the input data type and the user could put heavy types.
     * Get:
     * { return boost::any_cast < T >(params[paramName]); }
     * Set:
     * { params[key] = value; }
     */
    std::map < std::string, std::string > mParams;//!< Represent the parameters.
};

} }

#endif

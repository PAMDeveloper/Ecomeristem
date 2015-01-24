/**
 * @file utils/Trace.hpp
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

#ifndef UTILS_TRACE
#define UTILS_TRACE

#include <utils/DateTime.hpp>

#include <algorithm>
#include <iterator>
#include <sstream>
#include <string>
#include <vector>

namespace utils {

    enum TraceType { NONE, CHECK, COMPUTE, INIT, PUT };

class TraceElement
{
public:
    TraceElement() : _time(-1), _type(NONE)
    { }

    TraceElement(const std::string& model_name, double time,
                 TraceType type) :
        _model_name(model_name), _time(time), _type(type)
    { }

    virtual ~TraceElement()
    { }

    const std::string& get_comment() const
    { return _comment; }

    const std::string& get_model_name() const
    { return _model_name; }

    double get_time() const
    { return _time; }

    TraceType get_type() const
    { return _type; }

    void set_comment(const std::string& comment)
    { _comment = comment; }

private:
    std::string _model_name;
    double      _time;
    TraceType   _type;
    std::string _comment;
};

class TraceElements : public std::vector < TraceElement >
{
public:
    TraceElements()
    { }
    virtual ~TraceElements()
    { }

    TraceElements filter_model_name(
        const std::string& model_name) const
    {
        TraceElements result;

        std::copy_if(TraceElements::begin(),
                     TraceElements::end(), std::back_inserter(result),
                     [model_name](TraceElement const & x)
                     { return x.get_model_name() == model_name; });
        return result;
    }

    TraceElements filter_time(double time) const
    {
        TraceElements result;

        std::copy_if(TraceElements::begin(),
                     TraceElements::end(), std::back_inserter(result),
                     [time](TraceElement const & x)
                     { return x.get_time() == time; });
        return result;
    }

    TraceElements filter_type(TraceType type) const
    {
        TraceElements result;

        std::copy_if(TraceElements::begin(),
                     TraceElements::end(), std::back_inserter(result),
                     [type](TraceElement const & x)
                     { return x.get_type() == type; });
        return result;
    }

    std::string to_string() const
    {
        std::ostringstream ss;

        for (TraceElements::const_iterator it = TraceElements::begin();
             it != TraceElements::end(); ++it) {
            ss << "TRACE: " << it->get_model_name() << " at "
               << DateTime::toJulianDay(it->get_time()) << " <";
            switch (it->get_type())
            {
            case NONE: ss << "none"; break;
            case CHECK: ss << "check"; break;
            case COMPUTE:  ss << "compute"; break;
            case INIT: ss << "init"; break;
            case PUT: ss << "put"; break;
            };
            ss << ">";
            if (not it->get_comment().empty()) {
                ss << " => " << it->get_comment();
            }
            ss << std::endl;
        }
        return ss.str();
    }
};

class Trace
{
public:
    static Trace& trace()
    {
        if (_instance == 0) {
            _instance = new Trace();
        }
        return *_instance;
    }

    void clear()
    {
        _trace.clear();
        if (_instance) {
            // delete _instance;
            _instance = 0;
        }
    }

    const TraceElements& elements() const
    { return _trace; }

    void flush()
    {
        if (_sstream) {
            _element.set_comment(_sstream->str());
            delete _sstream;
            _sstream = 0;
        }
        _trace.push_back(_element);
    }

    void set_element(const TraceElement& element)
    { _element = element; }

    std::ostringstream& sstream()
    {
        if (_sstream == 0) {
            _sstream = new std::ostringstream();
        }
        return *_sstream;
    }

private:
    Trace()
    { _sstream = 0; }

    virtual ~Trace()
    {
        if (_instance) {
            delete _instance;
        }
        if (_sstream) {
            delete _sstream;
        }
    }

    static Trace* _instance;

    TraceElements       _trace;
    TraceElement        _element;
    std::ostringstream* _sstream;
};

} // namespace utils

utils::Trace& operator<<(utils::Trace& trace, const utils::TraceElement& e);
utils::Trace& operator<<(utils::Trace& trace, const std::string& str);
utils::Trace& operator<<(utils::Trace& trace, double t);

#endif

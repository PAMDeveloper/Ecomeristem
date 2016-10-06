/**
* @file DateTime.hpp
* @author The Ecomeristem Development Team
* See the AUTHORS file
*/

/*
* Copyright (C) 2012-2015 ULCO http://www.univ-littoral.fr
* Copyright (C) 2005-2015 Cirad http://www.cirad.fr
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

#ifndef ECOMERISTEM_DATE_TIME_HPP
#define ECOMERISTEM_DATE_TIME_HPP

#include <ostream>
#include <string>

#include <boost/algorithm/string.hpp>
#include <boost/date_time.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/numeric/conversion/cast.hpp>
#include <boost/version.hpp>

#include <utils/Exception.hpp>

namespace utils {

	class DateTime
	{
	public:
		static std::string currentDate()
		{
			boost::posix_time::ptime current(
				boost::posix_time::second_clock::local_time());

			std::ostringstream out;
			out << current;

			return out.str();
		}

		static unsigned int year(const double& time)
		{
			boost::gregorian::date d(
				boost::numeric_cast <
				boost::gregorian::date::date_int_type >(time));

			return d.year();
		}

		static unsigned int month(const double& time)
		{
			boost::gregorian::date d(
				boost::numeric_cast <
				boost::gregorian::date::date_int_type >(time));

			return d.month();
		}

		static unsigned int dayOfMonth(const double& time)
		{
			boost::gregorian::date d(
				boost::numeric_cast <
				boost::gregorian::date::date_int_type >(time));

			return d.day();
		}

		static unsigned int dayOfYear(const double& time)
		{
			boost::gregorian::date d(
				boost::numeric_cast <
				boost::gregorian::date::date_int_type >(time));

			return d.day_of_year();
		}

		static unsigned int weekOfYear(const double& time)
		{
			boost::gregorian::date d(
				boost::numeric_cast <
				boost::gregorian::date::date_int_type >(time));

			return d.week_number();
		}

		static long toJulianDayNumber(int year, int month, int day)
		{
			std::ostringstream oss;
			oss << year << '-' << month << '-' << day;
			return toJulianDayNumber(oss.str());
		}

		static long fromDayMonthYearToJulianDay(const std::string& date)
		{
			boost::gregorian::date d;

			try {
				d = boost::gregorian::from_uk_string(date);
				return d.julian_day();
			}
			catch (...) {

				throw utils::ParseError(
					boost::format(
						"Date time error: error to convert '%1%' into julian"
						" day number") % date);
			}
			return -1.0L;
		}

		static long fromYearMonthDayToJulianDay(const std::string& date)
		{
			boost::gregorian::date d;

			try {
				d = boost::gregorian::from_simple_string(date);
				return d.julian_day();
			}
			catch (...) {

				throw utils::ParseError(
					boost::format(
						"Date time error: error to convert '%1%' into julian"
						" day number") % date);
			}
			return -1.0L;
		}

		static long toJulianDayNumber(const std::string& date)
		{
			boost::gregorian::date d;

			try {
				d = boost::gregorian::from_simple_string(date);
				return d.julian_day();
			}
			catch (...) {
				try {
					d = boost::gregorian::from_undelimited_string(date);
					return d.julian_day();
				}
				catch (...) {
					try {
						d = boost::gregorian::from_uk_string(date);
						return d.julian_day();
					}
					catch (...) {
						throw utils::ParseError(
							boost::format(
								"Date time error: error to convert '%1%' into julian"
								" day number") % date);
					}
				}
			}
			return -1.0L;
		}

		static std::string toJulianDay(double date)
		{
			double f, e;
			f = std::modf(date, &e);

			f *= 24.0;
			long hours = std::floor(f);
			f -= hours;

			f *= 60.0;
			long minutes = std::floor(f);
			f -= minutes;

			f *= 60.0;
			long seconds = std::floor(f);
			f -= seconds;

			boost::posix_time::time_duration td(hours, minutes, seconds, f);
			boost::posix_time::ptime d(boost::gregorian::date(e), td);
			return boost::posix_time::to_simple_string(d);
		}

		static void format_date(const std::string& str, std::string& date)
		{
			std::vector < std::string > list;

			boost::split(list, str, boost::is_any_of("-/"));
			date = (boost::format("%1%/%2%/%3%") % list[2] % list[1] %
				list[0]).str();
		}

	};

}

#endif

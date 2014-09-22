INCLUDE_DIRECTORIES(
  ${CMAKE_SOURCE_DIR}/src
  ${Boost_INCLUDE_DIRS})

LINK_DIRECTORIES(
  ${Boost_LIBRARY_DIRS})

SET(ECOMERISTEM_UTILS_CPP
    Connections.cpp ParametersReader.cpp)

SET(ECOMERISTEM_UTILS_HPP Connections.hpp Exception.hpp DateTime.hpp
  ParametersReader.hpp)

ADD_LIBRARY(ecomeristem-utils SHARED ${ECOMERISTEM_UTILS_CPP} ${ECOMERISTEM_UTILS_HPP})

TARGET_LINK_LIBRARIES(ecomeristem-utils ${Boost_LIBRARIES} pqxx)

INSTALL(TARGETS ecomeristem-utils DESTINATION lib)
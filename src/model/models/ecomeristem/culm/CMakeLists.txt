INCLUDE_DIRECTORIES(
  ${CMAKE_SOURCE_DIR}/src)

LINK_DIRECTORIES()

SET(ECOMERISTEM_CULM_HPP Model.hpp Deficit.hpp Intermediate.hpp
  MaxReservoirDispo.hpp Stock.hpp Supply.hpp Surplus.hpp)

SET(ECOMERISTEM_CULM_CPP Model.cpp)

ADD_LIBRARY(ecomeristem-culm SHARED ${ECOMERISTEM_CULM_HPP}
  ${ECOMERISTEM_CULM_CPP})
TARGET_LINK_LIBRARIES(ecomeristem-culm)

INSTALL(TARGETS ecomeristem-culm DESTINATION lib)

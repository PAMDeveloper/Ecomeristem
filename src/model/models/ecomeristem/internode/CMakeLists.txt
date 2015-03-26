INCLUDE_DIRECTORIES(
  ${CMAKE_SOURCE_DIR}/src)

LINK_DIRECTORIES()

SET(ECOMERISTEM_INTERNODE_HPP Biomass.hpp DiameterPredim.hpp INER.hpp
  LastDemand.hpp Manager.hpp Model.hpp TimeFromApp.hpp
  ExpTime.hpp InternodeDemand.hpp Len.hpp Predim.hpp ReductionINER.hpp
  Volume.hpp)

SET(ECOMERISTEM_INTERNODE_CPP Model.cpp)

ADD_LIBRARY(ecomeristem-internode SHARED ${ECOMERISTEM_INTERNODE_HPP}
  ${ECOMERISTEM_INTERNODE_CPP})
TARGET_LINK_LIBRARIES(ecomeristem-internode)

INSTALL(TARGETS ecomeristem-internode DESTINATION lib)

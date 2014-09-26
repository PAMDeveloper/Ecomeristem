INCLUDE_DIRECTORIES(
  ${CMAKE_SOURCE_DIR}/src)

LINK_DIRECTORIES()

SET(ECOMERISTEM_LEAF_HPP Biomass.hpp ExpTime.hpp Len.hpp Predim.hpp
  Width.hpp BladeArea.hpp LastDemand.hpp LER.hpp Model.hpp ReductionLER.hpp
  LeafDemand.hpp Manager.hpp PlastoDelay.hpp TimeFromApp.hpp)

SET(ECOMERISTEM_LEAF_CPP Model.cpp)

ADD_LIBRARY(ecomeristem-leaf SHARED ${ECOMERISTEM_LEAF_HPP} ${ECOMERISTEM_LEAF_CPP})
TARGET_LINK_LIBRARIES(ecomeristem-leaf)

INSTALL(TARGETS ecomeristem-leaf DESTINATION lib)

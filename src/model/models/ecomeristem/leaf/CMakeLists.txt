INCLUDE_DIRECTORIES(
  ${CMAKE_SOURCE_DIR}/src ${ARTIS_INCLUDE_DIRS})

LINK_DIRECTORIES(${ARTIS_LIBRARY_DIRS})

SET(ECOMERISTEM_LEAF_HPP Biomass.hpp ExpTime.hpp Len.hpp LifeSpan.hpp Predim.hpp
  Width.hpp BladeArea.hpp LastDemand.hpp LER.hpp Model.hpp ReductionLER.hpp
  LeafDemand.hpp Manager.hpp PlastoDelay.hpp TimeFromApp.hpp
  ThermalTimeSinceLigulation.hpp)

SET(ECOMERISTEM_LEAF_CPP Model.cpp)

ADD_LIBRARY(ecomeristem-leaf SHARED ${ECOMERISTEM_LEAF_HPP}
  ${ECOMERISTEM_LEAF_CPP})
TARGET_LINK_LIBRARIES(ecomeristem-leaf)

INSTALL(TARGETS ecomeristem-leaf DESTINATION lib)

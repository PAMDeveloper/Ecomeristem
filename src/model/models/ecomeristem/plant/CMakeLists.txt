INCLUDE_DIRECTORIES(
  ${CMAKE_SOURCE_DIR}/src)

LINK_DIRECTORIES()

SET(ECOMERISTEM_PLANT_HPP Lig.hpp Manager.hpp Model.hpp SLA.hpp
  TillerManager.hpp)

SET(ECOMERISTEM_PLANT_CPP Manager.cpp Model.cpp)

ADD_LIBRARY(ecomeristem-plant SHARED ${ECOMERISTEM_PLANT_HPP}
  ${ECOMERISTEM_PLANT_CPP})
TARGET_LINK_LIBRARIES(ecomeristem-plant ecomeristem-culm ecomeristem-leaf
  ecomeristem-plant-stock ecomeristem-plant-thermal-time)

INSTALL(TARGETS ecomeristem-plant DESTINATION lib)

ADD_SUBDIRECTORY(assimilation)
ADD_SUBDIRECTORY(stock)
ADD_SUBDIRECTORY(thermal-time)
ADD_SUBDIRECTORY(water-balance)
INCLUDE_DIRECTORIES(
  ${CMAKE_SOURCE_DIR}/src ${ARTIS_INCLUDE_DIRS})

LINK_DIRECTORIES(${ARTIS_LIBRARY_DIRS})

SET(ECOMERISTEM_PLANT_THERMAL_TIME_HPP DD.hpp DeltaT.hpp IH.hpp LiguloVisu.hpp
  Model.hpp PhenoStage.hpp PlastoVisu.hpp ThermalTimeManager.hpp TT.hpp
  TT_lig.hpp)

SET(ECOMERISTEM_PLANT_THERMAL_TIME_CPP Model.cpp)

ADD_LIBRARY(ecomeristem-plant-thermal-time SHARED ${ECOMERISTEM_PLANT_THERMAL_TIME_HPP} ${ECOMERISTEM_PLANT_THERMAL_TIME_CPP})
TARGET_LINK_LIBRARIES(ecomeristem-plant-thermal-time)

INSTALL(TARGETS ecomeristem-plant-thermal-time DESTINATION lib)

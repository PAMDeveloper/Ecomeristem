INCLUDE_DIRECTORIES(
  ${CMAKE_SOURCE_DIR}/src ${ARTIS_INCLUDE_DIRS})

LINK_DIRECTORIES(${ARTIS_LIBRARY_DIRS})

SET(ECOMERISTEM_PLANT_STOCK_HPP DayDemand.hpp IndexCompetition.hpp Model.hpp
  ReservoirDispo.hpp SeedRes.hpp Stock.hpp Supply.hpp Surplus.hpp)

SET(ECOMERISTEM_PLANT_STOCK_CPP Model.cpp)

ADD_LIBRARY(ecomeristem-plant-stock SHARED ${ECOMERISTEM_PLANT_STOCK_HPP} ${ECOMERISTEM_PLANT_STOCK_CPP})
TARGET_LINK_LIBRARIES(ecomeristem-plant-stock)

INSTALL(TARGETS ecomeristem-plant-stock DESTINATION lib)

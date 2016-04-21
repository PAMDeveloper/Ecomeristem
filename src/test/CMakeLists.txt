INCLUDE_DIRECTORIES(
  ${CMAKE_SOURCE_DIR}/src
  ${ECOMERISTEM_INCLUDE_DIRS}
  ${Boost_INCLUDE_DIRS})

LINK_DIRECTORIES()

ADD_EXECUTABLE(ecomeristem-tests test.cpp)

TARGET_LINK_LIBRARIES(ecomeristem-tests ecomeristem-core ecomeristem-kernel
  ecomeristem-models-meteo ecomeristem-observer ecomeristem-plant
  ecomeristem-utils ${Boost_LIBRARIES} pqxx)

INSTALL(TARGETS ecomeristem-tests DESTINATION bin)

ADD_EXECUTABLE(ecomeristem-bilan-tests test-bilan.cpp)

TARGET_LINK_LIBRARIES(ecomeristem-bilan-tests ecomeristem-core
  ecomeristem-kernel ecomeristem-models-meteo ecomeristem-observer
  ecomeristem-plant ecomeristem-utils ${Boost_LIBRARIES} pqxx)

INSTALL(TARGETS ecomeristem-bilan-tests DESTINATION bin)

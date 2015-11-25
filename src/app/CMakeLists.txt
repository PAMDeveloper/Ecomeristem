INCLUDE_DIRECTORIES(
  ${Ecomeristem_BINARY_DIR}/src
  ${Ecomeristem_SOURCE_DIR}/src
  ${Boost_INCLUDE_DIRS})

LINK_DIRECTORIES(${Boost_LIBRARY_DIRS})

ADD_EXECUTABLE(ecomeristem main.cpp)
SET_TARGET_PROPERTIES(ecomeristem PROPERTIES ${ECOMERISTEM_APP_PROPERTIES})

TARGET_LINK_LIBRARIES(ecomeristem ecomeristem-kernel ecomeristem-leaf
  ecomeristem-models-meteo ecomeristem-observer ecomeristem-plant
  ecomeristem-utils ${Boost_LIBRARIES} pqxx)

INSTALL(TARGETS ecomeristem DESTINATION bin)

INCLUDE_DIRECTORIES(
  ${CMAKE_SOURCE_DIR}/src)

LINK_DIRECTORIES()

SET(ECOMERISTEM_KERNEL_HPP AbstractAtomicModel.hpp AbstractCoupledModel.hpp
  AbstractModel.hpp Simulator.hpp Model.hpp)

SET(ECOMERISTEM_KERNEL_CPP Simulator.cpp Model.cpp)

ADD_LIBRARY(ecomeristem-kernel SHARED ${ECOMERISTEM_KERNEL_HPP}
  ${ECOMERISTEM_KERNEL_CPP})
TARGET_LINK_LIBRARIES(ecomeristem-kernel)

INSTALL(TARGETS ecomeristem-kernel DESTINATION lib)

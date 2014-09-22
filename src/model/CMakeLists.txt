CONFIGURE_FILE(version.hpp.in ${Ecomeristem_BINARY_DIR}/src/ecomeristem/version.hpp)

ADD_SUBDIRECTORY(kernel)
ADD_SUBDIRECTORY(models)
ADD_SUBDIRECTORY(observer)
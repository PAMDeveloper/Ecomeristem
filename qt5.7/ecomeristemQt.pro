#-------------------------------------------------
#
# Project created by QtCreator 2016-10-07T09:36:22
#
#-------------------------------------------------

QT       += core gui charts
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

#CONFIG += object_parallel_to_source no_batch

TARGET = ecomeristemQt
TEMPLATE = app

#CONFIG(debug, debug|release) {
#    QMAKE_CXXFLAGS += -bigobj
#} else {

#}

INCLUDEPATH +=  ../src \
                ../../artis/src \
                ../../../Lib/boost_1_62_0 \
                ../../../Lib/postgresql-9.6.1/include


CODEGENERATION =
#CODEGENERATION = _MT
PLATFORM_SUF = x64
#PLATFORM_SUF = win32
#!contains(QMAKE_TARGET.arch, x86_64) {}
CONFIGURATION = _Release
CONFIG(debug, debug|release) {
    CONFIGURATION = _Debug
}

#LIBPATH     +=  D:/Lib/boost_1_62_0/lib32-msvc-14.0
LIBPATH     +=  D:/Lib/boost_1_62_0/lib64-msvc-14.0

LIBPATH += D:/Lib/ecomeristem \
           D:/Lib/artis \
           D:/Lib/postgresql-9.6.1/lib/$${PLATFORM_SUF}

message($$LIBPATH)
LIBS += -lEcomeristem$${CODEGENERATION}_$${PLATFORM_SUF}$${CONFIGURATION} \
        -lartis$${CODEGENERATION}_$${PLATFORM_SUF}$${CONFIGURATION}

CONFIG(debug, debug|release) {
    LIBS += -llibpq$${CODEGENERATION}d
} else {
    LIBS += -llibpq$${CODEGENERATION}
}

LIBS += -lsecur32 -lws2_32 -lAdvapi32

message($$LIBS)

DEFINES += ECOMERISTEMQT_LIBRARY

SOURCES += main.cpp\
    mainwindow.cpp \
    graphView.cpp \
    meteodatamodel.cpp \
    parametersdatamodel.cpp

HEADERS += mainwindow.h \
    graphView.h \
    meteodatamodel.h \
    parametersdatamodel.h

FORMS    += mainwindow.ui

unix {
    target.path = /usr/lib
    INSTALLS += target
}

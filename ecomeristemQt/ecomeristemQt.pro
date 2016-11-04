#-------------------------------------------------
#
# Project created by QtCreator 2016-10-07T09:36:22
#
#-------------------------------------------------

QT       += core gui charts
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += object_parallel_to_source no_batch

TARGET = ecomeristemQt
TEMPLATE = app

CONFIG(debug, debug|release) {
    QMAKE_CXXFLAGS += -bigobj
} else {

}



INCLUDEPATH +=  ../src \
                ../../artis/src \
                ../../../Lib/boost_1_61_0 \
                ../../../Lib/pgsql/include
#\
#                ../../OGDF/include

LIBPATH     +=  ../../../Lib/boost_1_61_0/lib64-msvc-14.0 \
                ../../../Lib/pgsql/lib

#CONFIG(debug, debug|release) {
#    LIBPATH += ../../../Lib/OGDF/debug
#} else {
#    LIBPATH += ../../../Lib/OGDF/release
#}

LIBS        += -llibpq
#-logdf -lcoin

DEFINES += ECOMERISTEMQT_LIBRARY

SOURCES += main.cpp\
    mainwindow.cpp \
    ../src/model/kernel/Model.cpp \
    ../src/model/kernel/Simulator.cpp \
    ../src/model/models/ecomeristem/culm/Model.cpp \
    ../src/model/models/ecomeristem/internode/Model.cpp \
    ../src/model/models/ecomeristem/leaf/Model.cpp \
    ../src/model/models/ecomeristem/panicle/Model.cpp \
    ../src/model/models/ecomeristem/peduncle/Model.cpp \
    ../src/model/models/ecomeristem/phytomer/Model.cpp \
    ../src/model/models/ecomeristem/plant/assimilation/Model.cpp \
    ../src/model/models/ecomeristem/plant/stock/Model.cpp \
    ../src/model/models/ecomeristem/plant/thermal-time/Model.cpp \
    ../src/model/models/ecomeristem/plant/water-balance/Model.cpp \
    ../src/model/models/ecomeristem/plant/Manager.cpp \
    ../src/model/models/ecomeristem/plant/Model.cpp \
    ../src/model/models/ecomeristem/root/Model.cpp \
    ../src/model/models/ecomeristem/Model.cpp \
    ../src/model/models/meteo/Meteo.cpp \
    ../src/model/models/ModelParameters.cpp \
    ../src/model/observer/View.cpp \
    ../src/utils/Connections.cpp \
    ../src/utils/ParametersReader.cpp \
    ../src/utils/Trace.cpp \
    graphView.cpp

HEADERS += mainwindow.h \
    ../src/ecomeristem/version.hpp \
    ../src/model/kernel/AbstractAtomicModel.hpp \
    ../src/model/kernel/AbstractCoupledModel.hpp \
    ../src/model/kernel/Model.hpp \
    ../src/model/kernel/Simulator.hpp \
    ../src/model/models/ecomeristem/culm/Deficit.hpp \
    ../src/model/models/ecomeristem/culm/Intermediate.hpp \
    ../src/model/models/ecomeristem/culm/MaxReservoirDispo.hpp \
    ../src/model/models/ecomeristem/culm/Model.hpp \
    ../src/model/models/ecomeristem/culm/Stock.hpp \
    ../src/model/models/ecomeristem/culm/Supply.hpp \
    ../src/model/models/ecomeristem/culm/Surplus.hpp \
    ../src/model/models/ecomeristem/internode/Biomass.hpp \
    ../src/model/models/ecomeristem/internode/DiameterPredim.hpp \
    ../src/model/models/ecomeristem/internode/ExpTime.hpp \
    ../src/model/models/ecomeristem/internode/INER.hpp \
    ../src/model/models/ecomeristem/internode/InternodeDemand.hpp \
    ../src/model/models/ecomeristem/internode/LastDemand.hpp \
    ../src/model/models/ecomeristem/internode/Len.hpp \
    ../src/model/models/ecomeristem/internode/Manager.hpp \
    ../src/model/models/ecomeristem/internode/Model.hpp \
    ../src/model/models/ecomeristem/internode/Predim.hpp \
    ../src/model/models/ecomeristem/internode/ReductionINER.hpp \
    ../src/model/models/ecomeristem/internode/TimeFromApp.hpp \
    ../src/model/models/ecomeristem/internode/Volume.hpp \
    ../src/model/models/ecomeristem/leaf/Biomass.hpp \
    ../src/model/models/ecomeristem/leaf/BladeArea.hpp \
    ../src/model/models/ecomeristem/leaf/ExpTime.hpp \
    ../src/model/models/ecomeristem/leaf/LastDemand.hpp \
    ../src/model/models/ecomeristem/leaf/LeafDemand.hpp \
    ../src/model/models/ecomeristem/leaf/Len.hpp \
    ../src/model/models/ecomeristem/leaf/LER.hpp \
    ../src/model/models/ecomeristem/leaf/LifeSpan.hpp \
    ../src/model/models/ecomeristem/leaf/Manager.hpp \
    ../src/model/models/ecomeristem/leaf/Model.hpp \
    ../src/model/models/ecomeristem/leaf/PlastoDelay.hpp \
    ../src/model/models/ecomeristem/leaf/Predim.hpp \
    ../src/model/models/ecomeristem/leaf/ReductionLER.hpp \
    ../src/model/models/ecomeristem/leaf/ThermalTimeSinceLigulation.hpp \
    ../src/model/models/ecomeristem/leaf/TimeFromApp.hpp \
    ../src/model/models/ecomeristem/leaf/Width.hpp \
    ../src/model/models/ecomeristem/panicle/Model.hpp \
    ../src/model/models/ecomeristem/peduncle/Model.hpp \
    ../src/model/models/ecomeristem/phytomer/Model.hpp \
    ../src/model/models/ecomeristem/plant/assimilation/Assim.hpp \
    ../src/model/models/ecomeristem/plant/assimilation/AssimPot.hpp \
    ../src/model/models/ecomeristem/plant/assimilation/Interc.hpp \
    ../src/model/models/ecomeristem/plant/assimilation/Lai.hpp \
    ../src/model/models/ecomeristem/plant/assimilation/Model.hpp \
    ../src/model/models/ecomeristem/plant/assimilation/RespMaint.hpp \
    ../src/model/models/ecomeristem/plant/stock/DayDemand.hpp \
    ../src/model/models/ecomeristem/plant/stock/IndexCompetition.hpp \
    ../src/model/models/ecomeristem/plant/stock/Model.hpp \
    ../src/model/models/ecomeristem/plant/stock/ReservoirDispo.hpp \
    ../src/model/models/ecomeristem/plant/stock/SeedRes.hpp \
    ../src/model/models/ecomeristem/plant/stock/Stock.hpp \
    ../src/model/models/ecomeristem/plant/stock/Supply.hpp \
    ../src/model/models/ecomeristem/plant/stock/Surplus.hpp \
    ../src/model/models/ecomeristem/plant/thermal-time/DD.hpp \
    ../src/model/models/ecomeristem/plant/thermal-time/DeltaT.hpp \
    ../src/model/models/ecomeristem/plant/thermal-time/IH.hpp \
    ../src/model/models/ecomeristem/plant/thermal-time/LiguloVisu.hpp \
    ../src/model/models/ecomeristem/plant/thermal-time/Model.hpp \
    ../src/model/models/ecomeristem/plant/thermal-time/PhenoStage.hpp \
    ../src/model/models/ecomeristem/plant/thermal-time/PlastoVisu.hpp \
    ../src/model/models/ecomeristem/plant/thermal-time/ThermalTimeManager.hpp \
    ../src/model/models/ecomeristem/plant/thermal-time/TT.hpp \
    ../src/model/models/ecomeristem/plant/thermal-time/TT_lig.hpp \
    ../src/model/models/ecomeristem/plant/water-balance/cstr.hpp \
    ../src/model/models/ecomeristem/plant/water-balance/fcstr.hpp \
    ../src/model/models/ecomeristem/plant/water-balance/FTSW.hpp \
    ../src/model/models/ecomeristem/plant/water-balance/Model.hpp \
    ../src/model/models/ecomeristem/plant/water-balance/SWC.hpp \
    ../src/model/models/ecomeristem/plant/water-balance/transpiration.hpp \
    ../src/model/models/ecomeristem/plant/Lig.hpp \
    ../src/model/models/ecomeristem/plant/Manager.hpp \
    ../src/model/models/ecomeristem/plant/Model.hpp \
    ../src/model/models/ecomeristem/plant/SLA.hpp \
    ../src/model/models/ecomeristem/plant/TillerManager.hpp \
    ../src/model/models/ecomeristem/root/Model.hpp \
    ../src/model/models/ecomeristem/root/RootDemand.hpp \
    ../src/model/models/ecomeristem/root/RootDemandCoef.hpp \
    ../src/model/models/ecomeristem/root/RootManager.hpp \
    ../src/model/models/ecomeristem/Model.hpp \
    ../src/model/models/meteo/Meteo.hpp \
    ../src/model/models/ModelParameters.hpp \
    ../src/model/observer/PlantView.hpp \
    ../src/model/observer/View.hpp \
    ../src/model/version.hpp.in \
    ../src/utils/Connections.hpp \
    ../src/utils/DateTime.hpp \
    ../src/utils/Exception.hpp \
    ../src/utils/ParametersReader.hpp \
    ../src/utils/Trace.hpp \
    graphView.h

FORMS    += mainwindow.ui

unix {
    target.path = /usr/lib
    INSTALLS += target
}

DISTFILES +=

#include "mainwindow.h"
#include <QApplication>


//#include <boost/program_options.hpp>
//#include <boost/property_tree/ptree.hpp>
//#include <boost/property_tree/xml_parser.hpp>
//#include <boost/foreach.hpp>
//#include <boost/format.hpp>

//#include <ecomeristem/version.hpp>

#include <utils/ParametersReader.hpp>
#include <model/models/ModelParameters.hpp>

#include <model/kernel/Model.hpp>
#include <model/kernel/Simulator.hpp>

#include <utils/DateTime.hpp>


#include <iostream>
#include <iso646.h>


int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    std::string simulation;
//    setlocale(LC_ALL, "C");

    simulation = "sim_rice";
    model::models::ModelParameters parameters;
    utils::ParametersReader reader;
    reader.loadParametersFromProstgresql(simulation, parameters);
    w.run(simulation, parameters, 0);
    std::cout << "Simulation done." << std::endl;

    return a.exec();
}

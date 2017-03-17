#include "mainwindow.h"
#include <QApplication>

//#define WITH_TRACE
//#include <boost/program_options.hpp>
//#include <boost/property_tree/ptree.hpp>
//#include <boost/property_tree/xml_parser.hpp>
//#include <boost/foreach.hpp>
//#include <boost/format.hpp>

//#include <ecomeristem/version.hpp>




#include <iostream>
#include <iso646.h>


int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();


//    MainWindow ww;
//    ww.show();
//    reader.loadParametersFromFiles("d:/Output", parameters);
//    std::cout << "Simulation loaded. Starting." << std::endl;
//    ww.run(simulation, parameters, 0);
//    std::cout << "Simulation done." << std::endl;

//    MainWindow www;
//    www.show();
//    reader.loadParametersFromProstgresql(simulation, parameters);
//    std::cout << "Simulation loaded. Starting." << std::endl;
//    www.run(simulation, parameters, 0);
//    std::cout << "Simulation done." << std::endl;

    return a.exec();
}

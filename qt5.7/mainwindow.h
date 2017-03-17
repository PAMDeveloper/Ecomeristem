#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <model/kernel/KernelModel.hpp>
#include <model/kernel/Simulator.hpp>
#include <QtCharts/QLineSeries>
#include <QtCharts/QSplineSeries>
#include <QGridLayout>

#include <model/observer/View.hpp>
#include <model/observer/PlantView.hpp>
#include <utils/ParametersReader.hpp>
#include <model/models/ModelParameters.hpp>

#include <utils/DateTime.hpp>

#include "graphView.h"
#include <QMouseEvent>
#include <QDate>

QT_CHARTS_USE_NAMESPACE
using namespace model;

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

    void run(const std::string& simulation, const model::models::ModelParameters &parameters, int /* verbose */);
    void displayData(observer::PlantView * view, QString begin, QString end);
    void addChart(int row, int col, QLineSeries * series, QGridLayout * lay, QString name);
    void displayGraph();
    void mousePressEvent(QMouseEvent * event);


private slots:
    void on_loadSimulationFileBtn_clicked();

    void on_loadMeteoFileBtn_clicked();

    void on_launchSimulationButton_clicked();

    void on_testLoadButton_clicked();

private:
    model::models::ModelParameters parameters;
    utils::ParametersReader reader;
    std::string simulation;

    Ui::MainWindow *ui;
    GraphView * graph;
    QDate currentDate;
    QDate startDate;
};

#endif // MAINWINDOW_H

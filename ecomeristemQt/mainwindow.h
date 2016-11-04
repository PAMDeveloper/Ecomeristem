#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <model/kernel/Model.hpp>
#include <model/kernel/Simulator.hpp>
#include <QtCharts/QLineSeries>
#include <QtCharts/QSplineSeries>
#include <QGridLayout>

#include <model/observer/View.hpp>
#include <model/observer/PlantView.hpp>
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

private:
    Ui::MainWindow *ui;
    GraphView * graph;
    QDate currentDate;
    QDate startDate;
};

#endif // MAINWINDOW_H

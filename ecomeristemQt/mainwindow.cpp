#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QtCharts/QChartView>
#include <QtCore/QDateTime>
#include <QtCharts/QDateTimeAxis>
#include <QtCore/QFile>
#include <QtCore/QTextStream>
#include <QtCore/QDebug>
#include <QtCharts/QValueAxis>
#include <QtCore/qmath.h>

#include <QDebug>

QT_CHARTS_USE_NAMESPACE

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

static void format_dates(const model::models::ModelParameters& parameters,
                         std::string& begin, std::string& end)
{
    utils::DateTime::format_date(parameters.get < std::string >("BeginDate"),
                                 begin);
    utils::DateTime::format_date(parameters.get < std::string >("EndDate"),
                                 end);
}

void MainWindow::run(const std::string& simulation, const model::models::ModelParameters &parameters, int /* verbose */)
{
    ecomeristem::GlobalParameters globalParameters;
    kernel::Model* model = new kernel::Model;
    kernel::Simulator simulator(model, globalParameters);
    std::string begin;
    std::string end;


    format_dates(parameters, begin, end);
    observer::PlantView * view = new observer::PlantView();
    simulator.attachView("plant", view);
    simulator.init(utils::DateTime::toJulianDayNumber(begin), parameters);
    simulator.run(utils::DateTime::toJulianDayNumber(begin),
                  utils::DateTime::toJulianDayNumber(end));


    displayData(view, QString::fromStdString(begin), QString::fromStdString(end));
}

void MainWindow::addChart(int row, int col, QLineSeries *series, QGridLayout * lay, QString name){
    QChart *chart = new QChart();
    chart->addSeries(series);
    chart->legend()->hide();
    chart->setTitle(name);

    QDateTimeAxis *axisX = new QDateTimeAxis;
    axisX->setTickCount(10);
    axisX->setFormat("dd-MM");
    axisX->setTitleText("Date");
    chart->addAxis(axisX, Qt::AlignBottom);
    series->attachAxis(axisX);

    QValueAxis *axisY = new QValueAxis;
    axisY->setLabelFormat("%i");
    axisY->setTitleText("Value");
    chart->addAxis(axisY, Qt::AlignLeft);
    series->attachAxis(axisY);

    QChartView *chartView = new QChartView(chart);
    chartView->setMaximumHeight(150);
    chartView->setRubberBand(QChartView::RectangleRubberBand);
    chartView->setRenderHint(QPainter::Antialiasing);

    lay->addWidget(chartView, row, col);
}


QColor getColor(int i){
    double PHI = (1 + qSqrt(5))/2;
    double n = i * PHI - floor(i * PHI);
    int h = qFloor(n * 256);
   return QColor::fromHsv(h, 245, 245, 255);
}

void MainWindow::displayData(observer::PlantView * view, QString begin, QString end){

    QScrollArea *scrollArea = new QScrollArea;
    QWidget *client = new QWidget();
    scrollArea->setWidget(client);
    scrollArea->setWidgetResizable(true);

    QGridLayout * lay = new QGridLayout();
    client->setLayout(lay);
    lay->setSpacing(0);
    setCentralWidget(scrollArea);

    QDate startDate = QDate::fromString(begin, Qt::ISODate);
    QDate endDate = QDate::fromString(end, Qt::ISODate);
    qDebug() << startDate << endDate;
    const int numCol = 3;

    QStringList params;
    params  <<"Plant:DD"
            <<"Plant:EDD"
            <<"Plant:IH"
            <<"Plant:LIGULO_VISU"
            <<"Plant:PHENO_STAGE"
            <<"Plant:PLASTO_VISU"
            <<"Plant:TT"
            <<"Plant:TT_LIG"
            <<"Plant:CSTR"
            <<"Plant:ASSIM"
            <<"Plant:SUPPLY"
            <<"Plant:IC"
            <<"Plant:STOCK"
            <<"Plant:SURPLUS"
            <<"Plant:DEFICIT"
            <<"Plant:RESERVOIR_DISPO"
            <<"Plant:DAY_DEMAND"
            <<"Plant:SEED_RES"
            <<"Plant:ROOT_DEMAND_COEF"
            <<"Plant:ROOT_BIOMASS"
            <<"Plant:ROOT_DEMAND"
            <<"Plant:SLA"
            <<"Plant:LEAF_BIOMASS_SUM"
            <<"Plant:INTERNODE_BIOMASS_SUM"
            <<"Plant:SENESC_DW_SUM"
            <<"Plant:LEAF_LAST_DEMAND_SUM"
            <<"Plant:INTERNODE_LAST_DEMAND_SUM"
            <<"Plant:LEAF_DEMAND_SUM"
            <<"Plant:INTERNODE_DEMAND_SUM";

    for (int j = 0; j < params.length(); ++j) {
        QLineSeries *series = new QLineSeries();
        series->setColor(getColor(j));
        for (int i = 0; i < startDate.daysTo(endDate); ++i) {
            double value = view->get(startDate.addDays(i).toJulianDay(),
                                    params.at(j).toLocal8Bit().constData());
            QDateTime momentInTime;
            momentInTime.setDate(startDate.addDays(i));
            series->append(momentInTime.toMSecsSinceEpoch(), value);
        }
        addChart(j/numCol,j%numCol,series,lay, params.at(j).mid(6));
    }


}

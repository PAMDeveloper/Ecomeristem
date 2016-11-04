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
#include <QMap>
#include <QDesktopWidget>
#include <QVBoxLayout>
#include <QTabWidget>


#include <QDebug>

QT_CHARTS_USE_NAMESPACE

//using namespace ogdf;

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
//    showFullScreen();
    auto const desktop(QApplication::desktop());
    setGeometry(desktop->screenGeometry(2).adjusted(0,30,0,-50));
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

    qDebug() << "Simulation done.";
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
    //    axisX->setTitleText("Date");
    chart->addAxis(axisX, Qt::AlignBottom);
    series->attachAxis(axisX);

    QValueAxis *axisY = new QValueAxis;
    axisY->setLabelFormat("%i");
    //    axisY->setTitleText("Value");
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
    //setCentralWidget(scrollArea);
    QTabWidget * tabs = new QTabWidget();
    tabs->addTab(scrollArea, "Values");
    setCentralWidget(tabs);



    startDate = QDate::fromString(begin, Qt::ISODate);
    QDate endDate = QDate::fromString(end, Qt::ISODate);
    currentDate = startDate;
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

    graph = new GraphView();
    tabs->addTab(graph, "Graph");
    //    std::ofstream out("trace.txt");
    //    out << utils::Trace::trace().elements()
    //           .filter_time(startDate.addDays(20).toJulianDay())
    //           .filter_type(artis::utils::KERNEL)
    //           .to_string();
    //    out.close();
    displayGraph();
}

void MainWindow::mousePressEvent(QMouseEvent * event)
    {
/*      if(event->button() == Qt::LeftButton)
      {
          currentDate = currentDate.addDays(-1);
//        msgBox = new QMessageBox();
//        msgBox->setWindowTitle("Hello");
//        msgBox->setText("You Clicked Left Mouse Button");
//        msgBox->show();
      } else*/ if(event->button() == Qt::RightButton){
          currentDate = currentDate.addDays(1);
          displayGraph();
      }
    }


void MainWindow::displayGraph(){
    graph->clear();
    auto elements = utils::Trace::trace().elements()
            .filter_time(currentDate.toJulianDay())
            .filter_type(artis::utils::KERNEL);

    qDebug() << currentDate.toString() << ": day" << startDate.daysTo(currentDate) << " - " << elements.size()/2 << "steps";
    QString previousNodeName = "";
    bool lastIsBefore = false;

//    qDebug() << "Starting parsing" << elements.size();
    foreach (auto elt, elements) {
        QString name = QString::fromStdString(elt.get_comment());
        name = name.replace("class model::kernel::Model/", "");
        name = name.replace("class ecomeristem::", "");
        name = name.replace("class ", "");
        name = name.replace("model::kernel", "");
        name = name.replace("::Model", "");
        name = name.replace("Model", "");

        if(name.startsWith(" - BEFORE - ")){
            name = name.replace(" - BEFORE - ", "");
            if(lastIsBefore && previousNodeName != name && !previousNodeName.isEmpty()){
//                qDebug() << "AddCluster" << previousNodeName;
            }

            lastIsBefore = true;
        } else {
            name = name.replace(" - AFTER - ", "");
            if(previousNodeName == name) {
                QStringList clusterNames = name.split("/");
                QString nodeName = clusterNames.last();
                clusterNames.pop_back();
                QString clusterName = clusterNames.join("/");
//                qDebug() << "AddNode" << nodeName << "of cluster" << clusterName;
                graph->addComputeNode(nodeName, clusterName);

            } else {
//                qDebug() << "CloseCluster" << name;
            }
            lastIsBefore = false;
        }
        previousNodeName = name;

        //        name = name.replace("ecomeristem::", "");
        //        name = name.replace("ecomeristem", "");
        //        qDebug() << name;
    }
}


//auto elements = utils::Trace::trace().elements()
//        .filter_time(startDate.addDays(32).toJulianDay())
//        .filter_type(artis::utils::KERNEL);

//QString previousNodeName = "";
//bool lastIsBefore = false;
//QList<ClusterElement*> clusters;
//node lastNode = NULL;
//QMap <QString, ClusterElement*> clusterMap;
//QFont font("Arial", 9);;
//QFontMetrics fm(font);

//qDebug() << "Starting parsing" << elements.size();

//foreach (auto elt, elements) {
//    QString name = QString::fromStdString(elt.get_comment());
////        qDebug() << name;
//    name = name.replace("class model::kernel::Model/", "");
//    name = name.replace("class ecomeristem::", "");
//    name = name.replace("class ", "");
//    name = name.replace("model::kernel", "");
//    name = name.replace("::Model", "");
//    name = name.replace("Model", "");

//    if(name.startsWith(" - BEFORE - ")){
//        name = name.replace(" - BEFORE - ", "");
//        if(lastIsBefore && previousNodeName != name && !previousNodeName.isEmpty()){
//            qDebug() << "AddCluster" << previousNodeName;
//            ClusterElement * cluster = graph->newCluster(clusters.isEmpty() ? NULL : clusters.last());
//            clusters.append(cluster);
//            clusterMap.insert(previousNodeName, cluster);
//        }

//        lastIsBefore = true;
//    } else {
//        name = name.replace(" - AFTER - ", "");
//        if(previousNodeName == name) {
//            QStringList clusterNames = name.split("/");
//            clusterNames.pop_back();
//            QString lastCluster = "";
//            while(!clusterNames.isEmpty()){
//                QString clusterName = clusterNames.join("/");
//                if(!clusterMap.keys().contains(clusterNames.join("/"))){
//                    qDebug() << "ADD CONSTRUCTEUR CLUSTER" << clusterName;
//                    if(lastCluster.isEmpty())
//                        clusterMap.insert(clusterName, graph->newCluster());
//                    else
//                        clusterMap.insert(clusterName, graph->newCluster(clusterMap[lastCluster]));
//                }
//                lastCluster = clusterName;
//                clusterNames.pop_back();
//            }

//            clusterNames = name.split("/");
//            QString nodeName = clusterNames.last();
//            int width= fm.width(nodeName.split(":").last()) * 1.4;
//            node n = graph->addNode(QSize(width, 20), nodeName.split(":").last());
//            clusterNames.pop_back();
//            if(!clusterNames.isEmpty()){
//                 graph->addNodeToCluster(n, clusterMap[clusterNames.join("/")]);
//                 qDebug() << "ADD Node" << nodeName << "to CLUSTER" << clusterNames.join("/");
//            }
//            if(lastNode != NULL)
//                graph->addEdge(lastNode, n);
//            lastNode = n;
//        } else {
//            qDebug() << "CloseCluster" << name;
//            clusters.pop_back();
//        }
//        lastIsBefore = false;
//    }
//    previousNodeName = name;

//    //        name = name.replace("ecomeristem::", "");
//    //        name = name.replace("ecomeristem", "");
//    //        qDebug() << name;
//}
//qDebug() << clusterMap.keys();
//graph->layoutGraph();

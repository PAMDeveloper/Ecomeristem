#include <QRectF>
#include <QGraphicsScene>
#include <QBrush>
#include <QPen>
#include <QPointF>
#include <QPainterPath>
#include <QGraphicsEllipseItem>
#include <QGraphicsSimpleTextItem>
#include <QString>
#include <QLineF>
#include <QPolygonF>
#include <QDebug>

#include "graphView.h"

//using namespace ogdf;

GraphView::GraphView(QWidget* parent) :
    QGraphicsView(parent)
{
    h11 = 1.0;
    h22 = 1.0;
    lastCluster = "";
    lastColumn = QPoint(0,0);
    lastMaxWidth = 0;

//    graph_ = new Graph();
//    //    GA_ = new GraphAttributes(*graph_,
//    //                              GraphAttributes::nodeGraphics | GraphAttributes::edgeGraphics);

//    clusterGraph_ = new ClusterGraph(*graph_);
//    GA_ = new ClusterGraphAttributes(*clusterGraph_,
//                                     GraphAttributes::nodeGraphics |
//                                     GraphAttributes::edgeGraphics |
//                                     GraphAttributes::nodeLabel);

    scene_ = new QGraphicsScene(this);
    scene_->setBackgroundBrush(QBrush(QColor("white")));

    setScene(scene_);

    setRenderHint(QPainter::Antialiasing);

}


void GraphView::clear(){
    h11 = 1.0;
    h22 = 1.0;
    lastCluster = "";
    lastColumn = QPoint(0,0);
    lastMaxWidth = 0;
    scene_->clear();
}

void GraphView::addComputeNode(const QString& label, QString cluster)
{
    QFont font("Arial", 9);
    QFontMetrics fm(font);
    QString nodeTitle = label.split(":").last();
    QRectF textRect = fm.boundingRect(nodeTitle);


    if(cluster != lastCluster/* || cluster == ""*/) {
        lastCluster = cluster;
        qreal newColX = lastColumn.x() + 200;
        textRect.moveLeft(newColX - textRect.width()/2);
        lastColumn.setX(newColX);
        lastColumn.setY(0);
        lastMaxWidth = textRect.width();

//        if(cluster == ""){
//            cluster = "Global";
//        }
        //PutClusterTitle
        QStringList clusters = cluster.split("/");
        QRectF titleRect(textRect);
        qreal titleHeight = textRect.height()*clusters.size()*1.1;
        titleRect.moveTop(- titleHeight - textRect.height() -10);
        titleRect.setHeight(titleHeight);
        QGraphicsRectItem* rt = scene_->addRect(titleRect.adjusted(-2,-2,2,2), QPen(QColor("white")));
        for (int i = 0; i < clusters.size(); ++i) {
            qreal titleW = fm.width(clusters[i]);
            if(rt->rect().width() < titleW){
                rt->setRect(lastColumn.x() - titleW/2 - 2, titleRect.y(), titleW+4, titleRect.height());
            }
            QGraphicsSimpleTextItem* newLabel = new QGraphicsSimpleTextItem(clusters[i]);
            newLabel->setBrush(QColor("black"));
            font.setBold(true);
            newLabel->setFont(font);
            newLabel->setParentItem(rt);
            newLabel->setPos(titleRect.center().x() - titleW/2, titleRect.y() + (textRect.height() * i * 1.1) - textRect.height()/2);
        }

    } else {
        if(lastColumn != QPoint()){
            qreal nodeY = lastColumn.y() + textRect.height() * 2;
            textRect.moveTop(nodeY);
            textRect.moveLeft(lastColumn.x() - textRect.width()/2);
            lastColumn.setY(nodeY);
        }
    }

    //faire la fleche
    QGraphicsRectItem* ri = scene_->addRect(textRect.adjusted(-2,-2,2,2), QPen(QColor("white")));
    QGraphicsSimpleTextItem* newLabel = new QGraphicsSimpleTextItem(nodeTitle);
    newLabel->setBrush(QColor("black"));
    font.setBold(false);
    newLabel->setFont(font);
    newLabel->setParentItem(ri);
    newLabel->setPos(textRect.x(), textRect.y());
}



void GraphView::wheelEvent(QWheelEvent* event)
{
    const int degrees = event->delta() / 8;
    int steps = degrees / 15;
    double scaleFactor = 1.1;
    const qreal minFactor = 0.01;
    const qreal maxFactor = 10.0;
    if(steps > 0)
    {
        h11 = (h11 >= maxFactor) ? h11 : (h11 *scaleFactor);
        h22 = (h22 >= maxFactor) ? h22 : (h22 * scaleFactor);
    }
    else
    {
        h11 = (h11 <= minFactor) ? minFactor : (h11 / scaleFactor);
        h22 = (h22 <= minFactor) ? minFactor : (h22 / scaleFactor);
    }

    this->setTransformationAnchor(QGraphicsView::AnchorUnderMouse);
    this->setTransform(QTransform(h11, h12, h21, h22, 0, 0));
}

QPolygonF GraphView::createArrow(const QPointF& start, const QPointF& end)
{
    qreal Pi = 3.14;
    qreal arrowSize = 10;

    QPolygonF arrowHead;

    QLineF line(end, start);

    double angle = ::acos(line.dx() / line.length());

    if ( line.dy() >= 0 )
        angle = (Pi * 2) - angle;

    QPointF arrowP1 = line.p1() + QPointF(sin(angle+Pi/3)*arrowSize,
                                          cos(angle+Pi/3)*arrowSize);
    QPointF arrowP2 = line.p1() + QPointF(sin(angle+Pi-Pi/3)*arrowSize,
                                          cos(angle+Pi-Pi/3)*arrowSize);


    arrowHead.clear();
    arrowHead << line.p1() << arrowP1 << arrowP2;

    return arrowHead;
}

void GraphView::
drawArrow(const QPointF& start, const QPointF& end, const QColor& color)
{
    qreal Pi = 3.14;
    qreal arrowSize = 10;

    QPolygonF arrowHead;

    QLineF line(end, start);

    double angle = ::acos(line.dx() / line.length());

    if ( line.dy() >= 0 )
        angle = (Pi * 2) - angle;

    QPointF arrowP1 = line.p1() + QPointF(sin(angle+Pi/3)*arrowSize,
                                          cos(angle+Pi/3)*arrowSize);
    QPointF arrowP2 = line.p1() + QPointF(sin(angle+Pi-Pi/3)*arrowSize,
                                          cos(angle+Pi-Pi/3)*arrowSize);


    arrowHead.clear();
    arrowHead << line.p1() << arrowP1 << arrowP2;

    scene_->addPolygon(arrowHead, QPen(color), QBrush(color));

    scene_->addLine(line, QPen(color));
}


//ogdf::ClusterElement* GraphView::newCluster(ogdf::ClusterElement* parent){
//    if(clusterGraph_){
//        ClusterElement * cl = clusterGraph_->createEmptyCluster(parent);
//        clusterList_.append(cl);
//        return cl;
//    }
//    return NULL;
//}

//void GraphView::addNodeToCluster(const ogdf::node& node, const ogdf::cluster & cluster){
//    if(clusterGraph_){
//        clusterGraph_->reassignNode(node, cluster);
//    }
//}

//node GraphView::addNode(const QSize& size, const QString& label)
//{
//    qDebug() << "ADD NODE" << label;
//    node newNode = graph_->newNode();

//    GA_->width(newNode) = size.width();
//    GA_->height(newNode) = size.height();
//    GA_->label(newNode) = label.toStdString();
//    nodeList_.push_back(newNode);
//    return newNode;
//}

//void GraphView::addEdge(const ogdf::node& source,
//                        const ogdf::node& target)
//{
//    edge e = graph_->newEdge(source, target);

//    edgeList_.push_back(e);
//}


//void GraphView::layoutGraph()
//{
//    /////////////
////    MixedModelLayout MML;
////    MML.call(*GA_ );


//    //////////////
////    PlanarizationGridLayout MML;
////    MML.call(*GA_ );

//    //////////////
////    ClusterOrthoLayout layout;
////    ClusterPlanRep crep(*GA_, *clusterGraph_);


//    /////////////
//    //    ClusterPlanarizationLayout layout;
//    //    layout.call(*graph_, *GA_, *clusterGraph_);

//    ////////////
//    //    PlanarizationLayout pl;
//    //    OrthoLayout *ol = new OrthoLayout;
//    //    ol->separation(20.0);
//    //    ol->cOverhang(0.4);
//    //    pl.setPlanarLayouter(ol);
//    //    pl.call(*GA_);


//    ////////////////
//    //    SugiyamaLayout SL;
//    //    SL.setRanking(new OptimalRanking);
//    //    SL.setCrossMin(new MedianHeuristic);
//    //    OptimalHierarchyLayout *ohl = new OptimalHierarchyLayout;
//    //    ohl->layerDistance(30.0);
//    //    ohl->nodeDistance(25.0);
//    //    ohl->weightBalancing(0.8);
//    //    SL.setLayout(ohl);
//    //    SL.call(*GA_);

//    ///////
////        PlanarizationLayout pl;
////        SubgraphPlanarizer *crossMin = new SubgraphPlanarizer;
////        FastPlanarSubgraph *ps = new FastPlanarSubgraph;
////        ps->runs(100);
////        VariableEmbeddingInserter *ves = new VariableEmbeddingInserter;
////        ves->removeReinsert(rrAll);
////        crossMin->setSubgraph(ps);
////        crossMin->setInserter(ves);
////    //    EmbedderMinDepthMaxFaceLayers *emb = new EmbedderMinDepthMaxFaceLayers;
////    //    pl.setEmbedder(emb);
////        OrthoLayout *ol = new OrthoLayout;
////        ol->separation(20.0);
////        ol->cOverhang(0.4);
////        pl.setPlanarLayouter(ol);
////        pl.call(*GA_);


//    //
//    // Draw the nodes
//    //
//    for ( int idx=0; idx<nodeList_.size(); ++idx)
//    {
//        node n = nodeList_[idx];

//        double x = GA_->x(n);
//        double y = GA_->y(n);
//        double w = GA_->width(n);
//        double h = GA_->height(n);
//        QString label = QString::fromStdString(GA_->label(n));

//        QRectF rect(x-w/2, y-h/2, w, h);
        
//        QGraphicsRectItem* ri =
//                scene_->addRect(rect, QPen(QColor("green")));


////        QString ls = QString("N%1").arg(idx+1);

//        QGraphicsSimpleTextItem* newLabel =
//                new QGraphicsSimpleTextItem(label);
//        QRectF textRect = newLabel->boundingRect();
//        double newx = (w - textRect.width())/2;
//        double newy = (h - textRect.height())/2;

//        newLabel->setBrush(QColor("black"));
//        newLabel->setFont(QFont("Arial", 9));
//        newLabel->setParentItem(ri);
//        newLabel->setPos(x-w/2+newx, y-h/2+newy);
//    }

//    //
//    // Draw the edges
//    //
//    for ( int idx=0; idx<edgeList_.size(); ++idx)
//    {
//        edge e = edgeList_[idx];
//        DPolyline& points = GA_->bends(e);

//        List<DPoint>::const_iterator iter = points.begin();
//        if ( iter != points.end() )
//        {
//            QPointF startPoint((*iter).m_x, (*iter).m_y);
//            QPainterPath path(startPoint);

//            for ( ; iter != points.end(); ++iter )
//            {
//                DPoint dp = *iter;
//                QPointF nextPoint(dp.m_x, dp.m_y);
//                path.lineTo(nextPoint);
//            }

//            scene_->addPath(path, QPen(QColor("green")));

//            List<DPoint>::iterator arrowStartPoint =
//                    points.get(points.size() - 2);
//            List<DPoint>::iterator arrowEndPoint =
//                    points.get(points.size() - 1);

//            //QPolygonF arrow = createArrow(
//            //QPointF((*arrowStartPoint).m_x, (*arrowStartPoint).m_y),
//            //QPointF((*arrowEndPoint).m_x, (*arrowEndPoint).m_y));


//            //path.addPolygon(arrow);
//            drawArrow(
//                        QPointF((*arrowStartPoint).m_x, (*arrowStartPoint).m_y),
//                        QPointF((*arrowEndPoint).m_x, (*arrowEndPoint).m_y),
//                        QColor("green")
//                        );
            
//            //scene_->addPath(path, QPen(QColor("green")));

//            /*
//            QRectF epr(
//               (*endPoint).m_x-3,
//               (*endPoint).m_y-3,
//               6, 6);

//            scene_->addEllipse(epr, QPen(QColor("green")),
//                    QBrush(QColor("green")));
//            */

//        }
//    }

//    //
//    // Draw the clusters
//    //
//    int j = 0;
//    foreach (ClusterElement * cluster, clusterList_) {
//        ogdf::List<node> list;
//        cluster->getClusterNodes(list);
//        double x = 999999999;
//        double y = 999999999;
//        double z = 0;
//        double w = 0;
//        for (int i = 0; i < list.size(); ++i) {
//            node n = *(list.get(i));
//            if(GA_->x(n) < x)
//                x = GA_->x(n);
//            if(GA_->y(n) < y)
//                y = GA_->y(n);
//            if(GA_->x(n) + GA_->width(n) > z)
//                z = GA_->x(n) + GA_->width(n);
//            if(GA_->y(n) + GA_->height(n) > w)
//                w = GA_->y(n) + GA_->height(n);
//        }
//        QRectF rect(x - 30 - 10,y - 25 - 10,z-x + 20,w-y + 20);
//        //        scene_->addRect(rect, QPen(QColor("red")));
//        j++;
//    }

//}

//void GraphView::callLayout(ogdf::LayoutModule * layout){
//    try {
//        layout->call(*GA_);
//    } catch (ogdf::AlgorithmFailureException &e) {
//        QString reason = QString("of an unknown reason (%1)").arg(e.exceptionCode());
//        switch (e.exceptionCode()) {
//        case ogdf::afcUnknown:
//            // Do nothing.
//            break;
//        case ogdf::afcIllegalParameter:
//            reason = "of an illegal parameter";
//            break;
//        case ogdf::afcNoFlow:
//            reason = "min-cost flow solver could not find a legal flow";
//            break;
//        case ogdf::afcSort:
//            reason = "sequence is not sorted";
//            break;
//        case ogdf::afcLabel:
//            reason = "labelling failed";
//            break;
//        case ogdf::afcExternalFace:
//            reason = "external face is not correct";
//            break;
//        case ogdf::afcForbiddenCrossing:
//            reason = "crossing were forbidden";
//            break;
//        case ogdf::afcTimelimitExceeded:
//            reason = "timelimit exceeded";
//            break;
//        case ogdf::afcNoSolutionFound:
//            reason = "it could not find a solution";
//            break;
//        case ogdf::afcSTOP:
//            // Do nothing.
//            break;
//        }
//        qDebug()  << "Layout algorithm failed, because " << reason;
//    } catch (ogdf::PreconditionViolatedException &e) {
//        QString reason = QString("An unknown reason (%1)").arg(e.exceptionCode());
//        switch (e.exceptionCode()) {
//        case ogdf::pvcUnknown:
//            // Do nothing.
//            break;
//        case ogdf::pvcSelfLoop:
//            reason = "Graph contains a self-loop, which";
//            break;
//        case ogdf::pvcTreeHierarchies:
//            reason = "Graph is not a tree, which";
//            break;
//        case ogdf::pvcAcyclicHierarchies:
//            reason = "Graph is not acyclic, which";
//            break;
//        case ogdf::pvcSingleSource:
//            reason = "Graph has not a single source, which";
//            break;
//        case ogdf::pvcUpwardPlanar:
//            reason = "Graph is not upward planar, which";
//            break;
//        case ogdf::pvcTree:
//            reason = "Graph is not a rooted tree, which";
//            break;
//        case ogdf::pvcForest:
//            reason = "Graph is not a rooted forest, which";
//            break;
//        case ogdf::pvcOrthogonal:
//            reason = "Layout is not orthogonal, which";
//            break;
//        case ogdf::pvcPlanar:
//            reason = "Graph is not planar, which";
//            break;
//        case ogdf::pvcClusterPlanar:
//            reason = "Graph is not cluster planar, which";
//            break;
//        case ogdf::pvcNoCopy:
//            reason = "Graph is not a copy of the corresponding graph, which";
//            break;
//        case ogdf::pvcConnected:
//            reason = "Graph is not connected, which";
//            break;
//        case ogdf::pvcBiconnected:
//            reason = "Graph is not twoconnected, which";
//            break;
//        case ogdf::pvcSTOP:
//            // Do nothing.
//            break;
//        }
//        qDebug() << reason << " violates layout preconditions";
//    } catch (ogdf::Exception &) {
//        qDebug()  << "OGDF exception caught";
//    } catch (...) {
//        qDebug()  << "Unknown exception caught";
//    }
//}


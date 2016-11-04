#ifndef _GRAPH_VIEW_H_
#define _GRAPH_VIEW_H_

#include <QGraphicsView>
#include <QPolygonF>
#include <QVector>
#include <QWheelEvent>
//#include <ogdf/basic/Graph.h>
//#include "ogdf/module/LayoutModule.h"
//#include <ogdf/fileformats/GraphIO.h>
//#include <ogdf/cluster/ClusterGraph.h>
////#include <ogdf/basic/GraphAttributes.h>

class QSize;
class QGraphicsScene;
class QPointF;
class QPoint;

class GraphView : public QGraphicsView
{
    Q_OBJECT

public:
    GraphView(QWidget* parent=0);

//    ogdf::node addNode(const QSize& size, const QString& label);
//    void addEdge(const ogdf::node& source, const ogdf::node& target);
//    ogdf::ClusterElement* newCluster(ogdf::ClusterElement* parent = NULL);
//    void addNodeToCluster(const ogdf::node& node, const ogdf::cluster & cluster);
//    void layoutGraph();
//    void callLayout(ogdf::LayoutModule * layout);

    void wheelEvent(QWheelEvent* event);
    void clear();
    void drawArrow(const QPointF& start, const QPointF& end, const QColor& color);
    QPolygonF createArrow(const QPointF& start, const QPointF& end);
    void addComputeNode(const QString& label, QString cluster);

private:
    QString lastCluster;
    QPoint lastColumn;
    int lastMaxWidth;

//    ogdf::Graph* graph_;
////    ogdf::GraphAttributes* GA_;
//    ogdf::ClusterGraphAttributes* GA_;
//    ogdf::ClusterGraph* clusterGraph_;
//    QVector<ogdf::node> nodeList_;
//    QVector<ogdf::edge> edgeList_;
//    QVector<ogdf::ClusterElement*> clusterList_;
    QGraphicsScene* scene_;
    qreal h11;
    qreal h12;
    qreal h21;
    qreal h22;
};

#endif

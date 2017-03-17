#include "meteodatamodel.h"
#include <QDebug>

MeteoDataModel::MeteoDataModel(model::models::ModelParameters * params, QObject *parent)
    : QAbstractTableModel(parent), parameters(params)
{
//    for(auto it = params.getRawParameters().begin(); it != params.getRawParameters().end(); ++it) {
//        keys << QString::fromStdString(it->first);
//    }
//    qDebug() << keys;
}

int MeteoDataModel::rowCount(const QModelIndex &parent) const {
    return  parameters->getMeteoValues()->size();
}
int MeteoDataModel::columnCount(const QModelIndex &parent) const {
    return 6;
}
QVariant MeteoDataModel::data(const QModelIndex &index, int role) const{
    if(role == Qt::DisplayRole){
        switch(index.column()){
            case 0: return index.row(); break;
            case 1: return parameters->getMeteoValues()->at(index.row()).Temperature; break;
            case 2: return parameters->getMeteoValues()->at(index.row()).Par; break;
            case 3: return parameters->getMeteoValues()->at(index.row()).Etp; break;
            case 4: return parameters->getMeteoValues()->at(index.row()).Irrigation; break;
            case 5: return parameters->getMeteoValues()->at(index.row()).P; break;
        }
    }

    if(role == Qt::TextAlignmentRole)
        return Qt::AlignCenter;

    return QVariant();
}
QVariant MeteoDataModel::headerData(int section, Qt::Orientation orientation, int role) const{
    if(orientation == Qt::Horizontal && role == Qt::DisplayRole){
        switch(section){
            case 0: return "Date"; break;
            case 1: return "Temp"; break;
            case 2: return "PAR"; break;
            case 3: return "ETP"; break;
            case 4: return "Irrig"; break;
            case 5: return "P"; break;
        }
    }

    return QAbstractTableModel::headerData(section, orientation, role);
}

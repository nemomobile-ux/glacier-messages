#ifndef MESSAGESHANDLER_H
#define MESSAGESHANDLER_H

#include <QObject>
#include <qofono-qt6/qofonomanager.h>
#include <qofono-qt6/qofonomessagemanager.h>

#include <CommHistory/event.h>
#include <CommHistory/eventmodel.h>
#include <CommHistory/group.h>
#include <CommHistory/groupmodel.h>

class MessagesHandler : public QObject {
    Q_OBJECT
public:
    explicit MessagesHandler(QObject* parent = nullptr);

private slots:
    void onModemsChanged(const QStringList& modems);
    void onIncomingMessage(const QString& message, const QVariantMap& info);

private:
    int getGroupId(QString sender);

    QOfonoManager* m_ofonoManager;
    QList<QOfonoMessageManager*> m_messageManagers;
    CommHistory::EventModel* m_commhistoryEventModel;
    CommHistory::GroupModel* m_groupModel;
};

#endif // MESSAGESHANDLER_H

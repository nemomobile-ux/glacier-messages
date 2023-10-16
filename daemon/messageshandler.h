#ifndef MESSAGESHANDLER_H
#define MESSAGESHANDLER_H

#include <QObject>
#include <qofono-qt6/qofonomanager.h>
#include <qofono-qt6/qofonomessagemanager.h>

#include <CommHistory/event.h>
#include <CommHistory/eventmodel.h>

class MessagesHandler : public QObject {
    Q_OBJECT
public:
    explicit MessagesHandler(QObject* parent = nullptr);

private slots:
    void onModemsChanged(const QStringList& modems);
    void onIncomingMessage(const QString& message, const QVariantMap& info);

private:
    QOfonoManager* m_ofonoManager;
    QList<QOfonoMessageManager*> m_messageManagers;
    CommHistory::EventModel* m_commhistoryEventModel;
};

#endif // MESSAGESHANDLER_H

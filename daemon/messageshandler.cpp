#include "messageshandler.h"
#include <notification.h>

MessagesHandler::MessagesHandler(QObject *parent)
    : QObject(parent)
    , m_ofonoManager(new QOfonoManager(this))
{
    connect(m_ofonoManager, &QOfonoManager::modemsChanged, this, &MessagesHandler::onModemsChanged);
}

void MessagesHandler::onModemsChanged(const QStringList &modems)
{
    foreach (QOfonoMessageManager* manager, m_messageManagers) {
        manager->disconnect();
    }
    m_messageManagers.clear();

    foreach (QString modem, modems) {
        QOfonoMessageManager* manager = new QOfonoMessageManager(this);
        manager->setModemPath(modem);
        connect(manager, &QOfonoMessageManager::incomingMessage, this, &MessagesHandler::onIncomingMessage);
    }
}

void MessagesHandler::onIncomingMessage(const QString &message, const QVariantMap &info)
{
    qDebug() << message;
    qDebug() << info;

    Notification newMessageNotification;
    newMessageNotification.setAppName(tr("Messages"));
    newMessageNotification.setSummary(info.key("Sender"));
    newMessageNotification.setBody(message);
    newMessageNotification.setIcon("/usr/share/glacier-messages/glacier-messages.png");
    newMessageNotification.setUrgency(Notification::Urgency::Normal);

    newMessageNotification.publish();
}

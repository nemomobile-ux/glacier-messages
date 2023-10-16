#include <QDebug>

#include "messageshandler.h"
#include <notification.h>

MessagesHandler::MessagesHandler(QObject* parent)
    : QObject(parent)
    , m_ofonoManager(new QOfonoManager(this))
    , m_commhistoryEventModel(new CommHistory::EventModel(this))
{
    connect(m_ofonoManager, &QOfonoManager::modemsChanged, this,
        &MessagesHandler::onModemsChanged);
}

void MessagesHandler::onModemsChanged(const QStringList& modems)
{
    foreach (QOfonoMessageManager* manager, m_messageManagers) {
        manager->disconnect();
    }
    m_messageManagers.clear();

    foreach (QString modem, modems) {
        QOfonoMessageManager* manager = new QOfonoMessageManager(this);
        manager->setModemPath(modem);
        connect(manager, &QOfonoMessageManager::incomingMessage, this,
            &MessagesHandler::onIncomingMessage);
    }
}

void MessagesHandler::onIncomingMessage(const QString& message,
    const QVariantMap& info)
{
    CommHistory::Event event;
    event.setType(CommHistory::Event::SMSEvent);
    event.setIsRead(false);
    event.setDirection(CommHistory::Event::Inbound);
    event.setFreeText(message.trimmed());
    event.setStartTime(info.value("SentTime").toDateTime());

    Notification newMessageNotification;
    newMessageNotification.setAppName(tr("Messages"));
    newMessageNotification.setSummary(info.key("Sender"));
    newMessageNotification.setBody(message);
    newMessageNotification.setIcon(
        "/usr/share/glacier-messages/glacier-messages.png");
    newMessageNotification.setUrgency(Notification::Urgency::Normal);

    if (m_commhistoryEventModel->addEvent(event)) {
        newMessageNotification.publish();
    } else {
        qWarning() << "Can`t save event";
    }
}

#include <QDebug>

#include "messageshandler.h"
#include <notification.h>

MessagesHandler::MessagesHandler(QObject* parent)
    : QObject(parent)
    , m_ofonoManager(new QOfonoManager(this))
    , m_commhistoryEventModel(new CommHistory::EventModel(this))
    , m_groupModel(new CommHistory::GroupModel(this))
{
    qDebug() << Q_FUNC_INFO;

    m_groupModel->setResolveContacts(CommHistory::GroupManager::DoNotResolve);
    if (!m_groupModel->getGroups()) {
        qFatal() << "Can't load CommHistory::GroupModel";
    }
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

int MessagesHandler::getGroupId(QString sender)
{
    CommHistory::Recipient recipient(LOCAL_UID, sender);
    for (int i = 0; i < m_groupModel->rowCount(); i++) {
        CommHistory::Group group = m_groupModel->group(m_groupModel->index(i, 0));
        if (group.recipients().first() == recipient) {
            qDebug() << "GROUP ID is " << group.id();
            return group.id();
        }
    }

    CommHistory::Group group;
    group.setLocalUid(LOCAL_UID);
    group.setRecipients(recipient);
    group.setChatType(CommHistory::Group::ChatTypeP2P);
    group.setChatName(sender);

    if (m_groupModel->addGroup(group)) {
        qDebug() << "New GROUP ID is " << group.id();
        return group.id();
    }

    return -1;
}

void MessagesHandler::onIncomingMessage(const QString& message, const QVariantMap& info)
{
    QString sender = info.key("Sender");

    int groupId = getGroupId(sender);
    if (groupId < 0) {
        return;
    }

    CommHistory::Event event;
    event.setType(CommHistory::Event::SMSEvent);
    event.setIsRead(false);
    event.setDirection(CommHistory::Event::Inbound);
    event.setFreeText(message.trimmed());
    event.setStartTime(info.value("SentTime").toDateTime());
    event.setGroupId(groupId);

    Notification newMessageNotification;
    newMessageNotification.setAppName(tr("Messages"));
    newMessageNotification.setSummary(sender);
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

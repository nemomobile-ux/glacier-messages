/* Copyright (C) 2023 Chupligin Sergey <neochapay@gmail.com>
 *
 * You may use this file under the terms of the BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *   * Neither the name of Nemo Mobile nor the names of its contributors
 *     may be used to endorse or promote products derived from this
 *     software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <QDebug>

#include "constants.h"
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
    QString sender = info.value("Sender").toString();

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

    if (m_commhistoryEventModel->addEvent(event)) {
        Notification newMessageNotification;
        newMessageNotification.setAppName(tr("Messages"));
        newMessageNotification.setSummary(sender);
        newMessageNotification.setBody(message);
        newMessageNotification.setIcon("/usr/share/glacier-messages/glacier-messages.png");
        newMessageNotification.setUrgency(Notification::Urgency::Normal);
        newMessageNotification.setTimestamp(QDateTime::currentDateTimeUtc());
        newMessageNotification.setHintValue("x-nemo-display-on", true);
        newMessageNotification.setHintValue("x-nemo-priority", 120);

        QVariantList remoteActions;
        remoteActions.append(Notification::remoteAction("default",
            QString(),
            MESSAGING_SERVICE_NAME,
            "/",
            MESSAGING_INTERFACE,
            START_CONVERSATION_METHOD,
            QVariantList() << LOCAL_UID
                           << sender
                           << true));

        newMessageNotification.setRemoteActions(remoteActions);
        newMessageNotification.publish();
    } else {
        qWarning() << "Can`t save event";
    }
}

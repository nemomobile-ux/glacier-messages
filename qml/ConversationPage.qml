/* Copyright (C) 2018 Chupligin Sergey <neochapay@gmail.com>
 * Copyright (C) 2012 John Brooks <john.brooks@dereferenced.net>
 * Copyright (C) 2011 Robin Burchell <robin+nemo@viroteck.net>
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

import QtQuick 2.6

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.messages.internal 1.0
import org.nemomobile.qmlcontacts 1.0
import org.nemomobile.commhistory 1.0
import org.nemomobile.voicecall 1.0

/* ConversationPage has two states, depending on if it has an active
 * conversation or not. This is determined by whether the channel property
 * is set. If unset, this is the new conversation page, and some elements
 * are different. */
Page {
    id: conversationPage

    property QtObject channel: null
    property QtObject group
    property QtObject person: group ? peopleModel.personById(group.contactId) : null
    property string remoteUid: ""

    headerTools:  HeaderToolsLayout {
        id: hTools
        title: person ? person.displayLabel : (group ? group.remoteUids[0] : remoteUid)
        showBackButton: true;

        tools: [
            ToolButton {
                id: callButton
                iconSource: "image://theme/phone"
                onClicked: {
                    callManager.dial(callManager.defaultProviderId, group.remoteUids[0])
                }
            }

        ]
    }

    VoiceCallManager {id:callManager}

    TargetEditBox {
        id: targetEditor
        anchors.top: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        visible: false

        function startConversation() {
            if (targetEditor.text.length < 1)
                return
            console.log("startConversation", targetEditor.text);
            channel = channelManager.getConversation(channel,targetEditor.text.toLowerCase())
        }
    }

    MessagesView {
        id: messagesView
        anchors {
            top: targetEditor.visible ? targetEditor.bottom :  parent.top
            bottom: textArea.top
            left: parent.left;
            right: parent.right
            topMargin: 10;
            bottomMargin: 10
            leftMargin: 5;
            rightMargin: 5
        }

        model: conversationModel
        
        CommConversationModel {
            id: conversationModel
            useBackgroundThread: true
            groupId: group ? group.id : -1
        }

        Component.onCompleted: {
            console.log("Message count",conversationModel.count)
        }
    }

    ChatTextInput {
        id: textArea
        anchors.bottom: parent.bottom
        width: parent.width

        onSendMessage: {
            if (text.length < 1)
                return

            if (conversationPage.state == "new" && targetEditor.text.length > 0)
                targetEditor.startConversation()

            channel.sendMessage(text)
            clear()
        }
    }

    states: [
        State {
            name: "new"
            when: channel == null

            PropertyChanges {
                target: targetEditor
                visible: true
            }

            PropertyChanges {
                target: avatar
                visible: false
            }

            AnchorChanges {
                target: messagesView
                anchors.top: targetEditor.bottom
            }
        }
    ]

    onChannelChanged: {
        if (channel != null) {
            channel.ensureChannel()
            _updateGroup()
        }
    }

    function _updateGroup() {
        if (group === null)
            group = groupManager.findGroup(channel.localUid, channel.remoteUid)
    }

    Connections {
        target: groupManager

        onGroupAdded: _updateGroup()
        onGroupUpdated: _updateGroup()
    }
}


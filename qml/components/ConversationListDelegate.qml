/* Copyright (C) 2018-2021 Chupligin Serhey <neochapay@gmail.com>
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

import org.nemomobile.qmlcontacts 1.0

ListViewItemWithActions {
    id: converstationListDelegate
    icon: getAvatar()
    showNext: true
    label: model.lastMessageText
    description: person ? person.displayLabel : model.remoteUids[0]

    clip: true

    property QtObject person: null
    property int contactId: model.contactIds.length > 0 ? model.contactIds[0] : -1

    Connections {
        target: person ? null : peopleModel
        function onRowsInserted() { updatePerson() }
        function onModelReset() { updatePerson() }
    }

    Component.onCompleted: updatePerson()
    onContactIdChanged: updatePerson()

    function updatePerson() {
        person = peopleModel.personById(model.contactIds[0])
    }


    Rectangle{
        id: unreadCount
        visible: model.unreadMessages > 0
        width: Theme.itemHeightLarge/3
        height: width
        color: Theme.accentColor
        radius: height/2

        Text {
            id: unreadCountText
            text: model.unreadMessages > 99 ? "99+" : model.unreadMessages
            font.pixelSize: parent.height*0.8
            color: Theme.textColor
            anchors.centerIn: parent
        }

        anchors{
            bottom: converstationListDelegate.bottom
            bottomMargin: Theme.itemSpacingExtraSmall
            left: converstationListDelegate.left
            leftMargin: Theme.itemHeightLarge/4*3
        }
    }

    Label {
        id: messageDate
        // XXX This should be something more natural/useful
        text: Qt.formatDateTime(model.lastModified, "M/d")
        anchors.left: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }

    function getAvatar() {
        var av_source;
        if (model.person == null || model.person.avatarPath == "image://theme/user" || model.person.avatarPath == "image://theme/icon-m-telephony-contact-avatar")
        {
            av_source = "image://theme/user"
        }
        else
        {
            av_source = model.person.avatarPath
        }
        return av_source;
    }
}


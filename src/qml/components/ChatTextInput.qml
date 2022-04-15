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

import QtQuick.Controls.Styles 1.4

Item {
    id: textArea
    width: parent.width
    height: Theme.itemHeightLarge*2

    property alias text: textInput.text

    signal sendMessage

    function clear() {
        text = ""
    }

    /* See comment on InverseMouseArea */
    FocusScope {
        id: inputFocusScope
        height: Theme.itemHeightLarge
        width: parent.width-Theme.itemSpacingSmall*2
        anchors{
            top: parent.top
            left: parent.left
            leftMargin: Theme.itemSpacingSmall
        }
        y: 8

        TextArea {
            id: textInput

            height: parent.height
            width: parent.width

            wrapMode: TextEdit.Wrap
            textFormat: TextEdit.PlainText

            Rectangle{
                width: parent.width
                height: 1
                color: Theme.accentColor
                anchors{
                    bottom: parent.bottom
                }
            }

            Label{
                text: qsTr("Type a message")
                visible: (!textInput.focus && !inputFocusScope.focus) || textInput.text.lenght == 0
            }

            style: TextAreaStyle {
                backgroundColor: Theme.fillDarkColor
                font.pixelSize: Theme.fontSizeMedium
                font.family: Theme.fontFamily
                textColor: Theme.textColor
                selectedTextColor: Theme.textColor
                selectionColor: Theme.accentColor
            }
        }
    }

    /* To keep the VKB open when the 'Send' button is clicked, but close it
     * when clicked elsewhere, we have to disable TextArea's default behavior
     * - which is to give focus to its parent - by wrapping it in a FocusScope
     * (making that no-op), and implement the correct behavior here. */
    InverseMouseArea {
        anchors.fill: parent
        z: 100

        onPressed: {
            textArea.focus = true
        }
    }

    Button {
        id: sendBtn
        anchors{
            right: parent.right
            rightMargin: Theme.itemSpacingSmall
            top: inputFocusScope.bottom
            topMargin: Theme.itemSpacingSmall
        }

        text: qsTr("Send")
        enabled: textInput.text.length > 0

        onClicked: sendMessage(text)
    }
}

// Copyright Mirage authors & contributors <https://github.com/mirukana/mirage>
// SPDX-License-Identifier: LGPL-3.0-or-later

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Clipboard 0.1
import "../Base"

HMenu {
    id: accountMenu

    property string userId
    property string presence
    property string statusMsg

    signal wentToAccountPage()

    function setPresence(presence, statusMsg=undefined) {
        py.callClientCoro(userId, "set_presence", [presence, statusMsg])
    }

    onOpened: statusText.forceActiveFocus()

    HLabeledItem {
        id: statusMsgLabel
        enabled: presence && presence !== "offline"
        width: parent.width
        height: visible ? implicitHeight : 0
        label.text: qsTr("Status message:")
        label.horizontalAlignment: Qt.AlignHCenter

        Keys.onDownPressed: onlineButton.forceActiveFocus()

        HRowLayout {
            width: parent.width

            HTextField {
                id: statusText
                maximumLength: 255
                horizontalAlignment: Qt.AlignHCenter
                onAccepted: {
                    setPresence(presence, statusText.text)
                    accountMenu.close()
                }

                defaultText: statusMsg
                placeholderText: presence ? "" : "Unsupported server"

                Layout.fillWidth: true
            }

            HButton {
                id: button
                visible: presence

                icon.name: "apply"
                icon.color: theme.colors.positiveBackground
                onClicked: {
                    setPresence(presence, statusText.text)
                    accountMenu.close()
                }

                Layout.fillHeight: true
            }
        }
    }

    HMenuSeparator { }

    HMenuItem {
        id: onlineButton
        icon.name: "presence-online"
        icon.color: theme.controls.presence.online
        text: qsTr("Online")
        onTriggered: setPresence("online")

        Keys.onUpPressed: statusText.forceActiveFocus()
    }

    HMenuItem {
        enabled: presence
        icon.name: "presence-busy"
        icon.color: theme.controls.presence.unavailable
        text: qsTr("Unavailable")
        onTriggered: setPresence("unavailable")
    }

    HMenuItem {
        icon.name: "presence-invisible"
        icon.color: theme.controls.presence.offline
        text: qsTr("Invisible")
        onTriggered: setPresence("invisible")
    }

    HMenuItem {
        icon.name: "presence-offline"
        icon.color: theme.controls.presence.offline
        text: qsTr("Offline")
        onTriggered: setPresence("offline")
    }

    HMenuSeparator {
        visible: statusMsgLabel.visible
        height: visible ? implicitHeight : 0
    }

    HMenuItem {
        icon.name: "account-settings"
        text: qsTr("Account settings")
        onTriggered: {
            pageLoader.show(
                "Pages/AccountSettings/AccountSettings.qml",
                { "userId": userId },
            )
            wentToAccountPage()
        }
    }

    HMenuItem {
        icon.name: "menu-add-chat"
        text: qsTr("Add new chat")
        onTriggered: {
            pageLoader.show("Pages/AddChat/AddChat.qml", {userId: userId})
            wentToAccountPage()
        }
    }

    HMenuItem {
        icon.name: "copy-user-id"
        text: qsTr("Copy user ID")
        onTriggered: Clipboard.text = userId
    }

    HMenuItemPopupSpawner {
        icon.name: "sign-out"
        icon.color: theme.colors.negativeBackground
        text: qsTr("Sign out")

        popup: "Popups/SignOutPopup.qml"
        properties: { "userId": userId }
    }
}

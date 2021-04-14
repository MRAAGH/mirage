// Copyright Mirage authors & contributors <https://github.com/mirukana/mirage>
// SPDX-License-Identifier: LGPL-3.0-or-later

import QtQuick 2.12
import "../../../Base"

Banner {
    color: theme.chat.leftBanner.background

    // TODO: avatar func auto
    avatar.userId: chat.userId
    avatar.displayName: chat.userInfo.display_name
    avatar.mxc: chat.userInfo.avatar_url
    labelText: qsTr("You are no longer part of this room")

    buttonModel: [
        {
            name: "forget",
            text: qsTr("Forget"),
            iconName: "room-forget",
            iconColor: theme.colors.negativeBackground
        }
    ]

    buttonCallbacks: ({
        forget: button => {
            window.makePopup(
                "Popups/LeaveRoomPopup.qml",
                {
                    userId:    chat.userId,
                    roomId:    chat.roomId,
                    roomName:  chat.roomInfo.display_name,
                    inviterId: chat.roomInfo.inviter_id,
                    left:      true,
                },
                obj => {
                    obj.onOk.connect(() => { button.loading = true })  // FIXME
                },
                false,
            )
        }
    })
}

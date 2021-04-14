// Copyright Mirage authors & contributors <https://github.com/mirukana/mirage>
// SPDX-License-Identifier: LGPL-3.0-or-later

import QtQuick 2.12
import "../../Base"

HCheckBox {
    text: qsTr("Encrypt messages")
    subtitle.textFormat: Text.StyledText
    subtitle.text:
        qsTr("Only users you trust can decrypt the conversation") +
        `<br><font color="${theme.colors.warningText}">` +
        qsTr("Cannot be disabled later!") +
        "</font>"
}

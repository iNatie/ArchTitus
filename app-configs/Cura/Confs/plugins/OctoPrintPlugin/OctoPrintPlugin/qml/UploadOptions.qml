import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.1

import UM 1.1 as UM

UM.Dialog
{
    id: base
    property string object: ""

    property alias newName: nameField.text
    property bool validName: true
    property string validationError

    title: catalog.i18nc("@action:button", "Upload Filename")

    minimumWidth: screenScaleFactor * 400
    minimumHeight: screenScaleFactor * 120

    signal textChanged(string text)
    signal selectText()
    onSelectText: {
        nameField.selectAll()
        nameField.focus = true
    }

    Column {
        anchors.fill: parent

        TextField {
            objectName: "nameField"
            id: nameField
            width: parent.width
            text: base.object
            maximumLength: 100
            onTextChanged: base.textChanged(text)
            Keys.onReturnPressed: { if (base.validName) base.accept(); }
            Keys.onEnterPressed: { if (base.validName) base.accept(); }
            Keys.onEscapePressed: base.reject()
        }

        Label {
            visible: !base.validName
            text: base.validationError
        }
    }

    rightButtons: [
        Button {
            text: catalog.i18nc("@action:button", "Cancel")
            onClicked: base.reject()
        },
        Button {
            text: catalog.i18nc("@action:button", "OK")
            onClicked: base.accept()
            enabled: base.validName
            isDefault: true
        }
    ]

    UM.I18nCatalog{id: catalog; name:"cura"}
}

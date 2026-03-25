import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import '../styles'

Popup {
    id: popupRoot
    modal: true
    focus: true
    visible: false
    width: parent.width * 0.5
    height: parent.height * 0.6
    anchors.centerIn: parent

    property string folderPath: ""
    property string fileName: ""

    background: Rectangle {
        border.width: 2
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Label {
            text: popupRoot.fileName
            font.bold: true
            font.pointSize: 14
            Layout.alignment: Qt.AlignHCenter
        }

        Image {
            source: popupRoot.folderPath && popupRoot.fileName ? popupRoot.folderPath + "/" + popupRoot.fileName : ""
            fillMode: Image.PreserveAspectFit
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.6
            Layout.alignment: Qt.AlignHCenter
        }

        ComboBox {
            id: optionsDropdown
            Layout.fillWidth: true
            model: tagHandler.dropdownItems
            textRole: "subtag"

            displayText: currentIndex >= 0 ? currentText : "Select a tag..."

            delegate: ItemDelegate {
                width: parent.width

                // allows for header groups in dropdown
                visible: true
                enabled: !modelData["header"]

                contentItem: Text {
                    text: modelData["header"] ? modelData["parent"] : "    " + modelData["subtag"]
                    font.bold: modelData["header"]
                    color: modelData["header"] ? "gray" : "black"
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight

            Button {
                text: "Submit"
                onClicked: {
                    let selected = optionsDropdown.model[optionsDropdown.currentIndex]
                    let path = popupRoot.folderPath + '/' + popupRoot.fileName
                    console.log("Submitted option:", optionsDropdown.currentText)
                    tagHandler.attach_tag(path, selected["parent"], selected["subtag"])
                    popupRoot.close()
                }
            }
        }
    }
}
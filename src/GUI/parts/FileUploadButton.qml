import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

Item {
    id: r

    signal imageSelected(url fileUrl)

    implicitWidth: 200
    implicitHeight: 40

    Button {
        anchors.fill: parent
        text: "Upload Image"

        onClicked: fileDialog.open()

        background: Rectangle {
            color: "#1e2a3a"
            radius: 10
            border.color: "white"
            border.width: 2
        }

        contentItem: Text {
            text: parent.text
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select an Image"
        nameFilters: ["Image files (*.png *.jpg *.jpeg *.bmp)"]
        fileMode: FileDialog.OpenFiles

        onAccepted: {
            for (var i = 0; i < selectedFiles.length; i++) {
                fileHandler.save_image(selectedFiles[i])
            }
        }
    }
}
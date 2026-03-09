import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
//creation of separate folder called handlers
//create FileHandler.py
//put stuff in there, reference here


Item {
    id: r

    signal imageSelected(url fileUrl)

    Button {
        text: "Upload Image"
        onClicked: fileDialog.open()

        background: Rectangle {
        color: "#ADD8E6"
        //rounded corners!
        radius: 10
    }

    contentItem: Text {
        text: parent.text
        color: "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    }

    FileDialog {
        id: fileDialog
        title: "Select an Image"
        //only allows certain file types in
        nameFilters: ["Image files (*.png *.jpg *.jpeg *.bmp)"]
        fileMode: FileDialog.OpenFile


        onAccepted: {
            r.imageSelected(selectedFile)
        }
    }
}
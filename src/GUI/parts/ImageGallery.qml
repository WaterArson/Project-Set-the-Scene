import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel 2.15
import QtCore

ColumnLayout {
    id: galleryRoot
    property bool galleryVisible: false
    anchors.fill: parent
    property string selectedImage: ""
    signal imageSelected(string fileUrl)


    FolderListModel {
        id: folderModel
        folder: StandardPaths.writableLocation(StandardPaths.DesktopLocation) + "/SceneImages"
        nameFilters: ["*.png","*.jpg","*.jpeg","*.bmp"]
        showDirs: false
    }




        // BUTTON
        Button {
            text: "View Images"
            Layout.preferredHeight: 40
           // Layout.preferredWidth: 150

            background: Rectangle {
                color: "#90EE90"
                radius: 10
            }

            onClicked: {
                galleryRoot.galleryVisible = !galleryRoot.galleryVisible
            }
        }

        // GRID VIEW (fills remaining space)
        GridView {
            id: imageViewer
            //visible: galleryRoot.galleryVisible

           Layout.preferredHeight: galleryRoot.galleryVisible ? parent.height * 0.6 : 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            //Layout.minimumHeight: 300
            property int columns: 4
            property int spacing: 10

            model: folderModel
            cellWidth: width > 0 ? width / columns : 200
            cellHeight: 220

            delegate: Item {
                width: imageViewer.cellWidth
                height: imageViewer.cellHeight

                Column {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 5

                    Image {
                        source: folderModel.folder + "/" + fileName
                        //width: 150
                        //height: 130
                        //fillMode: Image.PreserveAspectFit

                        //anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        height: parent.height - 30
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        text: fileName
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                    }
                }
                 MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        galleryRoot.selectedImage = folderModel.folder + "/" + fileName
                        galleryRoot.imageSelected(galleryRoot.selectedImage)
                        console.log("Clicked:", galleryRoot.selectedImage)
                    }

                    onEntered: parent.scale = 1.05
                    onExited: parent.scale = 1.0
                }
            }
        }

}
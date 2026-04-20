import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../parts"
import "../styles"

// Pictures screen that allows you see all pictures actively in your files, and tag them

Page {
    id: picturesPage

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TopBar {
            id: topBar
            Layout.preferredHeight: parent.height * 0.1
        }

        //the banner!!!
        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: "#1e2a3a"

            Item {
                anchors.fill: parent

                FileUploadButton {
                    width: 200
                    height: 35
                    anchors.right: parent.horizontalCenter
                }

                Button {
                    width: 200
                    height: 35
                    anchors.left: parent.horizontalCenter

                    text: imageGallery.selectedTags.length > 0
                          ? "Filters (" + imageGallery.selectedTags.length + ")"
                          : "Filter by Tags"

                    background: Rectangle {
                        color: "#1e2a3a"
                        radius: 10
                        border.color: "white"
                        border.width: 2
                    }
                    onClicked: imageGallery.openTagFilter()
                }
            }
        }

        RowLayout {
            id: contentRow
            Layout.preferredHeight: parent.height * 0.9
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 5

                ImageGallery {
                    id: imageGallery
                    anchors.fill: parent

                    onImageSelected: {
                        console.log("Parent received image:", fileUrl)
                    }
                }

                Loader {
                    id: fileLoader
                    source: "MyView.qml"
                    anchors.fill: parent
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1
            }
        }
    }
}
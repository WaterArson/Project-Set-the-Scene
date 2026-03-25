import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../parts"
import "../styles"

// Pictures screen that allows you see all pictures actively in your files, and tag them

Page {
    id: picturesPage

    // container for the page content

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        // create top bar

        TopBar {
            id: topBar
            Layout.preferredHeight: parent.height * 0.1
        }

        RowLayout {
            id: contentRow
            Layout.preferredHeight: parent.height * 0.9
            spacing: 0
            Rectangle{
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                FileUploadButton {
                    id: fileUploadButton
                    Layout.preferredHeight: contentRow.height * 0.5
                }
            }

            Rectangle{
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 5
                   ImageGallery {
                        anchors.centerIn: parent
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                             onImageSelected: {
                            console.log("Parent received image:", fileUrl)
                            // Do whatever you want with the clicked image
                            // e.g., show in a bigger view, upload, etc.
                        }
                    }

                Loader {
                id: fileLoader
                source: "MyView.qml" // Predefined file
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
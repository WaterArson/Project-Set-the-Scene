import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../parts"
import "../styles"

// Open screen that you load into on application launch

Page {
    id: openPage

    // container for the page content

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // create top bar

        TopBar {
            id: topBar
            Layout.preferredHeight: parent.height * 0.1
        }

        // main content

        RowLayout {
            id: contentRow
            Layout.preferredHeight: parent.height * 0.9
            spacing: 0

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.2
                    Layout.margins: 0

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            id: text
                            text: "Set The Scene"
                            anchors.centerIn: parent
                            font.pixelSize: Math.max(14, parent.height * 0.3)
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.15
                    Layout.margins: 0

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}
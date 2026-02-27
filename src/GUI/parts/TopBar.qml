import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Rectangle {
    color: '#9394A5'
    border.color: '#d2d3db'
    border.width: 5

    Layout.fillWidth: true

    RowLayout {
        anchors.fill: parent
        anchors.centerIn: parent
        spacing: 0

        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: 1
            Layout.alignment: Qt.AlignCenter
            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // Text {
                //     id: title
                //     text: "Set The Scene"
                //     anchors.centerIn: parent
                //     font.pixelSize: 38
                //     font.family: "Segoe UI"
                // }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: 2
            Layout.alignment: Qt.AlignCenter
            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    id: title
                    text: "Set The Scene"
                    anchors.centerIn: parent
                    font.pixelSize: 38
                    font.family: "Segoe UI"
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: 1
            Layout.alignment: Qt.AlignRight
            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Button {
                    text: "Test"
                }
            }
        }
    }
}
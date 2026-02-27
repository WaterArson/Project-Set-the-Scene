import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import '../styles'

Rectangle {
    color: '#9394A5'
    border.color: '#d2d3db'
    border.width: 5

    Layout.fillWidth: true

    RowLayout {
        anchors.fill: parent
        spacing: 0

        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: 1
            Layout.alignment: Qt.AlignCenter
            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Button {
                    id: home
                    text: "Home"
                    anchors.centerIn: parent
                    font.pixelSize: Math.max(14, parent.height * 0.3)
                    hoverEnabled: false

                    contentItem: Text {
                        text: home.text
                        font: home.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: home.down ? "#b5b2b2" : "#FFFFFF"
                        opacity: 1
                    }

                    background: Rectangle {
                        anchors.fill: parent
                        color: '#000000'
                        border.width: 1
                        opacity: 1
                    }

                    onClicked: {
                        stackView.replace('../pages/OpenPage.qml')
                    }
                }
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
                            id: pictures
                            text: "Pictures"
                            anchors.centerIn: parent
                            font.pixelSize: Math.max(14, parent.height * 0.3)
                            hoverEnabled: false

                            contentItem: Text {
                                text: pictures.text
                                font: pictures.font
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: pictures.down ? "#b5b2b2" : "#FFFFFF"
                                opacity: 1
                            }

                            background: Rectangle {
                                anchors.fill: parent
                                color: '#000000'
                                border.width: 1
                                opacity: 1
                            }

                            onClicked: {
                                stackView.replace('../pages/PicturesPage.qml')
                            }
                        }
            }
        }
    }
}
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "./parts"
import "./styles"

Window {
    title: "Main Screen"

    readonly property var texts: ["Hallo Welt", "Hei maailma",
                                           "Hola Mundo", "Привет мир"]

    function setText() {
        var i = Math.round(Math.random() * 3)
        text.text = texts[i]
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TopBar {
            id: topBar
            Layout.preferredHeight: parent.height * 0.1
        }

        RowLayout {
            id: contentRow
            Layout.preferredHeight: (parent.height * 0.9)
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

                        Button {
                            id: button
                            text: "Click me"
                            anchors.centerIn: parent
                            font.pixelSize: Math.max(14, parent.height * 0.3)
                            hoverEnabled: false

                            contentItem: Text {
                                text: button.text
                                font: button.font
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: button.down ? "#17a81a" : "#ffffff"
                                opacity: 1
                            }

                            background: Rectangle {
                                anchors.fill: parent
                                radius: 5
                                color: button.down ? "#17a81a" : "#21be2b"
                                border.width: 1
                                border.color: button.down ? "#FFF" : "#17a81a"
                                opacity: 1
                            }


                            onClicked: setText()
                        }
                    }
                }
            }
        }
    }
}
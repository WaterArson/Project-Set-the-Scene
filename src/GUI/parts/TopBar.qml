import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import '../styles'

Rectangle {
 id:scene

    border.width: 5

    Layout.fillWidth: true

    // 1. Night Sky Background
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#000033" } // Dark Blue
        GradientStop { position: 1.0; color: "black" }
    }

    // 2. Generate Stars
    Repeater {
        model: 50 // Number of stars
        Rectangle {
            // Random positioning
            x: Math.random() * scene.width
            y: Math.random() * scene.height
            width: 2; height: 2
            color: "white"
            radius: 1

            // 3. Twinkle Animation
            opacity: Math.random()
            NumberAnimation on opacity {
                from: 0.2; to: 1.0; duration: Math.random() * 2000 + 1000
                loops: Animation.Infinite
                running: true
            }
        }
    }

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
                    color : "white"
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: 1
            Layout.alignment: Qt.AlignRight

            RowLayout {

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Button {
                        text: "Home"

                        onPressed: stackView.push('../pages/OpenPage.qml')
                    }


                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Button {
                        text: "Pictures"

                        onPressed: stackView.push('../pages/PicturesPage.qml')
                    }

                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Button {
                        text: "Settings"

                        onPressed: stackView.push('../pages/SettingsPage.qml')
                    }

                }
            }
        }
    }
}
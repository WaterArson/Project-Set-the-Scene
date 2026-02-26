import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    minimumWidth: 800
    minimumHeight: 500

    visible: true
    title: "Hello World"

    readonly property var texts: ["Hallo Welt", "Hei maailma",
                                           "Hola Mundo", "Привет мир"]

    function setText() {
        var i = Math.round(Math.random() * 3)
        text.text = texts[i]
    }

    RowLayout {
        id: topBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.1
        spacing: 20

        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width * 0.5
            anchors.centerIn: parent
            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "purple"

                Text {
                    id: title
                    text: "Set The Scene"
                    anchors.centerIn: parent
                    font.pixelSize: 38
                    color: "white"
                }
            }
        }
    }

    RowLayout {
        id: contentRow
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: (parent.height * 0.9)
        spacing: 20

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.2
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 10

                    Text {
                        id: text
                        text: "Hello World"
                        anchors.centerIn: parent
                        font.pixelSize: 24
                        color: "black"
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.15
                spacing: 10

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
                            color: button.down ? "#17a81a" : "#21be2b"   // ← THIS IS THE ACTUAL FILL
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
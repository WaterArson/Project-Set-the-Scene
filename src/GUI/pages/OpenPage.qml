import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick 2.15
import QtQuick.Window 2.15

import "../parts"
import "../styles"

Page {
    id: openPage

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TopBar {
            id: topBar
            Layout.preferredHeight: 80
        }

        RowLayout {
            id: contentRow
            Layout.fillHeight: true
            spacing: 0

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height * 0.2
                    Layout.margins: 0


                    Rectangle {
                    //purple gradient background rectangle
                        id: roku
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#301934" } // Dark purple
                                GradientStop { position: 1.0; color: "black" }
                            }
                             // NEW wrapper
                             Item {
                                id: skyline
                                width: parent.width
                                height: parent.height
                                clip: true
                             }
                              Rectangle {
                                id: ground
                                parent: skyline
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: 100
                                     Component.onCompleted: {
                                        // Example of adding buildings programmatically after the component is created
                                        // More complex layouts might use a Repeater with a data model.
                                        createBuilding(50, 150, "#A9A9A9") // all dark gray
                                        createBuilding(130, 200, "#A9A9A9")
                                        createBuilding(210, 100, "#A9A9A9")
                                        createBuilding(290, 250, "#A9A9A9")
                                        createBuilding(370, 180, "#A9A9A9")
                                        createBuilding(450, 130, "#A9A9A9")
                                        createBuilding(530, 140, "#A9A9A9")
                                        createBuilding(610, 100, "#A9A9A9")
                                        createBuilding(690, 132, "#A9A9A9")
                                        createBuilding(770, 94, "#A9A9A9")
                                        createBuilding(850, 130, "#A9A9A9")
                                        createBuilding(930, 240, "#A9A9A9")
                                        createBuilding(1010, 187, "#A9A9A9")
                                        createBuilding(1090, 157, "#A9A9A9")
                                    }

                                    // Function to create building rectangles
                                   function createBuilding(xPos, heightVal, colorVal) {

                                    var building = Qt.createQmlObject(
                                        'import QtQuick 2.15; Rectangle { width: 80; height: ' + heightVal + '; color: "' + colorVal + '" }',
                                        skyline,
                                        "building"
                                    )

                                    building.x = xPos
                                    building.anchors.bottom = ground.top

                                    // create windows
                                    var cols = 4
                                    var rows = Math.floor(heightVal / 20)

                                    for (var r = 0; r < rows; r++) {
                                        for (var c = 0; c < cols; c++) {

                                            var win = Qt.createQmlObject(
                                                'import QtQuick 2.15; Rectangle { width: 8; height: 10; color: "black" }',
                                                building,
                                                "window"
                                            )

                                            win.x = 8 + c * 16
                                            win.y = 8 + r * 18

                                            // flicker timer
                                            var timer = Qt.createQmlObject(
                                                'import QtQuick 2.15; Timer { interval: 1000; repeat: true; running: true }',
                                                win,
                                                "timer"
                                            )

                                            timer.triggered.connect(function() {
                                                if (Math.random() > 0.5)
                                                    win.color = "yellow"
                                                else
                                                    win.color = "black"
                                            })
                                        }
                                    }
                                }

                                }
                                //this creates the animation for the objects listed above
                            SequentialAnimation {
            loops: Animation.Infinite // Make it loop forever
            running: true             // Start automatically

            // Move to point B
            NumberAnimation {
                target: skyline
                property: "x"
                to: -50
                duration: 5000
                easing.type: Easing.InOutQuad
            }
            PropertyAction {
            target: skyline
            property: "x"
            value: 1250 // Start point
        }
        }

                    Text {
                        id: text
                        text: "Set The Scene"
                        anchors.centerIn: parent
                        font.pixelSize: roku.height * 0.25
                        color: "white"
                    }
                    RowLayout {
                       Layout.fillWidth: true
                       Layout.preferredHeight: parent.height * 0.15
                       Layout.margins: 0
                    }
            }
           }
         }
       }
    }
}
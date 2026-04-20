import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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

        Rectangle {
            id: roku
            Layout.fillWidth: true
            Layout.fillHeight: true

            //  Gradient background (UNCHANGED STYLE)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#301934" }
                GradientStop { position: 1.0; color: "black" }
            }

            //  SKYLINE CONTAINER
            Item {
                id: skylineWrapper
                anchors.fill: parent
                clip: true

                //  MID LAYER
                Item {
                    id: midLayer
                   width: skylineWrapper.width * 2
                    //height: skylineWrapper.height
                }

                //  FRONT LAYER
                Item {
                    id: frontLayer
                    width: skylineWrapper.width * 2
                    height: skylineWrapper.height
                }

                // SMOOTH LOOP
                Timer {
                    interval: 16
                    running: true
                    repeat: true

                    onTriggered: {
                        skylineWrapper.moveLayer(midLayer, 0.4)
                        skylineWrapper.moveLayer(frontLayer, 0.9)
                    }
                }

                function moveLayer(layer, speed) {
                     layer.x -= speed
                    if (layer.x <= -skylineWrapper.width) {
                        layer.x = 0
                    }
                }

                Component.onCompleted: {
                    setupLayer(midLayer, 0.6, "#7a5c9e")
                    setupLayer(frontLayer, 1.0, "#a9a9a9")
                }

                function setupLayer(layer, heightScale, color) {
                    var layout = generateLayout()
                    createFromData(layer, layout, 0, heightScale, color)
                    createFromData(layer, layout, skylineWrapper.width, heightScale, color)
                }

                function generateLayout() {
                    var arr = []
                    var x = 0

                    while (x < skylineWrapper.width) {
                        var w = 60 + Math.random() * 40
                        var h = 120 + Math.random() * 180

                        arr.push({x: x, w: w, h: h})
                        x += w + 6    
                        // after loop finishes:
                        arr.push({ x: x, w: 40, h: 20 })
                    }

                    return arr
                }

                function createFromData(layer, layout, offsetX, heightScale, color) {

                    var ground = Qt.createQmlObject(
                        'import QtQuick 2.15; Rectangle {' +
                        'height: 20; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom;' +
                        'color: "transparent"}',
                        layer
                    )

                    for (var i = 0; i < layout.length; i++) {

                        var b = layout[i]

                        var building = Qt.createQmlObject(
                            'import QtQuick 2.15; Rectangle { radius: 2 }',
                            layer
                        )

                        building.x = b.x + offsetX
                        building.width = b.w
                        building.height = b.h * heightScale
                        building.color = color
                        building.anchors.bottom = ground.top

                        // 🪟 WINDOWS (LESS OBNOXIOUS)
                        if (heightScale > 0.5) {

                            var cols = Math.floor(b.w / 18)
                            var rows = Math.floor((b.h * heightScale) / 25)

                            for (var r = 0; r < rows; r++) {
                                for (var c = 0; c < cols; c++) {

                                    let win = Qt.createQmlObject(
                                        'import QtQuick 2.15; Rectangle { width: 6; height: 8; color: "black"; radius: 1 }',
                                        building
                                    )

                                    win.x = 6 + c * 14
                                    win.y = 6 + r * 18

                                    let timer = Qt.createQmlObject(
                                        'import QtQuick 2.15; Timer { interval: 2000 + Math.random()*3000; repeat: true; running: true }',
                                        win
                                    )

                                    timer.triggered.connect(function() {
                                        // ✅ much calmer flicker
                                        if (Math.random() > 0.8)
                                            win.color = "#ffd966"
                                        else
                                            win.color = "black"
                                    })
                                }
                            }
                        }
                    }
                }
            }

            // 🏷 TITLE TEXT (ALWAYS ON TOP)
            Text {
                text: "Project: Set the Scene"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.08

                font.pixelSize: parent.height * 0.14
                font.bold: true
                color: "white"

                z: 999
            }
        }
    }
}
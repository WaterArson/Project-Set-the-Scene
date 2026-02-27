import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../parts"
import "../styles"

// Application manager file. Allows for simplistic page changes

ApplicationWindow {
    visible: true
    width: 1200
    height: 800

    StackView {
        id: stackView
        anchors.fill: parent
        // start on openPage
        initialItem: OpenPage {}
    }
}
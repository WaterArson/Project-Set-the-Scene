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
        }
    }
}
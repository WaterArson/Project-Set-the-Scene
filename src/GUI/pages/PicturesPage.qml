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

            FileUploadButton {
                id: fileUploadButton
                Layout.preferredHeight: contentRow.height * 0.5
            }

            Button {
                id: weatherTagButton
                text: "Attach Weather Tag"

                // plug these in from the parent
                property int imageObj: 1
                property string weatherSubtag: "Rain"  // "Rain", "Snow", "Thunderstorm"

                onClicked: {
                    if (imageObj && tagHandler) {
                        tagHandler.attach_tag(imageObj, "WeatherTag", weatherSubtag)
                    }
                }
            }
        }
    }
}
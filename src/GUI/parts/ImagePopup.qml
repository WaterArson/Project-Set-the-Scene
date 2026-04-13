import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import '../styles'

Popup {
    id: popupRoot
    modal: true
    focus: true
    visible: false
    width: parent.width * 0.7      // increased width for larger popup
    height: parent.height * 0.75    // increased height for larger popup
    anchors.centerIn: parent

    property string folderPath: ""
    property string fileName: ""
    property var selectedImagePaths: []   // list of multiple selected images

    // background of the popup
    background: Rectangle {
        color: "#2e2e2e"     // darker gray background, same as app background
        border.width: 4       // thicker border
        border.color: "white" // white border
        radius: 8             // rounded corners
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // display the file name at the top
        Label {
            text: popupRoot.fileName
            font.bold: true
            font.pointSize: 14
            color: "white"    // readable on dark background
            Layout.alignment: Qt.AlignHCenter
        }

        // display the image
        Image {
            source: popupRoot.folderPath && popupRoot.fileName
                    ? popupRoot.folderPath + "/" + popupRoot.fileName
                    : ""
            fillMode: Image.PreserveAspectFit
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.6
            Layout.alignment: Qt.AlignHCenter
        }

        // Scrollable tag list to prevent overflow
        ScrollView {
            id: tagScroll
            Layout.fillWidth: true
            Layout.fillHeight: true    // fills remaining vertical space
            clip: true                 // ensures content does not render outside

            ListView {
                id: tagList
                width: parent.width
                model: tagHandler.dropdownItems

                delegate: Row {
                    width: parent.width
                    spacing: 6

                    // CheckBox for selecting subtags
                    CheckBox {
                        visible: !modelData["header"]       // only for subtags
                        checked: modelData["selected"] || false

                        // track selection state
                        onCheckedChanged: modelData["selected"] = checked

                        palette.text: "white"               // readable on dark background
                    }

                    // display subtag or header
                    Text {
                        text: modelData["header"]
                              ? modelData["parent"]        // header text
                              : "    " + modelData["subtag"] // subtag text with indent
                        font.bold: modelData["header"]     // bold for headers
                        color: "white"                     // readable on dark background

                        // prevent long text from overflowing
                        wrapMode: Text.Wrap
                        width: parent.width - 40           // leave space for checkbox
                    }
                }
            }
        }

        // Submit button row
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight

            Button {
                text: "Submit"
                onClicked: {
                    // collect all selected tags
                    let selectedTags = []
                    for (let i = 0; i < tagList.model.length; i++) {
                        let item = tagList.model[i]
                        if (!item.header && item.selected) {
                            selectedTags.push({
                                parent: item.parent,
                                subtag: item.subtag
                            })
                        }
                    }

                    // determine which images to tag (batch or single fallback)
                    let imagesToTag = popupRoot.selectedImagePaths.length > 0
                        ? popupRoot.selectedImagePaths
                        : [popupRoot.folderPath + '/' + popupRoot.fileName]

                    console.log("Batch tags:", selectedTags, "on images:", imagesToTag)

                    // call backend batch API
                    tagHandler.attach_tags_batch(
                        imagesToTag,
                        JSON.stringify(selectedTags)
                    )

                    popupRoot.close() // close popup after submission
                }
            }
        }
    }
}
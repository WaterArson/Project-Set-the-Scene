import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import '../styles'

Popup {
    id: popupRoot
    modal: true
    focus: true
    visible: false

    width: parent.width * 0.7
    height: parent.height * 0.75
    anchors.centerIn: parent

    property string folderPath: ""
    property string fileName: ""
    property var selectedImagePaths: []

    // THIS is now the ONLY source of truth for selection
    property var selectedTags: []

    background: Rectangle {
        color: "#2e2e2e"
        border.width: 4
        border.color: "white"
        radius: 8
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Label {
            text: popupRoot.fileName
            font.bold: true
            font.pointSize: 14
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }

        Image {
            source: popupRoot.folderPath && popupRoot.fileName
                    ? popupRoot.folderPath + "/" + popupRoot.fileName
                    : ""

            fillMode: Image.PreserveAspectFit
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.6
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: tagList
                width: parent.width
                model: tagHandler.dropdownItems

                delegate: Row {
                    width: parent.width
                    spacing: 6

                    CheckBox {
                        visible: !modelData.header

                        checked: popupRoot.selectedTags.some(function(t) {
                            return t.parent === modelData.parent &&
                                   t.subtag === modelData.subtag
                        })

                        onToggled: {
                            let tags = popupRoot.selectedTags

                            if (checked) {
                                // avoid duplicates
                                let exists = tags.some(function(t) {
                                    return t.parent === modelData.parent &&
                                           t.subtag === modelData.subtag
                                })

                                if (!exists) {
                                    tags.push({
                                        parent: modelData.parent,
                                        subtag: modelData.subtag
                                    })
                                }
                            } else {
                                tags = tags.filter(function(t) {
                                    return !(t.parent === modelData.parent &&
                                             t.subtag === modelData.subtag)
                                })
                            }

                            popupRoot.selectedTags = tags
                        }
                    }

                    Text {
                        text: modelData.header
                              ? modelData.parent
                              : "    " + modelData.subtag

                        font.bold: modelData.header
                        color: "white"
                        wrapMode: Text.Wrap
                        width: parent.width - 40
                    }
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 10

            Button {
                text: "Submit"

                onClicked: {
                    let imagesToTag = popupRoot.selectedImagePaths.length > 0
                        ? popupRoot.selectedImagePaths
                        : [popupRoot.folderPath + '/' + popupRoot.fileName]

                    console.log("SUBMIT tags:", popupRoot.selectedTags)
                    console.log("SUBMIT images:", imagesToTag)

                    tagHandler.attach_tags_batch(
                        imagesToTag,
                        popupRoot.selectedTags
                    )

                    popupRoot.close()
                }
            }

            Button {
                text: "Remove"

                onClicked: {
                    let imagesToTag = popupRoot.selectedImagePaths.length > 0
                        ? popupRoot.selectedImagePaths
                        : [popupRoot.folderPath + '/' + popupRoot.fileName]

                    console.log("REMOVE tags:", popupRoot.selectedTags)
                    console.log("REMOVE images:", imagesToTag)

                    tagHandler.remove_tags_batch(
                        imagesToTag,
                        popupRoot.selectedTags
                    )

                    popupRoot.close()
                }
            }
        }
    }
}
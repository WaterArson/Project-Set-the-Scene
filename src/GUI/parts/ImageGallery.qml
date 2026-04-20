import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel 2.15
import QtCore
import "../styles"

ColumnLayout {
    id: galleryRoot
    anchors.fill: parent

    property bool galleryVisible: false
    property string selectedImage: ""
    property var selectedTags: []
    signal imageSelected(string fileUrl)

    function imageMatchesFilters(fileUrl) {
        if (selectedTags.length === 0) return true
        return tagHandler.imageHasTags(fileUrl, selectedTags)
    }
    function openTagFilter() {
        tagFilterPopup.open()
    }

    Popup {
        id: tagFilterPopup
        x: (galleryRoot.width - width) / 2
        y: (galleryRoot.height - height) / 2
        width: 300
        height: 400
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10

            Text { text: "Filter by Tags"; font.bold: true; font.pixelSize: 16 }

            Button {
                text: "Clear All"
                onClicked: galleryRoot.selectedTags = []
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: tagHandler.dropdownItems

                delegate: Item {
                    width: parent.width
                    height: 36

                    Text {
                        visible: modelData.header
                        text: modelData.parent
                        font.bold: true
                        font.pixelSize: 14
                        color: "#3bb9d3"
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 4
                    }

                    RowLayout {
                        visible: !modelData.header
                        anchors.fill: parent
                        anchors.leftMargin: 16

                        CheckBox {
                            text: modelData.subtag || ""
                            checked: {
                                for (var i = 0; i < galleryRoot.selectedTags.length; i++) {
                                    var t = galleryRoot.selectedTags[i]
                                    if (t.parent === modelData.parent && t.subtag === modelData.subtag)
                                        return true
                                }
                                return false
                            }
                            onCheckedChanged: {
                                var tags = galleryRoot.selectedTags.slice()
                                if (checked) {
                                    tags.push({parent: modelData.parent, subtag: modelData.subtag})
                                } else {
                                    tags = tags.filter(function(t) {
                                        return !(t.parent === modelData.parent && t.subtag === modelData.subtag)
                                    })
                                }
                                galleryRoot.selectedTags = tags
                            }
                        }
                    }
                }
            }
        }
    }

    ImagePopup {
        id: imagePopup
        x: (galleryRoot.width - width) / 2
        y: (galleryRoot.height - height) / 2
    }

    Connections {
        target: fileHandler
        function onUploadComplete() {
            folderModel.folder = fileHandler.folderPath
        }
    }

    FolderListModel {
        id: folderModel
        folder: fileHandler.folderPath
        nameFilters: ["*.png","*.jpg","*.jpeg","*.bmp"]
        showDirs: false
    }

    GridView {
        id: imageViewer
        Layout.fillWidth: true
        Layout.fillHeight: true

        property int columns: 4
        property int spacing: 10

        model: folderModel
        cellWidth: width > 0 ? width / columns : 200
        cellHeight: 220

        delegate: Item {
            width: imageViewer.cellWidth
            height: imageViewer.cellHeight
            visible: galleryRoot.imageMatchesFilters(folderModel.folder + "/" + fileName)

            Column {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 5

                Image {
                    source: folderModel.folder + "/" + fileName
                    width: parent.width
                    height: parent.height - 30
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: fileName
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    galleryRoot.selectedImage = folderModel.folder + "/" + fileName
                    galleryRoot.imageSelected(galleryRoot.selectedImage)
                    imagePopup.folderPath = folderModel.folder
                    imagePopup.fileName = fileName
                    imagePopup.open()
                }

                onEntered: parent.scale = 1.05
                onExited: parent.scale = 1.0
            }
        }
    }
}
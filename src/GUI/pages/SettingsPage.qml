import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../parts"
import "../styles"

// Settings screen that allows you to change certain variables about the application

Page {
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TopBar {
            id: topBar
            Layout.preferredHeight: parent.height * 0.1
            Layout.bottomMargin: 20
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: availableWidth

            GridLayout {
                id: settingsGrid
                width: parent.width
                columns: 1
                columnSpacing: 20
                rowSpacing: 20

                Rectangle {
                    Layout.fillWidth: true
                    height: 80
                    radius: 8
                    color: "#1e2a3a"
                    ColumnLayout {
                        anchors.fill: parent

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            ColumnLayout {
                                Text { text: "Frequency"; font.bold: true }
                                Text { text: "Changes how often the system changes your background" }
                            }

                            ColumnLayout {
                                spacing: 4
                                RowLayout {
                                    spacing: 8
                                    TextField {
                                        id: frequencyField
                                        text: settingsHandler.getFrequency
                                        implicitWidth: 120
                                    }
                                    Button {
                                        text: "Submit"
                                        onClicked: {
                                            settingsHandler.setFrequency(parseInt(frequencyField.text))
                                            fileHandler.save_settings()
                                            frequencyField.text = settingsHandler.getFrequency
                                        }
                                    }
                                    Button {
                                        text: "Default"
                                        onClicked: {
                                            settingsHandler.setFrequency(settingsHandler.defaultFrequency)
                                            fileHandler.save_settings()
                                            frequencyField.text = settingsHandler.getFrequency
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                //Change Priority Setting
                Rectangle {
                    Layout.fillWidth: true
                    height: 80
                    radius: 8
                    color: "#1e2a3a"
                    ColumnLayout {
                        anchors.fill: parent

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            ColumnLayout {
                                Text { text: "Priority"; font.bold: true }
                                Text { text: "Changes the order in which tags are applied" }
                            }

                            ColumnLayout {
                                spacing: 4
                                RowLayout {
                                    spacing: 8

                                    //dropdown of tags
                                    ComboBox {
                                        id: priorityTags
                                        model: tagHandler.dropdownItems
                                        textRole: "subtag"

                                        displayText: currentIndex >= 0 ? currentText : "Select a tag..."

                                        delegate: ItemDelegate {
                                            width: parent.width

                                            // allows for header groups in dropdown
                                            visible: true
                                            enabled: !modelData["header"]

                                            contentItem: Text {
                                                text: modelData["header"] ? modelData["parent"] : "    " + modelData["subtag"]
                                                font.bold: modelData["header"]
                                                color: modelData["header"] ? "gray" : "black"
                                            }
                                        }

                                        onCurrentIndexChanged: {
                                            let item = tagHandler.dropdownItems[currentIndex]

                                            if (item && !item.header) {
                                                priorityField.value = settingsHandler.getPriority(item.subtag)
                                            }
                                        }
                                    }

                                    //Text to input priority TODO: finish priority python code before this
                                    SpinBox {
                                        id: priorityField
                                        from: 1
                                        to: 10
                                        stepSize: 1
                                        value: 5
                                        editable: true
                                    }

                                    Button {
                                        text: "Submit"
                                        onClicked: {
                                            let item = tagHandler.dropdownItems[priorityTags.currentIndex]
                                            if (item && !item.header) {
                                                settingsHandler.setPriority(priorityField.value, item.subtag)
                                                fileHandler.save_settings()
                                                priorityField.value = settingsHandler.getPriority(item.subtag)
                                            }
                                        }
                                    }

                                    Button {
                                        text: "Default"
                                        onClicked: {
                                            let item = tagHandler.dropdownItems[priorityTags.currentIndex]
                                            if (item && !item.header) {
                                                settingsHandler.setPriority(settingsHandler.defaultPriority, item.subtag)
                                                fileHandler.save_settings()
                                                priorityField.value = settingsHandler.getPriority(item.subtag)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
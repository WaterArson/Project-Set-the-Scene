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

            ColumnLayout {
                id: settingsGrid
                width: parent.width
                spacing: 20

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

                Rectangle {
                    Layout.fillWidth: true
                    radius: 8
                    color: "#1e2a3a"
                    height: sensitivityColumn.implicitHeight + 24

                    property var sensitivityChecked: ({})

                    ColumnLayout {
                        id: sensitivityColumn
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        RowLayout {
                            Layout.fillWidth: true

                            ColumnLayout {
                                Text { text: "Sensitivity"; font.bold: true; color: "white" }
                                Text { text: "Changes how sensitive the system is to changes in your environment"; color: "white" }
                            }

                            ComboBox {
                                id: sensitivityField
                                implicitWidth: 160
                                model: tagHandler.dropdownItems
                                textRole: "subtag"
                                displayText: currentIndex >= 0 ? currentText : "Select a tag..."
                                delegate: ItemDelegate {
                                    width: parent.width
                                    enabled: !modelData["header"]
                                    contentItem: Text {
                                        text: modelData["header"] ? modelData["parent"] : "    " + modelData["subtag"]
                                        font.bold: modelData["header"]
                                        color: modelData["header"] ? "gray" : "white"
                                    }
                                }
                            }
                        }

                        // second box, only visible when a subtag is selected
                        Rectangle {
                            Layout.fillWidth: true
                            height: 120
                            color: "#162030"
                            radius: 4
                            clip: true
                            visible: sensitivityField.currentIndex >= 0 &&
                                    !tagHandler.dropdownItems[sensitivityField.currentIndex]["header"]

                            ScrollView {
                                anchors.fill: parent

                                ListView {
                                    id: subtagList
                                    width: parent.width
                                    model: [] // TODO: define what populates this based on selected tag

                                    delegate: Row {
                                        width: parent.width
                                        spacing: 6
                                        CheckBox {
                                            id: subtagCheck
                                            palette.text: "white"
                                            onCheckedChanged: {
                                                let updated = Object.assign({}, parent.parent.parent.sensitivityChecked)
                                                updated[modelData] = checked
                                                parent.parent.parent.sensitivityChecked = updated
                                            }
                                        }
                                        Text {
                                            text: modelData
                                            color: "white"
                                            anchors.verticalCenter: subtagCheck.verticalCenter
                                        }
                                    }
                                }
                            }
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignRight
                            visible: sensitivityField.currentIndex >= 0 &&
                                    !tagHandler.dropdownItems[sensitivityField.currentIndex]["header"]

                            Button {
                                text: "Submit"
                                onClicked: {
                                    let selected = sensitivityField.model[sensitivityField.currentIndex]
                                    settingsHandler.setSensitivity(selected["parent"], selected["subtag"])
                                    fileHandler.save_settings()
                                }
                            }
                            Button {
                                text: "Default"
                                onClicked: {
                                    sensitivityField.currentIndex = -1
                                    settingsHandler.setSensitivity(null, null)
                                    fileHandler.save_settings()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
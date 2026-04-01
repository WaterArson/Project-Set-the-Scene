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
                columns: 2
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
            }
        }
    }
}
import Quickshell
import QtQuick

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 24
            color: "transparent"

            margins {
                top: 4
            }

            // left: workspaces
            Workspaces {
                anchors.left: parent.left
                anchors.leftMargin: 10
                colBg: "#1a1b26"
                border.color: "#c0caf5"
                border.width: 1
                radius: 8
            }

            // center: clock + audio
            Row {
                anchors.centerIn: parent
                height: parent.height
                spacing: 8

                Rectangle {
                    width: 200
                    height: parent.height
                    color: "#1a1b26"
                    radius: 8
                    border.color: "#c0caf5"
                    border.width: 1

                    ClockWidget {
                        anchors.centerIn: parent
                    }
                }

                Audio {}
            }

            // right: tray + battery
            Row {
                anchors.right: parent.right
                anchors.rightMargin: 10
                height: parent.height
                spacing: 8

                Tray {}

                Rectangle {
                    width: 50
                    height: parent.height
                    radius: 8
                    color: "#1a1b26"
                    border.color: "#c0caf5"
                    border.width: 1

                    Battery {
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
}

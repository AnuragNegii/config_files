// Workspaces.qml
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: root

    property color colActive: "#cba6f7"
    property color colInactive: "#6c7086"
    property color colBg: "#1e1e2e"
    property color colHover: "#313244"
    property string fontFamily: "JetBrains Mono"
    property int fontSize: 12

    // only real workspaces (id > 0), sorted by number
    property var openWorkspaces: Hyprland.workspaces.values.filter(w => w.id > 0).sort((a, b) => a.id - b.id)

    implicitWidth: row.implicitWidth + 10
    implicitHeight: 24
    radius: 12
    color: colBg

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 2

        Repeater {
            model: root.openWorkspaces

            Rectangle {
                id: item
                required property var modelData
                property bool isActive: Hyprland.focusedWorkspace?.id === modelData.id

                implicitWidth: 24
                implicitHeight: 20
                radius: 8
                color: mouse.containsMouse ? root.colHover : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: item.modelData.id
                    color: item.isActive ? root.colActive : root.colInactive

                    font {
                        family: root.fontFamily
                        pixelSize: root.fontSize
                        bold: item.isActive
                    }
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + item.modelData.id + " })")
                }
            }
        }
    }
}

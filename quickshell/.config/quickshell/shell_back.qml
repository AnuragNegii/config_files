import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

PanelWindow {
    id: root

    property color colBg: "#1a1b26"
    property color colFg: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#0db9d7"
    property color colBlue: "#7aa2f7"
    property color colYellow: "#e0af68"

    property string fontFamily: "Fira Code"
    property int fontSize: 12

    property int cpuUsage: 0
    property int lastCpuIdle: 0
    property int lastCpuTotal: 0

    Process {
        id: cpuProc

        command: ["sh", "-c", "head -1 /proc/stat"]

        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                var p = data.trim().split(/\s+/);

                var idle = parseInt(p[4]) + parseInt(p[5]);

                var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);

                if (lastCpuTotal > 0) {
                    var totalDiff = total - lastCpuTotal;
                    var idleDiff = idle - lastCpuIdle;

                    if (totalDiff > 0) {
                        cpuUsage = Math.round(100 * (1 - idleDiff / totalDiff));
                    }
                }

                lastCpuTotal = total;
                lastCpuIdle = idle;
            }
        }

        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true

        onTriggered: cpuProc.running = true
    }

    anchors.top: true
    anchors.left: true
    anchors.right: true

    implicitHeight: 30
    color: root.colBg

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Repeater {
            model: 9

            Text {
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)

                property bool isActive: Hyprland.focusedWorkspace?.id === index + 1

                text: index + 1

                color: isActive ? root.colCyan : (ws ? root.colBlue : root.colMuted)

                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                    bold: true
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: "CPU: " + cpuUsage + "%"

            color: root.colYellow

            font {
                family: root.fontFamily
                pixelSize: root.fontSize
                bold: true
            }
        }
        RowLayout {
            spacing: 6
            Text {
                id: batteryText

                property string battery: "?"

                text: battery + "%"

                color: root.colFg

                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                    bold: true
                }

                Process {
                    id: batteryProc

                    command: ["sh", "-c", "upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage"]

                    stdout: SplitParser {
                        onRead: data => {
                            var match = data.match(/(\d+)%/);

                            if (match)
                                batteryText.battery = match[1];
                        }
                    }

                    Component.onCompleted: running = true
                }

                Timer {
                    interval: 30000
                    running: true
                    repeat: true

                    onTriggered: batteryProc.running = true
                }
            }
        }
    }
}

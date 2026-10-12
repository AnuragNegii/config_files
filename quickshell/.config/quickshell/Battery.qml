// BatteryWidget.qml
import Quickshell.Io
import QtQuick

Text {
    id: batteryText

    property string battery: "?"

    text: battery + "%"
    color: "#c0caf5"
    font.pixelSize: 14
    font.bold: true

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

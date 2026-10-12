// ClockWidget.qml
import QtQuick

Rectangle {

    Text {
				anchors.centerIn: parent
        text: Time.time
        color: "#c0caf5"
    }
}

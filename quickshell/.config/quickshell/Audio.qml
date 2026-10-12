// Audio.qml
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property color colBg: "#1a1b26"
    property color colText: "#c0caf5"
    property color colMuted: "#565f89"
    property color colHover: "#313244"
    property color colAccent: "#cba6f7"
    property color colBorder: "#c0caf5"
    property string fontFamily: "JetBrains Mono"
    property int fontSize: 12

    property var sink: Pipewire.defaultAudioSink
    property real volume: sink?.audio?.volume ?? 0
    property bool muted: sink?.audio?.muted ?? false

    // real output devices only (not app streams)
    property var sinks: Pipewire.nodes.values.filter(n => n.isSink && !n.isStream)

    function setVolume(v) {
        if (sink?.audio)
            sink.audio.volume = Math.max(0, Math.min(1, v));
    }

    function deviceName(n) {
        return n.nickname || n.description || n.name;
    }

    // needed so the audio properties (volume, muted) are readable
    PwObjectTracker {
        objects: [root.sink]
    }

    implicitWidth: label.implicitWidth + 20
    implicitHeight: 24
    radius: 8
    color: colBg
    border.color: colBorder
    border.width: 1

    Text {
        id: label
        anchors.centerIn: parent
        text: root.muted || root.volume === 0 ? "🔇" : root.volume < 0.34 ? "🔈" : root.volume < 0.67 ? "🔉" : "🔊"
        color: root.muted ? root.colMuted : root.colText
        font.pixelSize: 13
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        onClicked: event => {
            if (event.button === Qt.MiddleButton) {
                if (root.sink?.audio)
                    root.sink.audio.muted = !root.sink.audio.muted;
            } else {
                popup.visible = !popup.visible;
            }
        }

        // scroll on the pill to change volume
        onWheel: wheel => root.setVolume(root.volume + (wheel.angleDelta.y > 0 ? 0.05 : -0.05))
    }

    PopupWindow {
        id: popup

        anchor.item: root
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        anchor.adjustment: PopupAdjustment.All

        implicitWidth: box.implicitWidth
        implicitHeight: box.implicitHeight + 8
        color: "transparent"
        visible: false

        HyprlandFocusGrab {
            windows: [popup]
            active: popup.visible
            onCleared: popup.visible = false
        }

        Rectangle {
            id: box
            y: 8
            implicitWidth: 260
            implicitHeight: col.implicitHeight + 20
            radius: 8
            color: root.colBg
            border.color: root.colBorder
            border.width: 1

            ColumnLayout {
                id: col
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                // volume row: mute button + slider + percent
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        implicitWidth: 44
                        implicitHeight: 22
                        radius: 6
                        color: muteMouse.containsMouse ? root.colHover : "transparent"
                        border.color: root.colMuted
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: root.muted ? "Unmute" : "Mute"
                            color: root.muted ? root.colAccent : root.colText
                            font.family: root.fontFamily
                            font.pixelSize: 10
                        }

                        MouseArea {
                            id: muteMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (root.sink?.audio)
                                    root.sink.audio.muted = !root.sink.audio.muted;
                            }
                        }
                    }

                    // custom slider
                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 22

                        Rectangle {
                            id: track
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 6
                            radius: 3
                            color: root.colHover

                            Rectangle {
                                width: track.width * root.volume
                                height: parent.height
                                radius: 3
                                color: root.muted ? root.colMuted : root.colAccent
                            }
                        }

                        Rectangle {
                            x: track.width * root.volume - width / 2
                            anchors.verticalCenter: parent.verticalCenter
                            width: 12
                            height: 12
                            radius: 6
                            color: root.colText
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: mouse => root.setVolume(mouse.x / width)
                            onPositionChanged: mouse => root.setVolume(mouse.x / width)
                        }
                    }

                    Text {
                        text: Math.round(root.volume * 100) + "%"
                        color: root.colText
                        font.family: root.fontFamily
                        font.pixelSize: root.fontSize
                        Layout.preferredWidth: 36
                        horizontalAlignment: Text.AlignRight
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: root.colMuted
                    opacity: 0.5
                }

                Text {
                    text: "Output device"
                    color: root.colMuted
                    font.family: root.fontFamily
                    font.pixelSize: 10
                }

                // device list
                Repeater {
                    model: root.sinks

                    Rectangle {
                        id: dev
                        required property var modelData
                        property bool isDefault: root.sink && root.sink.id === modelData.id

                        Layout.fillWidth: true
                        implicitHeight: 26
                        radius: 6
                        color: devMouse.containsMouse ? root.colHover : "transparent"

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            text: (dev.isDefault ? "● " : "○ ") + root.deviceName(dev.modelData)
                            color: dev.isDefault ? root.colAccent : root.colText
                            elide: Text.ElideRight
                            font.family: root.fontFamily
                            font.pixelSize: root.fontSize
                            font.bold: dev.isDefault
                        }

                        MouseArea {
                            id: devMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Pipewire.preferredDefaultAudioSink = dev.modelData
                        }
                    }
                }
            }
        }
    }
}

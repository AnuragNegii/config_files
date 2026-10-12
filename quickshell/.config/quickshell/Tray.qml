// Tray.qml
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property color colBg: "#1a1b26"
    property color colText: "#c0caf5"
    property color colMuted: "#565f89"
    property color colHover: "#313244"
    property color colBorder: "#c0caf5"
    property string fontFamily: "JetBrains Mono"
    property int fontSize: 12

    visible: SystemTray.items.values.length > 0
    implicitWidth: row.implicitWidth + 16
    implicitHeight: 24
    radius: 8
    color: colBg
    border.color: colBorder
    border.width: 1

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: SystemTray.items

            Rectangle {
                id: item
                required property var modelData

                implicitWidth: 20
                implicitHeight: 20
                radius: 6
                color: mouse.containsMouse ? root.colHover : "transparent"

                IconImage {
                    anchors.centerIn: parent
                    implicitSize: 16
                    source: item.modelData.icon
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                    onClicked: event => {
                        if (event.button === Qt.LeftButton)
                            item.modelData.activate();
                        else if (event.button === Qt.MiddleButton)
                            item.modelData.secondaryActivate();
                        else if (item.modelData.hasMenu)
                            popup.visible = !popup.visible;
                    }
                }

                PopupWindow {
                    id: popup

                    // the menu currently shown (changes when entering a submenu)
                    property var currentMenu: item.modelData.menu

                    anchor.item: item
                    anchor.edges: Edges.Bottom
                    anchor.gravity: Edges.Bottom
                    anchor.adjustment: PopupAdjustment.All

                    implicitWidth: box.implicitWidth
                    implicitHeight: box.implicitHeight + 8
                    color: "transparent"
                    visible: false

                    onVisibleChanged: if (!visible) currentMenu = item.modelData.menu

                    // close when clicking anywhere else
                    HyprlandFocusGrab {
                        windows: [popup]
                        active: popup.visible
                        onCleared: popup.visible = false
                    }

                    QsMenuOpener {
                        id: opener
                        menu: popup.currentMenu
                    }

                    Rectangle {
                        id: box
                        y: 8
                        implicitWidth: Math.max(160, col.implicitWidth + 16)
                        implicitHeight: col.implicitHeight + 12
                        radius: 8
                        color: root.colBg
                        border.color: root.colBorder
                        border.width: 1

                        ColumnLayout {
                            id: col
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 2

                            // back button when inside a submenu
                            Rectangle {
                                visible: popup.currentMenu !== item.modelData.menu
                                Layout.fillWidth: true
                                implicitHeight: 24
                                radius: 6
                                color: backMouse.containsMouse ? root.colHover : "transparent"

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    text: "‹  Back"
                                    color: root.colMuted
                                    font.family: root.fontFamily
                                    font.pixelSize: root.fontSize
                                }

                                MouseArea {
                                    id: backMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: popup.currentMenu = item.modelData.menu
                                }
                            }

                            Repeater {
                                model: opener.children

                                Rectangle {
                                    id: entry
                                    required property var modelData

                                    Layout.fillWidth: true
                                    implicitHeight: modelData.isSeparator ? 7 : 24
                                    implicitWidth: label.implicitWidth + 28
                                    radius: 6
                                    color: !modelData.isSeparator && entryMouse.containsMouse && modelData.enabled
                                           ? root.colHover : "transparent"

                                    // separator line
                                    Rectangle {
                                        visible: entry.modelData.isSeparator
                                        anchors.centerIn: parent
                                        width: parent.width - 8
                                        height: 1
                                        color: root.colMuted
                                    }

                                    Text {
                                        id: label
                                        visible: !entry.modelData.isSeparator
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.left: parent.left
                                        anchors.leftMargin: 8
                                        text: entry.modelData.text
                                        color: entry.modelData.enabled ? root.colText : root.colMuted
                                        font.family: root.fontFamily
                                        font.pixelSize: root.fontSize
                                    }

                                    Text {
                                        visible: entry.modelData.hasChildren
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.right: parent.right
                                        anchors.rightMargin: 8
                                        text: "›"
                                        color: root.colMuted
                                        font.pixelSize: root.fontSize
                                    }

                                    MouseArea {
                                        id: entryMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        enabled: !entry.modelData.isSeparator && entry.modelData.enabled

                                        onClicked: {
                                            if (entry.modelData.hasChildren) {
                                                popup.currentMenu = entry.modelData;
                                            } else {
                                                entry.modelData.triggered();
                                                popup.visible = false;
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

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    focusable: true

    anchors.top: true
    anchors.left: true
    anchors.right: true
    margins.top: 4
    margins.left: 4
    margins.right: 4
    implicitHeight: 28

    color: "transparent"

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: Qt.rgba(Colors.background.r, Colors.background.g, Colors.background.b, 0.25)
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 6
        anchors.rightMargin: 6

        Item { Layout.fillWidth: true }

        Rectangle {
            color: Colors.backgroundLight
            radius: 6
            implicitWidth: dotsRow.implicitWidth + 12
            implicitHeight: 22

            Row {
                id: dotsRow
                anchors.centerIn: parent
                spacing: 6

                property var hyprMonitor: Hyprland.monitors.values.find(m => m.name === screen?.name)
                property int wsStart: 11
                property int wsEnd: 12

                Repeater {
                    model: parent.wsEnd - parent.wsStart + 1

                    Item {
                        property int wsId: parent.wsStart + index
                        property var ws: Hyprland.workspaces.values.find(w => w.id === wsId)
                        property bool isActive: parent.hyprMonitor?.activeWorkspace?.id === wsId
                        property bool hasWindows: ws !== undefined

                        width: isActive ? 24 : (hasWindows ? 16 : 10)
                        height: 10

                        Behavior on width {
                            NumberAnimation { duration: 250; easing.type: Easing.OutBack }
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: height / 2
                            color: isActive ? Colors.accent :
                                   (hasWindows ? Colors.workspaceOccupied : Colors.workspaceEmpty)

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Hyprland.dispatch("hl.dsp.focus({workspace = " + wsId + "})")
                        }
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }
    }
}

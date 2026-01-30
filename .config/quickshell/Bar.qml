import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    property bool isVertical: false

    anchors.top: true
    anchors.left: true
    anchors.right: true
    margins.top: 7
    margins.left: 7
    margins.right: 7
    implicitHeight: 40

    color: "transparent"

    // Outer rounded background with 75% opacity
    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Qt.rgba(Colors.background.r, Colors.background.g, Colors.background.b, 0.25)
    }

    // System data (main bar only)
    property int cpuUsage: 0
    property int memUsage: 0
    property int lastCpuIdle: 0
    property int lastCpuTotal: 0

    // Volume state from wpctl
    property int volumePercent: 0
    property bool volumeMuted: false
    property bool micMuted: false

    Process {
        id: cpuProc
        running: false
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var p = data.trim().split(/\s+/)
                var idle = parseInt(p[4]) + parseInt(p[5])
                var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
                if (root.lastCpuTotal > 0) {
                    root.cpuUsage = Math.round(100 * (1 - (idle - root.lastCpuIdle) / (total - root.lastCpuTotal)))
                }
                root.lastCpuTotal = total
                root.lastCpuIdle = idle
            }
        }
    }

    Process {
        id: memProc
        running: false
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var total = parseInt(parts[1]) || 1
                var used = parseInt(parts[2]) || 0
                root.memUsage = Math.round(100 * used / total)
            }
        }
    }

    Timer {
        interval: 2000
        running: !isVertical
        repeat: true
        onTriggered: { cpuProc.running = true; memProc.running = true }
        Component.onCompleted: if (!isVertical) { cpuProc.running = true; memProc.running = true }
    }

    Process {
        id: volProc
        running: false
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                // Format: "Volume: 0.95" or "Volume: 0.95 [MUTED]"
                var match = data.match(/Volume:\s*([\d.]+)/)
                if (match) {
                    root.volumePercent = Math.round(parseFloat(match[1]) * 100)
                }
                root.volumeMuted = data.includes("[MUTED]")
            }
        }
    }

    Process {
        id: micProc
        running: false
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SOURCE@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                root.micMuted = data.includes("[MUTED]")
            }
        }
    }

    Timer {
        interval: 500
        running: !isVertical
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            volProc.running = true
            micProc.running = true
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 7
        anchors.rightMargin: 7
        spacing: 7

        // Badge: Logo + Workspaces
        Rectangle {
            color: Colors.backgroundLight
            radius: 8
            implicitWidth: leftContent.implicitWidth + 16
            implicitHeight: 32

            RowLayout {
                id: leftContent
                anchors.centerIn: parent
                spacing: 10

                // Arch logo (main only) - opens power menu
                Text {
                    visible: !isVertical
                    text: "\uf303"
                    color: mouseArea.containsMouse ? Colors.accentBright : Colors.accent
                    font.family: Colors.fontFamily
                    font.pixelSize: 24

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("exec rofi-power-menu")
                    }
                }

                Row {
                    spacing: 8

                    // Find this bar's Hyprland monitor
                    property var hyprMonitor: Hyprland.monitors.values.find(m => m.name === screen?.name)
                    // DP-2 (main) = workspaces 1-5, DP-3 (vertical) = workspaces 6-10
                    property int wsStart: screen?.name === "DP-3" ? 6 : 1
                    property int wsEnd: screen?.name === "DP-3" ? 10 : 5

                    Repeater {
                        model: parent.wsEnd - parent.wsStart + 1

                        Item {
                            property int wsId: parent.wsStart + index
                            property var ws: Hyprland.workspaces.values.find(w => w.id === wsId)
                            property bool isActive: parent.hyprMonitor?.activeWorkspace?.id === wsId
                            property bool hasWindows: ws !== undefined

                            // Container width changes based on state
                            width: isActive ? 32 : (hasWindows ? 20 : 14)
                            height: 14

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
                                onClicked: Hyprland.dispatch("workspace " + wsId)
                            }
                        }
                    }
                }
            }
        }

        // Badge: Window title
        Rectangle {
            Layout.fillWidth: true
            color: Colors.backgroundLight
            radius: 8
            implicitHeight: 32

            Text {
                anchors.centerIn: parent
                width: parent.width - 16
                property var hyprMon: Hyprland.monitors.values.find(m => m.name === screen?.name)
                property var activeWs: hyprMon?.activeWorkspace
                property bool focusedOnThisMonitor: Hyprland.focusedClient?.monitor?.name === screen?.name
                text: focusedOnThisMonitor ? (Hyprland.focusedClient?.title ?? "") : ""
                color: Colors.foreground
                font.family: Colors.fontFamily
                font.pixelSize: 14
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // Badge: System Tray
        Rectangle {
            visible: SystemTray.items.length > 0
            color: Colors.backgroundLight
            radius: 8
            implicitWidth: trayContent.implicitWidth + 16
            implicitHeight: 32

            RowLayout {
                id: trayContent
                anchors.centerIn: parent
                spacing: 6

                Repeater {
                    model: SystemTray.items

                    Image {
                        required property SystemTrayItem modelData

                        source: modelData.icon
                        sourceSize.width: 20
                        sourceSize.height: 20

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: event => {
                                if (event.button === Qt.LeftButton) {
                                    modelData.activate()
                                } else if (event.button === Qt.RightButton) {
                                    modelData.secondaryActivate()
                                }
                            }
                        }
                    }
                }
            }
        }

        // Badge: Audio (Volume + Mic) - main only
        Rectangle {
            visible: !isVertical
            color: Colors.backgroundLight
            radius: 8
            implicitWidth: audioContent.implicitWidth + 16
            implicitHeight: 32

            RowLayout {
                id: audioContent
                anchors.centerIn: parent
                spacing: 10

                // Volume
                RowLayout {
                    spacing: 6

                    Text {
                        id: volumeIcon
                        text: root.volumeMuted ? "\udb81\udf5f" :
                              root.volumePercent > 66 ? "\udb81\udd7e" :
                              root.volumePercent > 33 ? "\udb81\udd80" : "\udb81\udd7f"
                        color: root.volumeMuted ? Colors.red : Colors.green
                        font.family: Colors.fontFamily
                        font.pixelSize: 22

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            cursorShape: Qt.PointingHandCursor
                            onClicked: event => {
                                if (event.button === Qt.RightButton) {
                                    Hyprland.dispatch("exec ~/dotfiles/scripts/rofi-audio-sink.sh")
                                } else {
                                    Hyprland.dispatch("exec pactl set-sink-mute @DEFAULT_SINK@ toggle")
                                    volProc.running = true
                                }
                            }
                            onWheel: event => {
                                if (event.angleDelta.y > 0) {
                                    Hyprland.dispatch("exec pactl set-sink-volume @DEFAULT_SINK@ +5%")
                                } else {
                                    Hyprland.dispatch("exec pactl set-sink-volume @DEFAULT_SINK@ -5%")
                                }
                                volProc.running = true
                            }
                        }
                    }

                    Text {
                        text: root.volumePercent + "%"
                        color: Colors.foreground
                        font.family: Colors.fontFamily
                        font.pixelSize: 14
                    }
                }

                // Mic
                Text {
                    id: micIcon
                    text: root.micMuted ? "\udb80\udf6d" : "\udb80\udf6c"
                    color: root.micMuted ? Colors.red : Colors.cyan
                    font.family: Colors.fontFamily
                    font.pixelSize: 22

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        cursorShape: Qt.PointingHandCursor
                        onClicked: event => {
                            if (event.button === Qt.RightButton) {
                                Hyprland.dispatch("exec ~/dotfiles/scripts/rofi-audio-source.sh")
                            } else {
                                Hyprland.dispatch("exec pactl set-source-mute @DEFAULT_SOURCE@ toggle")
                                micProc.running = true
                            }
                        }
                    }
                }
            }
        }

        // Badge: System Stats (CPU + Memory) - main only
        Rectangle {
            visible: !isVertical
            color: Colors.backgroundLight
            radius: 8
            implicitWidth: statsContent.implicitWidth + 16
            implicitHeight: 32

            RowLayout {
                id: statsContent
                anchors.centerIn: parent
                spacing: 12

                // CPU
                RowLayout {
                    spacing: 6
                    Text { text: "\udb81\ude1a"; color: Colors.yellow; font.family: Colors.fontFamily; font.pixelSize: 22 }
                    Text { text: root.cpuUsage + "%"; color: Colors.foreground; font.family: Colors.fontFamily; font.pixelSize: 14 }
                }

                // Memory
                RowLayout {
                    spacing: 6
                    Text { text: "\udb80\udf5b"; color: Colors.magenta; font.family: Colors.fontFamily; font.pixelSize: 22 }
                    Text { text: root.memUsage + "%"; color: Colors.foreground; font.family: Colors.fontFamily; font.pixelSize: 14 }
                }
            }
        }

        // Badge: Network + Bluetooth - vertical only
        Rectangle {
            visible: isVertical
            color: Colors.backgroundLight
            radius: 8
            implicitWidth: netBtContent.implicitWidth + 16
            implicitHeight: 32

            RowLayout {
                id: netBtContent
                anchors.centerIn: parent
                spacing: 10

                Text {
                    text: "\udb80\ude00"
                    color: Colors.green
                    font.family: Colors.fontFamily
                    font.pixelSize: 22
                }

                Text {
                    text: "\udb80\udcaf"
                    color: Colors.blue
                    font.family: Colors.fontFamily
                    font.pixelSize: 22
                }
            }
        }

        // Badge: Clock
        Rectangle {
            color: Colors.backgroundLight
            radius: 8
            implicitWidth: clockContent.implicitWidth + 16
            implicitHeight: 32

            RowLayout {
                id: clockContent
                anchors.centerIn: parent
                spacing: 8

                Text {
                    visible: !isVertical
                    text: "\udb82\udd54"
                    color: Colors.blue
                    font.family: Colors.fontFamily
                    font.pixelSize: 22
                }

                Text {
                    id: clock
                    color: Colors.foreground
                    font.family: Colors.fontFamily
                    font.pixelSize: 14

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        triggeredOnStart: true
                        onTriggered: clock.text = isVertical
                            ? Qt.formatDateTime(new Date(), "hh:mm AP")
                            : Qt.formatDateTime(new Date(), "ddd MMM dd  hh:mm:ss AP")
                    }
                }
            }
        }
    }
}

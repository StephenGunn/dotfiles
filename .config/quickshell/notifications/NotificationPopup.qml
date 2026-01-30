import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../"

PopupWindow {
    id: popup

    property var notification
    property int index: 0
    property bool exiting: false

    signal dismissed()
    signal exitFinished()

    visible: true
    anchor.rect.x: screen ? screen.width - width - 14 : 0
    anchor.rect.y: 14 + index * (height + 8)
    anchor.window: Quickshell.Wayland.Toplevel

    implicitWidth: 380
    implicitHeight: contentColumn.implicitHeight + 24

    color: "transparent"

    // Auto-dismiss timer
    Timer {
        id: dismissTimer
        interval: notification?.expireTimeout > 0 ? notification.expireTimeout * 1000 : 5000
        running: !mouseArea.containsMouse && !exiting
        onTriggered: popup.startExit()
    }

    // Exit animation
    NumberAnimation {
        id: exitAnimation
        target: background
        property: "opacity"
        from: 1
        to: 0
        duration: 200
        onFinished: {
            popup.visible = false
            popup.exitFinished()
        }
    }

    // Enter animation
    NumberAnimation {
        id: enterAnimation
        target: background
        property: "x"
        from: 50
        to: 0
        duration: 250
        easing.type: Easing.OutCubic
    }

    function startExit() {
        if (exiting) return
        exiting = true
        exitAnimation.start()
    }

    Component.onCompleted: {
        enterAnimation.start()
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (notification) notification.dismiss()
            popup.dismissed()
            popup.startExit()
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        anchors.margins: 4
        radius: 12
        color: Qt.rgba(Colors.background.r, Colors.background.g, Colors.background.b, 0.95)
        border.color: Colors.separator
        border.width: 1

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            // Header: App name + close button
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                // App icon
                Image {
                    visible: notification?.appIcon ?? false
                    source: notification?.appIcon ?? ""
                    sourceSize.width: 20
                    sourceSize.height: 20
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                }

                // App name
                Text {
                    text: notification?.appName ?? "Notification"
                    color: Colors.foregroundDim
                    font.family: Colors.fontFamily
                    font.pixelSize: 12
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                // Close button
                Text {
                    text: "\u00d7"
                    color: closeArea.containsMouse ? Colors.red : Colors.foregroundDim
                    font.pixelSize: 16
                    font.bold: true

                    MouseArea {
                        id: closeArea
                        anchors.fill: parent
                        anchors.margins: -4
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (notification) notification.dismiss()
                            popup.dismissed()
                            popup.startExit()
                        }
                    }
                }
            }

            // Title
            Text {
                visible: (notification?.summary ?? "") !== ""
                text: notification?.summary ?? ""
                color: Colors.foreground
                font.family: Colors.fontFamily
                font.pixelSize: 14
                font.bold: true
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }

            // Body
            Text {
                visible: (notification?.body ?? "") !== ""
                text: notification?.body ?? ""
                color: Colors.foregroundDim
                font.family: Colors.fontFamily
                font.pixelSize: 13
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                maximumLineCount: 4
                elide: Text.ElideRight
            }

            // Actions
            RowLayout {
                visible: notification?.actions?.length > 0
                Layout.fillWidth: true
                spacing: 8

                Repeater {
                    model: notification?.actions ?? []

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 28
                        radius: 6
                        color: actionArea.containsMouse ? Colors.backgroundLight : "transparent"
                        border.color: Colors.separator
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData.text ?? ""
                            color: Colors.accent
                            font.family: Colors.fontFamily
                            font.pixelSize: 12
                        }

                        MouseArea {
                            id: actionArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData.invoke) modelData.invoke()
                                popup.startExit()
                            }
                        }
                    }
                }
            }

            // Progress bar (if hint exists)
            Rectangle {
                visible: notification?.hints?.value !== undefined
                Layout.fillWidth: true
                implicitHeight: 4
                radius: 2
                color: Colors.separator

                Rectangle {
                    width: parent.width * ((notification?.hints?.value ?? 0) / 100)
                    height: parent.height
                    radius: 2
                    color: Colors.accent
                }
            }
        }
    }
}

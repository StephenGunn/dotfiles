import Quickshell
import Quickshell.Wayland
import QtQuick
import "."

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: Component {
            Bar {
                required property var modelData
                screen: modelData
                isVertical: modelData.name === "DP-3"
            }
        }
    }
}

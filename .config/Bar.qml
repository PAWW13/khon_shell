import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick

// PanelWindow
PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 34 // 36 px tall bar
    color: "transparent"//"#80e6be8a"

    Row {
        anchors.left: workspacesLeft ? parent.left : undefined
        anchors.right: workspacesLeft ? undefined : parent.right
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        Repeater {
            model: Hyprland.workspaces
            WorkspaceIcon {}
        }
    }

    SysStats {
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
    }
}

import Quickshell
import Quickshell.Wayland
import QtQuick

// PanelWindow
PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30 // 30px tall bar
    color: "transparent"

    Text {
        anchors.centerIn: parent
        text: "My First Bar"
        color: "#e6be8a"
        font.family: "Peapod Thai"
        font.pointSize: 10
    }
}

import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick

Rectangle {
    id: root
    height: 32
    implicitWidth: contentRow.implicitWidth + 16
    radius: 6
    color: ws.active ? "#3355ff" : "#222222"

    property var ws: modelData

    property var toplevels: ws.toplevels.values

    property var ordered: {
        const tops = toplevels
        return tops.filter(t => t.activated).concat(tops.filter(t => !t.activated))
    }

    property var appClasses: {
        const seen = []
        for (const t of ordered) {
            const ipc = t.lastIpcObject
            const cls = ipc ? ipc["class"] : ""
            if (cls && !seen.includes(cls))
                seen.push(cls)
        }
        return seen
    }

    Connections {
        target: ws.toplevels
        function onObjectInsertedPost() {Hyprland.refreshToplevels()}
    }

    Row {
        id: contentRow
        anchors.centerIn: parent
        //alignment: Row.AlignVCenter   // fix 2: was defaulting to AlignTop
        spacing: 6

        Repeater {
            model: root.appClasses
            delegate: IconImage {
                anchors.verticalCenter: parent.verticalCenter
                source: {
                    // referencing the index makes this binding re-run once
                    // DesktopEntries finishes loading (it's async at startup)
                    const entryCount = DesktopEntries.applications.values.length
                    const entry = entryCount > 0 ? DesktopEntries.heuristicLookup(modelData) : null
                    if (entry && entry.icon) {
                        // some .desktop files use absolute paths instead of icon names
                        return entry.icon.startsWith("/")
                            ? "file://" + entry.icon
                            : "image://icon/" + entry.icon + "?fallback=image-missing"
                    }
                    return "image://icon/image-missing"
                }
                width: 18
                height: 18
            }
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.ws.name
            color: "white"
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: ws.activate()
    }
}


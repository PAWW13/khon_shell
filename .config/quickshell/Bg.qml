import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            aboveWindows: false
            color: "transparent"
            anchors {
                top: true
                left: true
                bottom: true
                right: true
            }

            Image {
                id: bg
                anchors.fill: parent
                source: "lao_countryside.png"
                fillMode: Image.PreserveAspectCrop
                verticalAlignment: Image.AlignBottom
            }

            MultiEffect {
                source: bg
                anchors.fill: bg
                blurEnabled: true
                blurMax: 24
                blur: 1.0
            }

            Text {
                id: timetxt
                x: 1150
                y: 300
                font.family: "Peapod Thai"
                font.pointSize: 100
                font.bold: true
                color: "#e6be8a"

                Process {
                    id: dateProc
                    command: ["date", "+%H %M"]
                    running: true
                    stdout: SplitParser {
                        onRead: data => timetxt.text = data
                    }
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: dateProc.running = true
                }
            }
        }
    }
}

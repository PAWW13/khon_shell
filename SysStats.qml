import Quickshell
import Quickshell.Io
import QtQuick

Row {
    id: root
    spacing: 12

    property string cpu: "--"
    property string ram: "--"
    property string cpuTemp: "--"
    property var gpus: []

    Text { text: `CPU ${root.cpu}% ${root.cpuTemp}°`; color: "white" }
    Text { text: `RAM ${root.ram}%`; color: "white" }
    Text { text: root.gpus.join(" "); color: "white" }

    Process {
        id: cpuProc
        command: ["bash", "-c",
            "busy=$(vmstat 1 2 | tail -n1 | awk '{print 100-$15}'); " +
            "ram=$(awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{printf \"%d\", 100*(t-a)/t}' /proc/meminfo); " + "temp=$(for d in /sys/class/hwmon/hwmon*; do [ \"$(cat $d/name)\" = coretemp ] && { cat $d/temp1_input; break; }; done); " + "echo $busy $ram $((temp/1000))"]
        stdout: StdioCollector {
            onStreamFinished: {
                const p = this.text.trim().split(/\s+/)
                root.cpu = p[0]
                root.ram = p[1]
                root.cpuTemp = p[2]
            }
        }
    }

    Process {
        id: gpuProc
        command: ["nvidia-smi","--query-gpu=name,utilization.gpu,temperature.gpu,memory.used","--format=csv,noheader,nounits"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.gpus = this.text.trim().split("\n").map(line => {
                    const p = line.split(",").map(x => x.trim())
                    const short = p[0].replace("NVIDIA GeForce", "").replace("NVIDIA", "").trim()
                    return `${short} ${p[1]}% ${p[2]}°C ${p[3]}MiB`
                })
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: { cpuProc.running = true; gpuProc.running = true }
    }
}

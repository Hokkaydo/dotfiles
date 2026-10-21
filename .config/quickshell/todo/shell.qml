import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "Api.js" as Api
import "Theme.js" as Theme

ShellRoot {
    // Adapte ces deux valeurs à ton setup (IP/host du backend + token défini
    // côté serveur via TODO_API_TOKEN).
    property string apiUrl: "http://127.0.0.1:8000"
    property string apiToken: "un-token-long-et-random"

    PanelWindow {
        id: win

        anchors { top: true; right: true }
        margins { top: 48; right: 24 }
        implicitWidth: 320
        implicitHeight: 380
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-todo"
        exclusionMode: ExclusionMode.Ignore
        focusable: false

        property int pending: 0

        ListModel { id: tasksModel }

        function refresh() {
            Api.request("GET", apiUrl + "/tasks", apiToken, undefined, function (ok, data) {
                if (!ok || !data) return
                tasksModel.clear()
                for (var i = 0; i < data.tasks.length; i++)
                    tasksModel.append(data.tasks[i])
                win.pending = data.pending
            })
        }

        function toggleTask(id, isDone) {
            Api.request("PATCH", apiUrl + "/tasks/" + id, apiToken, { done: !isDone }, function (ok) {
                if (ok) win.refresh()
            })
        }

        function addTask(content) {
            var trimmed = content.trim()
            if (trimmed.length === 0) return
            Api.request("POST", apiUrl + "/tasks", apiToken, { content: trimmed }, function (ok) {
                if (ok) {
                    inputField.text = ""
                    win.refresh()
                }
            })
        }

        Timer {
            interval: 2000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: win.refresh()
        }

        Rectangle {
            anchors.fill: parent
            radius: 18
            color: Qt.rgba(0.118, 0.118, 0.180, 0.88)   // base, 88%
            border.width: 1
            border.color: Qt.rgba(0.796, 0.651, 0.969, 0.15) // mauve, 15%

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Tâches"
                        color: Theme.text
                        font.pixelSize: 16
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        radius: 999
                        color: Qt.rgba(0.796, 0.651, 0.969, 0.12)
                        implicitWidth: countLabel.implicitWidth + 16
                        implicitHeight: 20

                        Text {
                            id: countLabel
                            anchors.centerIn: parent
                            text: win.pending
                            color: Theme.mauve
                            font.pixelSize: 12
                            font.bold: true
                        }
                    }
                }

                ListView {
                    id: listView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: tasksModel
                    spacing: 2

                    add: Transition {
                        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 180 }
                        NumberAnimation { property: "y"; duration: 180; easing.type: Easing.OutCubic }
                    }
                    remove: Transition {
                        NumberAnimation { property: "opacity"; to: 0; duration: 140 }
                    }
                    displaced: Transition {
                        NumberAnimation { property: "y"; duration: 180; easing.type: Easing.OutCubic }
                    }

                    delegate: TaskRow {
                        width: listView.width
                        taskId: model.id
                        content: model.content
                        done: model.done === 1
                        onToggled: win.toggleTask(model.id, model.done === 1)
                    }

                    Text {
                        visible: tasksModel.count === 0
                        anchors.centerIn: parent
                        text: "Rien à faire 🌿"
                        color: Theme.overlay0
                        font.pixelSize: 13
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 32
                        radius: 10
                        color: Theme.surface0

                        TextInput {
                            id: inputField
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            verticalAlignment: TextInput.AlignVCenter
                            color: Theme.text
                            font.pixelSize: 13
                            clip: true
                            onAccepted: win.addTask(text)
                        }
                    }

                    Rectangle {
                        implicitWidth: 32
                        implicitHeight: 32
                        radius: 10
                        color: addArea.pressed ? Theme.green : Theme.mauve
                        Behavior on color { ColorAnimation { duration: 140 } }

                        Text {
                            anchors.centerIn: parent
                            text: "+"
                            font.bold: true
                            font.pixelSize: 16
                            color: Theme.base
                        }

                        MouseArea {
                            id: addArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: win.addTask(inputField.text)
                        }
                    }
                }
            }
        }
    }
}

import QtQuick
import "Theme.js" as Theme

Item {
    id: root
    property int taskId
    property string content
    property bool done
    signal toggled()

    implicitHeight: 34

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: 10
        color: hoverArea.containsMouse ? Theme.surface0 : "transparent"
        Behavior on color { ColorAnimation { duration: 160; easing.type: Easing.OutCubic } }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 8

        Text {
            id: checkMark
            anchors.verticalCenter: parent.verticalCenter
            text: root.done ? "●" : "○"
            color: root.done ? Theme.green : Theme.overlay0
            font.pixelSize: 13
            Behavior on color { ColorAnimation { duration: 160 } }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                cursorShape: Qt.PointingHandCursor
                onClicked: root.toggled()
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - checkMark.width - parent.spacing
            text: root.content
            color: root.done ? Theme.overlay0 : Theme.text
            font.pixelSize: 13
            font.strikeout: root.done
            elide: Text.ElideRight
            Behavior on color { ColorAnimation { duration: 160 } }
        }
    }
}

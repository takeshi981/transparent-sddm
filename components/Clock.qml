import QtQuick 2.15
import QtQuick.Controls 2.4

Column {
    id: clock
    spacing: 0
    width: parent.width / 2

    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 18
        font.family: localFont.name
        color: "#666666"
        renderType: Text.QtRendering

    }

    Label {
        id: timeLabel
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 36
        font.family: localFont.name
        color: "#666666"
        renderType: Text.QtRendering
        function updateTime() {
            text = new Date().toLocaleTimeString(Qt.locale(""), config.HourFormat == "long" ? Locale.LongFormat : "HH:mm" !== "" ? "HH:mm" : Locale.ShortFormat)
        }
    }

    Label {
        id: dateLabel
        font.pointSize: 18
        font.family: localFont.name
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#666666"
        renderType: Text.QtRendering
        function updateTime() {
            text = new Date().toLocaleDateString(Qt.locale(""), "dddd,d MMMM"  == "short" ? Locale.ShortFormat : "dddd,d MMMM" !== "" ? "dddd,d MMMM" : Locale.LongFormat)
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            dateLabel.updateTime()
            timeLabel.updateTime()
        }
    }

    Component.onCompleted: {
        dateLabel.updateTime()
        timeLabel.updateTime()
    }
}

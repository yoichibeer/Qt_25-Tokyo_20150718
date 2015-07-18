import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    width: 640
    height: 480

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        Rectangle {
            id: drawingView
            Layout.minimumWidth: 300
            Layout.fillWidth: true
            color: "lightgray"
            Text {
                text: "drawingView"
                anchors.centerIn: parent
            }
        }
        Rectangle {
            id: editView
            Layout.minimumWidth: 200
            width: 200
            color: "lightgreen"
            Text {
                text: "editView"
                anchors.centerIn: parent
            }
        }
    }

}

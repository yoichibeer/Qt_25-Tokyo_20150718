import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import Qt_24_Tokyo_20150718 1.0

Item {
    width: 640
    height: 480

    property alias mouseArea: mouseArea
    property alias squareBinding: squareBinding
    property alias square: square
    property alias xTextField: xTextField

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        Rectangle {
            id: drawingView
            Layout.minimumWidth: 300
            Layout.fillWidth: true
            color: "#081a5c"

            SquareBinding {
                id: squareBinding
                onXChanged:
                    textField1.text = x;
            }

            Rectangle {
                id: square
                width: 100
                height: 100
                x: squareBinding.x
                y: squareBinding.y
                color: "blue"

                property bool dragging;
                dragging: false

                MouseArea {
                    id: mouseArea

                    anchors.fill: parent

                    drag.target: square
                    drag.axis: Drag.XAndYAxis

                    drag.minimumX: - square.width + 5
                    drag.maximumX: drawingView.width - 5

                    drag.minimumY: - square.height + 5
                    drag.maximumY: drawingView.height - 5

                    onPressed: square.dragging = true
                    onReleased: square.dragging = false
                }
            }
        }

        Rectangle {
            id: editView
            Layout.minimumWidth: 200
            width: 200
            color: "#081a5c"

            TextField {
                id: xTextField
                x: 50
                y: 50
                placeholderText: qsTr("Text Field")
                text: squareBinding.x

//                Keys.onReturnPressed: squareBinding.x = text
            }
        }
    }

}

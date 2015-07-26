﻿import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.0

import Qt_24_Tokyo_20150718 1.0

ApplicationWindow {
    title: qsTr("Hello World")
    width: 640
    height: 480
    visible: true

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: messageDialog.show(qsTr("Open action triggered"));
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }

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
                    xTextField.text = x;
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

                    drag.threshold: 0

                    drag.minimumX: - square.width + 5
                    drag.maximumX: drawingView.width - 5

                    drag.minimumY: - square.height + 5
                    drag.maximumY: drawingView.height - 5

                    onPressed: square.dragging = true
                    onReleased: square.dragging = false

                    onPositionChanged: {
                        squareBinding.x = square.x
                        squareBinding.y = square.y
                    }
                }
//                onXChanged: {
//                    squareBinding.x = square.x
//                }
//                onYChanged: {
//                    squareBinding.y = square.y
//                }
            }
        }

        Rectangle {
            id: editView
            Layout.minimumWidth: 200
            width: 250
            color: "#081a5c"
            Column {
                spacing: 4
                TextField {
                    id: xTextField
                    placeholderText: qsTr("x")
                    text: squareBinding.x
                    KeyNavigation.tab: yTextField
                    onFocusChanged: {
                        updatePositionByPropertyChanged()
                    }
                    style:TextFieldStyle { ///@ todo 重複
                        id: textFieldStyle
                        textColor: "white"
                        background: Rectangle {
                            color: "#081a5c"
//                            radius: 2
//                            implicitWidth: 100
//                            implicitHeight: 24
                            border.color: "#000"
                            border.width: 1
                        }
                    }
                }
                TextField {
                    id: yTextField
                    placeholderText: qsTr("y")
                    text: squareBinding.y
                    KeyNavigation.tab: defaultButton
                    onFocusChanged: {
                        updatePositionByPropertyChanged()
                    }
                    style:TextFieldStyle {
                        textColor: "white"
                        background: Rectangle {
                            color: "#081a5c"
//                            radius: 2
//                            implicitWidth: 100
//                            implicitHeight: 24
                            border.color: "#000"
                            border.width: 1
                        }
                    }
                }

                Row {
                    spacing: 4

                    Button {
                        id: defaultButton
                        isDefault: true
                        activeFocusOnPress: true
                        text: "Apply"
                        onClicked: {
                            console.debug("defaultButton pressed")
                            squareBinding.x = xTextField.text
                        }

                        KeyNavigation.tab: grid
                    }
                    Text {
                        anchors.verticalCenter: defaultButton.verticalCenter
                        text: defaultButton.activeFocus ? "I have active focus!" : "I do not have active focus"
                        color: "white"
                    }
                }
                Button {
                    isDefault: false
                    text: "Non Default"
                }

                Grid {
                    id: grid
                    width: 100; height: 100
                    columns: 2

                    Rectangle {
                        id: topLeft
                        width: 50; height: 50
                        color: focus ? "red" : "lightgray"
                        focus: true

                        KeyNavigation.right: topRight
                        KeyNavigation.down: bottomLeft
                        KeyNavigation.tab: comboBoxCustom
                    }

                    Rectangle {
                        id: topRight
                        width: 50; height: 50
                        color: focus ? "red" : "lightgray"

                        KeyNavigation.left: topLeft
                        KeyNavigation.down: bottomRight
                    }

                    Rectangle {
                        id: bottomLeft
                        width: 50; height: 50
                        color: focus ? "red" : "lightgray"

                        KeyNavigation.right: bottomRight
                        KeyNavigation.up: topLeft
                    }

                    Rectangle {
                        id: bottomRight
                        width: 50; height: 50
                        color: focus ? "red" : "lightgray"

                        KeyNavigation.left: bottomLeft
                        KeyNavigation.up: topRight
                    }

                    onFocusChanged: {
                        topLeft.forceActiveFocus()
                    }

                    KeyNavigation.tab: comboBoxCustom
                }

                // カスタマイズは https://forum.qt.io/topic/32611/how-to-customize-combobox-from-qtquick-controls/7 参照
                ComboBox {
                    id: comboBoxCustom
                    model: ListModel {
                        id: cbItems
                        ListElement { text: "Banana"; color: "yellow" }
                        ListElement { text: "Apple"; color: "gray" }
                        ListElement { text: "Coconut"; color: "purple" }
                    }
                    width: 200
                    height: 25
                    onCurrentIndexChanged: console.debug(currentText + ", " + cbItems.get(currentIndex).color)
                    style: ComboBoxStyle {
                        background: Rectangle {
                            color: "#AAAAFF"
                            radius: 5
                        }
                        textColor: "white"
                        selectedTextColor: "red"
                        selectionColor: "orange"
                    }
                    KeyNavigation.tab: comboBoxDefault
                }
                ComboBox {
                    id: comboBoxDefault
                    model: ListModel {
                        ListElement { text: "Banana" }
                        ListElement { text: "Apple" }
                        ListElement { text: "Coconut" }
                    }
                    KeyNavigation.tab: xTextField
                }
            }

            Keys.onReturnPressed: {
                updatePositionByPropertyChanged()
            }
        }
    }

    function updatePositionByPropertyChanged()
    {
        squareBinding.x = xTextField.text
        squareBinding.y = yTextField.text
    }

    // http://codecereal.blogspot.jp/2012/04/qml-themingstyling.html styleの一元管理できるかも
//    ApplicationStyle {
//        id: appStyle
//        buttonStyle: CustomButtonStyle {
//            background: "myButton.png"
//            pressedBackground: "myPressedButton.png"
//        }
//    }

    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }
}

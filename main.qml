import QtQuick 2.5
import QtQuick.Dialogs 1.2

import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

import Qt_25_Tokyo_20150718 1.0

ApplicationWindow {
    title: qsTr("Hello World")
    width: 1280
    height: 480
    visible: true

    color: constant.backgroundColor

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

    Constants {
        id: constant
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
//        anchors.topMargin: 4
//        anchors.bottomMargin: 4
        color: constant.backgroundColor

        RowLayout {
            anchors.fill: parent
            spacing: 4

            OpenGLView {
                color: "#115599"
                width: 640
                Layout.fillHeight: true
//                Layout.leftMargin: 4
            }

            SplitView {
                orientation: Qt.Horizontal
                Layout.fillWidth: true
                Layout.fillHeight: true
                handleDelegate: Rectangle { width: 4; color: constant.backgroundColor }
                Rectangle {
                    id: drawingView
                    Layout.minimumWidth: 300
                    Layout.fillWidth: true
                    color: "#081a5c"

                    SquareBinding {
                        id: squareBinding
                        onXChanged: xTextField.text = x;
                        onYChanged: yTextField.text = y;
                    }

                    Rectangle {
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

                            drag.target: parent
                            drag.axis: Drag.XAndYAxis

                            drag.threshold: 0

                            drag.minimumX: - parent.width + 5
                            drag.maximumX: drawingView.width - 5

                            drag.minimumY: - parent.height + 5
                            drag.maximumY: drawingView.height - 5

                            onPressed: parent.dragging = true
                            onReleased: parent.dragging = false

                            onPositionChanged: {
                                squareBinding.x = parent.x
                                squareBinding.y = parent.y
                            }
                        }
                    }
                }

                Rectangle {
                    id: editView
                    Layout.minimumWidth: 200
                    width: 250
                    color: "#081a5c"
                    visible: true

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
                        // http://stackoverflow.com/questions/27089779/qml-combobox-item-dropdownmenu-style
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
//                                background: Rectangle {
//                                    color: "#FFAAAA"
//                                    radius: 5
//                                }
                                background: Component {
                                    Rectangle {
                                        color: "#FFAAAA"
                                        Image {
                                            source: "16px-Anchor_pictogram.svg.png"
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }
                                }

                                textColor: "yellow"
                                selectedTextColor: "pink"
                                selectionColor: "orange"
//                                label: Component {
//                                    Label {
//                                        width: 5
//                                        height: 10
//                                        color: "red"
//                                    }
//                                }

                                label: Text {
                                    color: "red"
                                    text: control.currentText
                                }

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

import QtQuick 2.5
import QtQuick.Dialogs 1.2

import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

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
                enabled: false
                text: qsTr("&Open")
                onTriggered: messageDialog.show(qsTr("Open action triggered"));
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
            style: MenuStyle {
                    itemDelegate.label: Label {
                    color: styleData.enabled ? "blue" : "skyblue"
                    text: styleData.text

                    // stuff above here
                }
            }
        }
        Menu {
            title: qsTr("&Help")
            MenuItem {
                text: qsTr("&About")
                onTriggered: messageDialog.show(qsTr("About dialog"));
            }
        }
        //http://stackoverflow.com/questions/31856207/how-to-change-the-font-color-of-a-menubar
//        style: MenuBarStyle {

//            padding {
//                left: 8
//                right: 8
//                top: 3
//                bottom: 3
//            }

//            background: Rectangle {
//                id: rect
//                border.color: menuBorderColor
//                color: menuBackgroundColor
//            }

//            itemDelegate: Rectangle {            // the menus
//                implicitWidth: lab.contentWidth * 1.4           // adjust width the way you prefer it
//                implicitHeight: lab.contentHeight               // adjust height the way you prefer it
//                color: styleData.selected || styleData.open ? "red" : "transparent"
//                Label {
//                    id: lab
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    color: styleData.selected  || styleData.open ? "white" : "red"
//                    font.wordSpacing: 10
//                    text: styleData.text
//                }
//            }

//            menuStyle: MenuStyle {               // the menus items
//                id: goreStyle

//                frame: Rectangle {
//                    color: menuBackgroundColor
//                }

//                itemDelegate {
//                    background: Rectangle {
//                        color:  styleData.selected || styleData.open ? "red" : menuBackgroundColor
//                        radius: styleData.selected ? 3 : 0
//                    }

//                    label: Label {
//                        color: styleData.selected ? "white" : "red"
//                        text: styleData.text
//                    }

//                    submenuIndicator: Text {
//                        text: "\u25ba"
//                        font: goreStyle.font
//                        color: styleData.selected  || styleData.open ? "white" : "red"
//                        styleColor: Qt.lighter(color, 4)
//                    }

//                    shortcut: Label {
//                        color: styleData.selected ? "white" : "red"
//                        text: styleData.shortcut
//                    }

//                    checkmarkIndicator: CheckBox {          // not strinctly a Checkbox. A Rectangle is fine too
//                        checked: styleData.checked

//                        style: CheckBoxStyle {

//                            indicator: Rectangle {
//                                implicitWidth: goreStyle.font.pixelSize
//                                implicitHeight: implicitWidth
//                                radius: 2
//                                color: control.checked ?  "red" : menuBackgroundColor
//                                border.color: control.activeFocus ? menuBackgroundColor : "red"
//                                border.width: 2
//                                Rectangle {
//                                    visible: control.checked
//                                    color: "red"
//                                    border.color: menuBackgroundColor
//                                    border.width: 2
//                                    radius: 2
//                                    anchors.fill: parent
//                                }
//                            }
//                            spacing: 10
//                        }
//                    }
//                }

//                // scrollIndicator:               // <--- could be an image

//                separator: Rectangle {
//                    width: parent.width
//                    implicitHeight: 2
//                    color: "white"
//                }
//            }
//        }
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
//                            KeyNavigation.tab: yTextField
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
                            KeyNavigation.backtab: textFieldX
                        }
                        TextField {
                            id: yTextField
                            placeholderText: qsTr("y")
                            text: squareBinding.y
//                            KeyNavigation.tab: defaultButton
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

//                                KeyNavigation.tab: grid
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

                        FocusScope {
                            width: grid.width
                            height: grid.height
                            activeFocusOnTab: true

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
    //                                KeyNavigation.tab: comboBoxCustom
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

    //                            onFocusChanged: {
    //                                topLeft.forceActiveFocus()
    //                            }

    //                            KeyNavigation.tab: comboBoxCustom
                            }
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
                            editable: false
                            onCurrentIndexChanged: console.debug(currentText + ", " + cbItems.get(currentIndex).color)
                            style: ComboBoxStyle {
//                                background: Rectangle {
//                                    color: "#FFAAAA"
//                                    radius: 5
//                                }

//                                background: Component {
//                                    Rectangle {
//                                        color: "#FFAAAA"
//                                        Image {
//                                            source: "16px-Anchor_pictogram.svg.png"
//                                            anchors.right: parent.right
//                                            anchors.verticalCenter: parent.verticalCenter
//                                        }
//                                    }
//                                }
                                background: TextField {
                                    anchors.fill: parent
                                    activeFocusOnTab: false
                                    style: TextFieldStyle {
                                        background: Rectangle {
                                            anchors.fill: parent
                                            color: "pink"
                                        }
                                        textColor: "red"

                                    }
                                    Image {
                                        source: "16px-Anchor_pictogram.svg.png"
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

//                                textColor: "black"
                                selectedTextColor: "white"
                                selectionColor: "black"
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
//                            KeyNavigation.tab: comboBoxDefault
                        }
                        ComboBox {
                            id: comboBoxDefault
                            model: ListModel {
                                ListElement { text: "Banana" }
                                ListElement { text: "Apple" }
                                ListElement { text: "Coconut" }
                            }
//                            KeyNavigation.tab: xTextField
                        }
                        TextField {
                            id: textFieldX
                            text: "AAAAAAAAAAAAAAA"
                            style: TextFieldStyle {
                                background: Rectangle {
                                    anchors.fill: parent
                                    color: "pink"
                                }
                                textColor: "red"
                            }
                            KeyNavigation.tab: xTextField
                        }
                        TabView {
                            activeFocusOnTab: false
                            focus: false
                            onActiveFocusChanged: {
                                if (activeFocus) {

                                }
                            }

                            Tab {
                                title: "Red"
                                activeFocusOnTab: false
                                focus: false
                                Rectangle { color: "red" }
                            }
//                            Tab {
//                                title: "Blue"
//                                Rectangle { color: "blue" }
//                            }
//                            Tab {
//                                title: "Green"
//                                Rectangle { color: "green" }
//                            }
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

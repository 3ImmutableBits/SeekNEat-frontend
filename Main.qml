import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: "SeekNEat"

    function check_login(){
        return true;
    }


    // Custom button component
    Component {
        id: customButtonComponent

        Rectangle {
            id: root
            property alias text: buttonText.text
            property color normalColor: "#81C784"
            property color hoverColor: "#4CAF50"
            property color pressedColor: "#2E7D32"
            property color borderColor: "#1B5E20"
            property color textColor: "black"
            property color textHoverColor: "white"
            property color textPressedColor: "white"

            width: 120
            height: 45
            radius: 10
            color: mouseArea.pressed ? pressedColor : (mouseArea.containsMouse ? hoverColor : normalColor)
            border.color: borderColor
            border.width: 2

            signal clicked()

            Text {
                id: buttonText
                anchors.centerIn: parent
                font.pixelSize: 18
                font.bold: true
                color: mouseArea.pressed ? textPressedColor : (mouseArea.containsMouse ? textHoverColor : textColor)
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.clicked()
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: loginPageComponent
    }

    // Login page
    Component {
        id: loginPageComponent

        Item {
            anchors.fill: parent

            Image {
                source: "file:///C:/Users/ancap/OneDrive/Pictures/imgtitle.png"
                width: 200
                height: 200
                fillMode: Image.PreserveAspectFit
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 10
            }

            Column {
                anchors.centerIn: parent
                spacing: 20

                TextField {
                    id: nameTextBox
                    placeholderText: "Enter your username/email"
                    width: 470
                    height: 50
                    font.pixelSize: 18
                    color: "black"
                    placeholderTextColor: "#9e9e9e"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 12
                    rightPadding: 12

                    background: Rectangle {
                        radius: 8
                        border.color: nameTextBox.activeFocus ? "#4CAF50" : "#BDBDBD"
                        border.width: 2
                        color: "#f5f5f5"
                    }
                }
                TextField {
                    id: passwordTextBox
                    placeholderText: "Enter your password"
                    width: 470
                    height: 50
                    font.pixelSize: 18
                    echoMode: TextInput.Password
                    color: "black"
                    placeholderTextColor: "#9e9e9e"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 12
                    rightPadding: 12

                    background: Rectangle {
                        radius: 8
                        border.color: passwordTextBox.activeFocus ? "#4CAF50" : "#BDBDBD"
                        border.width: 2
                        color: "#f5f5f5"
                    }
                }

                Row {
                    spacing: 60
                    anchors.horizontalCenter: parent.horizontalCenter

                    Loader {
                        sourceComponent: customButtonComponent
                        onLoaded: {
                            item.text = "Login"
                            item.width = 120
                            item.height = 45
                            item.normalColor = "#90CAF9"
                            item.hoverColor = "#42A5F5"
                            item.pressedColor = "#1E88E5"
                            item.clicked.connect(() => {

                                if(check_login()){

                                    stackView.push(dashboardPageComponent)
                                    item.normalColor = "#90CAF9"
                                    item.hoverColor = "#42A5F5"
                                    item.pressedColor = "#1E88E5"
                                }else{
                                    item.normalColor = "#800000";
                                    item.hoverColor = "#800000";
                                    item.pressedColor = "#800000";

                                }
                            })
                        }
                    }



                    Loader {
                        sourceComponent: customButtonComponent
                        onLoaded: {
                            item.text = "Register"
                            item.width = 120
                            item.height = 45
                            item.normalColor = "#90CAF9"
                            item.hoverColor = "#42A5F5"
                            item.pressedColor = "#1E88E5"
                            item.borderColor = "#1565C0"
                            item.textColor = "white"
                            item.textHoverColor = "white"
                            item.textPressedColor = "white"
                            item.clicked.connect(() => {
                                console.log("Register clicked:", nameTextBox.text, gmailTextBox.text, passwordTextBox.text)
                            })
                        }
                    }
                }

            }
        }
    }

    // Meal page

    // Dashboard page
    Component {
        id: dashboardPageComponent

        Item {
            anchors.fill: parent

            Label {
                text: "Welcome to the Dashboard!"
                font.pixelSize: 22
                color: "#2e7d32"
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20
            }



            Loader {
                id: logoutButtonLoader
                sourceComponent: customButtonComponent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 10
                anchors.leftMargin: 20
                onLoaded: {
                    item.text = "Logout"
                    item.width = 120
                    item.height = 45
                    item.normalColor = "#607d8b"
                    item.hoverColor = "#455a64"
                    item.pressedColor = "#37474f"
                    item.borderColor = "#263238"
                    item.textColor = "white"
                    item.textHoverColor = "white"
                    item.textPressedColor = "white"
                    item.clicked.connect(() => {
                        stackView.pop()
                    })
                }
            }

            Loader {
                id: mapButtonLoader
                sourceComponent: customButtonComponent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 10
                anchors.leftMargin: 200
                onLoaded: {
                    item.text = "Map"
                    item.width = 120
                    item.height = 45
                    item.normalColor = "#607d8b"
                    item.hoverColor = "#455a64"
                    item.pressedColor = "#37474f"
                    item.borderColor = "#263238"
                    item.textColor = "white"
                    item.textHoverColor = "white"
                    item.textPressedColor = "white"
                    item.clicked.connect(() => {
                        console.log("Open Map");
                    })
                }
            }

            Loader {
                id: searchButtonLoader
                sourceComponent: customButtonComponent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 10
                anchors.leftMargin: 200
                onLoaded: {
                    item.text = "Find Meals"
                    item.width = 120
                    item.height = 45
                    item.normalColor = "#607d8b"
                    item.hoverColor = "#455a64"
                    item.pressedColor = "#37474f"
                    item.borderColor = "#263238"
                    item.textColor = "white"
                    item.textHoverColor = "white"
                    item.textPressedColor = "white"
                    item.clicked.connect(() => {

                    })
                }
            }
        }
    }

}

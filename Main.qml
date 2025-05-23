import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation
import QtPositioning

ApplicationWindow {

    visible: true
    width: 640
    height: 480

    title: "SeekNEat"

    function check_login(){
        return true;
    }

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

            width: 120 * scaleFactor
            height: 45 * scaleFactor
            radius: 10
            border.color: borderColor
            border.width: 2

            // Animate background color
            Behavior on color {
                ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }
            // Animate border color in case you want it animated too
            Behavior on border.color {
                ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }

            signal clicked()

            Text {
                id: buttonText
                anchors.centerIn: parent
                font.pixelSize: 18 * scaleFactor
                font.bold: true

                // Animate text color
                Behavior on color {
                    ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }

                color: mouseArea.pressed ? textPressedColor : (mouseArea.containsMouse ? textHoverColor : textColor)
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                // Set background color reactively with animation
                onPressed: root.color = root.pressedColor
                onReleased: {
                    root.color = mouseArea.containsMouse ? root.hoverColor : root.normalColor
                    if (mouseArea.containsMouse) root.clicked()
                }
                onEntered: if (!mouseArea.pressed) root.color = root.hoverColor
                onExited: if (!mouseArea.pressed) root.color = root.normalColor
            }

            // Initialize color to normal on component creation
            Component.onCompleted: root.color = normalColor
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

            Image  {

                source: "qrc:/resources/circleimg.png"
                width: 340
                height: 340
                fillMode: Image.PreserveAspectFit
                anchors.top: parent.top
                anchors.horizontalCenter: parent.left
                anchors.topMargin: 10
            }

            Image  {

                source: "qrc:/resources/circleimg.png"
                width: 340
                height: 340
                fillMode: Image.PreserveAspectFit
                anchors.top: parent.top
                anchors.horizontalCenter: parent.right
                anchors.topMargin: 10

            }

            Image {
                source: "qrc:/resources/imgtitle.png"
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


    // Create page

    Component {

        id: createPageComponenet

        Item {

            anchors.fill: parent

            Label {
                text: "Create Meal"
                font.pixelSize: 40
                font.bold: true
                color: "#00b300"
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20
            }

            Loader {
                id: backToHomeButtonLoader
                sourceComponent: customButtonComponent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 10
                anchors.leftMargin: 20
                onLoaded: {
                    item.text = "Home"
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
            Column {
                anchors.centerIn: parent
                spacing: 20



                TextField {
                    id: mealNameTextBox
                    placeholderText: "Enter your Meal Name"
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
                        border.color: activeFocus ? "#4CAF50" : "#BDBDBD"

                        border.width: 2
                        color: "#f5f5f5"
                    }
                }
            }
        }
    }

    // Dashboard page
    Component {
        id: dashboardPageComponent

        Item {
            anchors.fill: parent

            TextField {
                id: mapTextBox
                placeholderText: "Search Location"
                width: 470
                height: 50
                font.pixelSize: 18
                color: "black"
                placeholderTextColor: "#9e9e9e"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                anchors.centerIn: parent
                leftPadding: 12
                rightPadding: 12

                background: Rectangle {
                    radius: 8
                    border.color: mapTextBox.activeFocus ? "#4CAF50" : "#BDBDBD"
                    border.width: 2
                    color: "#f5f5f5"
                }
            }

            Image {
                source: "qrc:/resources/searchicon.png"
                width: 200
                height: 200
                fillMode: Image.PreserveAspectFit
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 40
            }

            Label {
                text: "Search Locations"
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
                id: createButtonLoader
                sourceComponent: customButtonComponent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 10
                anchors.leftMargin: 200
                onLoaded: {
                    item.text = "Create Meal"
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
                        stackView.push(createPageComponenet);
                    })
                }
            }

            Loader {
                id: searchButtonLoader
                sourceComponent: customButtonComponent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 300
                anchors.leftMargin: 900
                onLoaded: {
                    item.text = "Search"
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

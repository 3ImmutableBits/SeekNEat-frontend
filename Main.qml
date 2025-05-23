import QtQuick 2.15
import QtQuick.Controls 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("SeekNEat")

    Column {
        spacing: 15
        anchors.centerIn: parent
        width: parent.width * 0.8

        Image {
            source: "qrc:/pictures/images/logo.png"
            width: 150
            height: 150
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TextField {
            id: nameTextBox
            placeholderText: "Enter your name"
            width: parent.width
            font.pixelSize: 18
        }

        TextField {
            id: gmailTextBox
            placeholderText: "Enter your Gmail"
            width: parent.width
            font.pixelSize: 18
            inputMethodHints: Qt.ImhEmailCharactersOnly
        }

        TextField {
            id: passwordTextBox
            placeholderText: "Enter your password"
            width: parent.width
            echoMode: TextInput.Password
            font.pixelSize: 18
        }

        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: "Login"
                width: 100
                onClicked: {
                    // Handle login logic here
                    console.log("Login clicked: ", nameTextBox.text, gmailTextBox.text, passwordTextBox.text)
                }
            }

            Button {
                text: "Register"
                width: 100
                onClicked: {
                    // Handle register logic here
                    console.log("Register clicked: ", nameTextBox.text, gmailTextBox.text, passwordTextBox.text)
                }
            }
        }
    }
}

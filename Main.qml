import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtLocation 5.15
import QtPositioning 5.15

/*Main.qml*/

ApplicationWindow {

    visible: true
    width: 640
    height: 480

    title: "SeekNEat"

    function check_login(){
        if(authController.text == "Successfully logged in") return true;
        return false;
    }
    Material.theme: Material.Dark



    Component {
        id: customButtonComponent

        /*
        Custom button component
        Use Rectangles as bg
        Did this because of weird preset outline
        the default Buttons have got
        */

        Rectangle {
            id: root
            property alias text: buttonText.text
            property color normalColor: "#33cc33"
            property color hoverColor: "#00994d"
            property color pressedColor: "#33ff99"
            property color borderColor: "#33ff99"
            property color textColor: "white"
            property color textHoverColor: "white"
            property color textPressedColor: "white"

            width: 120
            height: 45
            radius: 10
            border.color: borderColor
            border.width: 2


            Behavior on color {
                ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }

            Behavior on border.color {
                ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }

            signal clicked()

            Text {
                id: buttonText
                anchors.centerIn: parent
                font.pixelSize: 18
                font.bold: true

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

                onPressed: root.color = root.pressedColor
                onReleased: {
                    root.color = mouseArea.containsMouse ? root.hoverColor : root.normalColor
                    if (mouseArea.containsMouse) root.clicked()
                }
                onEntered: if (!mouseArea.pressed) root.color = root.hoverColor
                onExited: if (!mouseArea.pressed) root.color = root.normalColor
            }

            Component.onCompleted: root.color = normalColor
        }
    }


    StackView {

        // stack window view

        id: stackView
        anchors.fill: parent
        initialItem: loginPageComponent
    }

    Component {
        id: loginPageComponent

        Item {
            id: root
            anchors.fill: parent

            property real baseWidth: 800
            property real baseHeight: 600
            // Scale factor based on smaller dimension ratio
            property real scaleFactor: Math.min(width / baseWidth, height / baseHeight)

            function getGreeting() {
                let hour = new Date().getHours();
                if (hour >= 5 && hour < 12) {
                    return "Good Morning!";
                } else if (hour >= 12 && hour < 17) {
                    return "Good Afternoon!";
                } else if (hour >= 17 && hour < 21) {
                    return "Good Evening!";
                } else {
                    return "Good Night!";
                }
            }

            Label {
                id: greetingLabel
                text: getGreeting()
                font.pixelSize: 26  ;
                font.bold: true
                color: "#00b300"
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.bottomMargin: 30  ;
                anchors.leftMargin: 30  ;
                Material.theme: Material.Dark
            }

            Image {
                source: "qrc:/resources/circleimg.png"
                width: 140
                height: 140
                fillMode: Image.PreserveAspectFit
                anchors.top: parent.top
                anchors.horizontalCenter: parent.left
                anchors.topMargin: 10
            }

            Image {
                source: "qrc:/resources/circleimg.png"
                width: 140
                height: 140
                fillMode: Image.PreserveAspectFit
                anchors.top: parent.top
                anchors.horizontalCenter: parent.right
                anchors.topMargin: 10
            }

            Image {
                source: "qrc:/resources/imgtitle.png"
                width: 100
                height: 100
                fillMode: Image.PreserveAspectFit
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 40
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20  ;
                Layout.fillHeight: true
                Layout.fillWidth: true

                // Username Row
                RowLayout {
                    spacing: 10  ;
                    width: 470  ;
                    height: 50  ;

                    Text {
                        text: "👤"
                        font.pixelSize: 24  ;
                        verticalAlignment: Text.AlignVCenter
                    }

                    TextField {
                        id: nameTextBox
                        placeholderText: "Enter your username"
                        Layout.fillWidth: true
                        height: 50  ;
                        font.pixelSize: 18  ;
                        color: "black"
                        placeholderTextColor: "#000000"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 12  ;
                        rightPadding: 12  ;

                        background: Rectangle {
                            radius: 8  ;
                            border.color: nameTextBox.activeFocus ? "#3399ff" : "#3385ff"
                            border.width: 2  ;
                            color: "#3385ff"
                        }

                        onTextChanged: {
                            textHandler.processUsername(text)
                        }
                    }
                }

                // Email Row
                RowLayout {
                    spacing: 10  ;
                    width: 470  ;
                    height: 50  ;

                    Text {
                        text: "📧"
                        font.pixelSize: 24
                        verticalAlignment: Text.AlignVCenter
                    }

                    TextField {
                        id: emailTextBox
                        placeholderText: "Enter your email"
                        Layout.fillWidth: true
                        height: 50  ;
                        font.pixelSize: 18  ;
                        color: "black"
                        placeholderTextColor: "#000000"

                        background: Rectangle {
                            radius: 8  ;
                            border.color: emailTextBox.activeFocus ? "#3399ff" : "#3385ff"
                            border.width: 2  ;
                            color: "#3385ff"
                        }

                        onTextChanged: {
                            textHandler.processEmail(text)
                        }
                    }
                }

                // Password Row
                RowLayout {
                    spacing: 10
                    width: 470
                    height: 50

                    Text {
                        text: "🔒"
                        font.pixelSize: 24
                        verticalAlignment: Text.AlignVCenter
                    }

                    TextField {
                        id: passwordTextBox
                        placeholderText: "Enter your password"
                        Layout.fillWidth: true
                        height: 50
                        font.pixelSize: 18
                        color: "black"
                        placeholderTextColor: "#000000"
                        echoMode: TextInput.Password
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 12
                        rightPadding: 12

                        background: Rectangle {
                            radius: 8
                            border.color: passwordTextBox.activeFocus ? "#3399ff" : "#3385ff"
                            border.width: 2
                            color: "#3385ff"
                        }

                        onTextChanged: {
                            textHandler.processPwd(text)
		        }
                    }
                }

                // Buttons Column
                ColumnLayout {
                    spacing: 20  ;
                    anchors.horizontalCenter: parent.horizontalCenter
                    Layout.fillWidth: true

                    Text {
                        text: authController.text
                        font.pixelSize: 17
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Loader {
                        id: loginButtonLoader
                        sourceComponent: customButtonComponent
                        Layout.preferredWidth: 320  ;
                        Layout.preferredHeight: 45  ;

                        onLoaded: {
                            item.text = "Login"
                            item.width = 320  ;
                            item.height = 45  ;
                            item.normalColor = "#33cc33"
                            item.hoverColor = "#00ff00"
                            item.pressedColor = "#00ff00"
                            item.borderColor = "#33cc33"
                            item.textColor = "black"
                            item.textHoverColor = "black"
                            item.textPressedColor = "black"

                            if ("font" in item) {
                                item.font.pixelSize = 18  ;
                            }

                            item.clicked.connect(() => {
                                btnHandler.handleLoginBtn()
                                if (check_login()) {
                                    stackView.push(dashboardPageComponent)
                                } else {
                                    item.normalColor = "#800000"
                                }
                            })
                        }
                    }

                    Loader {
                        id: registerButtonLoader
                        sourceComponent: customButtonComponent
                        Layout.preferredWidth: 320  ;
                        Layout.preferredHeight: 45  ;

                        onLoaded: {
                            item.text = "Register"
                            item.width = 320  ;
                            item.height = 45  ;
                            item.normalColor = "#33cc33"
                            item.hoverColor = "#00ff00"
                            item.pressedColor = "#00ff00"
                            item.borderColor = "#33cc33"
                            item.textColor = "black"
                            item.textHoverColor = "black"
                            item.textPressedColor = "black"

                            if ("font" in item) {
                                item.font.pixelSize = 18  ;
                            }

                            item.clicked.connect(() => {
                                btnHandler.handleRegisterBtn()
                                console.log("Register clicked:", nameTextBox.text, emailTextBox.text, passwordTextBox.text)
                            })
                        }
                    }
                }
            }
        }
    }


    // Map result page
    Component {

        id: mapResultPage

        Item {
            anchors.fill: parent

            property real baseWidth: 1400
            property real baseHeight: 800
            property real scaleFactor: Math.min(width / baseWidth, height / baseHeight)

            Rectangle {
                Material.theme: Material.Dark
                width: parent.width
                height: 80
                color: "#0d1a26"
                anchors.top: parent.top
                z: 1

                Label {
                    text: "Search Result"
                    font.pixelSize: 40 * scaleFactor
                    font.bold: true
                    color: "#00b300"
                    anchors.centerIn: parent
                    Material.theme: Material.Dark
                }
            }

            Loader {
                id: backFromMapButtonLoader
                sourceComponent: customButtonComponent
                width: 120 * scaleFactor
                height: 45 * scaleFactor
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 20 * scaleFactor
                anchors.leftMargin: 20 * scaleFactor
                Material.theme: Material.Dark
                z: 1
                onLoaded: {
                    item.text = "Back"
                    item.normalColor = "#33cc33"
                    item.hoverColor = "#00ff00"
                    item.pressedColor = "#00ff00"
                    item.borderColor = "#33cc33"
                    item.textColor = "black"
                    item.textHoverColor = "black"
                    item.textPressedColor = "black"

                    // Scale font size of button text if available
                    if ("font" in item) {
                        item.font.pixelSize = 18 * scaleFactor
                    }

                    item.clicked.connect(() => {
                        stackView.pop();
                    })
                }
            }

            Plugin {
                id: mapPlugin
                name: "osm"
                PluginParameter {
                    name: "osm.mapping.custom.host"
                    value: "https://tile.openstreetmap.org/"
                }
            }

            Map {
                id: map
                width: parent.width * 0.9
                height: parent.height * 0.85
                anchors.centerIn: parent
                plugin: mapPlugin
                center: QtPositioning.coordinate(59.91, 10.75)
                zoomLevel: 14
                activeMapType: map.supportedMapTypes[map.supportedMapTypes.length - 1]
                property geoCoordinate startCentroid

                PinchHandler {
                    id: pinch
                    target: null
                    onActiveChanged: if (active) {
                        map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
                    }
                    onScaleChanged: (delta) => {
                        map.zoomLevel += Math.log2(delta)
                        map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                    }
                    onRotationChanged: (delta) => {
                        map.bearing -= delta
                        map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                    }
                    grabPermissions: PointerHandler.TakeOverForbidden
                }

                WheelHandler {
                    id: wheel
                    acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                        ? PointerDevice.Mouse | PointerDevice.TouchPad
                        : PointerDevice.Mouse
                    rotationScale: 1 / 120
                    property: "zoomLevel"
                }

                DragHandler {
                    id: drag
                    target: null
                    onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
                }

                Shortcut {
                    enabled: map.zoomLevel < map.maximumZoomLevel
                    sequence: StandardKey.ZoomIn
                    onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
                }

                Shortcut {
                    enabled: map.zoomLevel > map.minimumZoomLevel
                    sequence: StandardKey.ZoomOut
                    onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
                }
            }
        }
    }


    // Search page
    Component {
        id: searchMealPage

        Item {
            id: root
            anchors.fill: parent

            property real baseWidth: 800
            property real baseHeight: 600

            // Scale factor based on the smaller ratio of width or height relative to base
            property real scaleFactor: Math.min(width / baseWidth, height / baseHeight)

            Label {
                text: "Browse Meals"
                font.pixelSize: 40  ;
                font.bold: true
                color: "#00b300"
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20  ;
                Material.theme: Material.Dark
            }

            Column {
                anchors.centerIn: parent
                spacing: 35  ;
                width: 470  ;

                TextField {
                    id: uiSearchBox
                    placeholderText: "Browse Meals"
                    width: parent.width
                    height: 50  ;
                    font.pixelSize: 18  ;
                    color: "black"
                    placeholderTextColor: "#000000"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 12  ;
                    rightPadding: 12  ;

                    background: Rectangle {
                        radius: 8  ;
                        border.color: uiSearchBox.activeFocus ? "#3399ff" : "#3385ff"
                        border.width: 2  ;
                        color: "#3385ff"
                    }
                }

                Loader {
                    id: browseButtonLoader
                    sourceComponent: customButtonComponent
                    width: uiSearchBox.width
                    height: uiSearchBox.height
                    Material.theme: Material.Dark

                    onLoaded: {
                        item.text = "Browse!"
                        item.width = uiSearchBox.width
                        item.height = uiSearchBox.height
                        item.normalColor = "#33cc33"
                        item.hoverColor = "#00ff00"
                        item.pressedColor = "#00ff00"
                        item.borderColor = "#33cc33"
                        item.textColor = "black"
                        item.textHoverColor = "black"
                        item.textPressedColor = "black"
                        // Scale font size if the button supports it
                        if ("font" in item) {
                            item.font.pixelSize = 18  ;
                        }
                        item.clicked.connect(() => {
                            stackView.push(mapResultPage)
                        })
                    }
                }

                Loader {
                    id: backToHomeButtonLoader
                    sourceComponent: customButtonComponent
                    Layout.preferredWidth: 120  ;
                    Layout.preferredHeight: 45  ;

                    onLoaded: {
                        item.text = "Home"
                        item.width = 120  ;
                        item.height = 45  ;
                        item.normalColor = "#33cc33"
                        item.hoverColor = "#00ff00"
                        item.pressedColor = "#00ff00"
                        item.borderColor = "#33cc33"
                        item.textColor = "black"
                        item.textHoverColor = "black"
                        item.textPressedColor = "black"

                        if ("font" in item) {
                            item.font.pixelSize = 18  ;
                        }

                        item.clicked.connect(() => {
                            stackView.pop()
                        })
                    }
                }

            }
        }
    }

    Component {
        id: mapSelectComponent

        Item {
            id: root
            anchors.fill: parent

            property real baseWidth: 1400
            property real baseHeight: 800
            property real scaleFactor: Math.min(width / baseWidth, height / baseHeight)
            property var selectedCoordinate: QtPositioning.coordinate(0, 0)

            Rectangle {
                width: parent.width
                height: 80
                color: "#0d1a26"
                anchors.top: parent.top
                z: 1

                Label {
                    text: "Search Result"
                    font.pixelSize: 40 * scaleFactor
                    font.bold: true
                    color: "#00b300"
                    anchors.centerIn: parent
                }
            }

            Loader {
                id: backFromMapButtonLoader
                sourceComponent: customButtonComponent
                width: 120 * scaleFactor
                height: 45 * scaleFactor
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 20 * scaleFactor
                anchors.leftMargin: 20 * scaleFactor
                z: 1

                onLoaded: {
                    item.text = "Back"
                    item.normalColor = "#33cc33"
                    item.hoverColor = "#00ff00"
                    item.pressedColor = "#00ff00"
                    item.borderColor = "#33cc33"
                    item.textColor = "black"
                    item.textHoverColor = "black"
                    item.textPressedColor = "black"

                    if ("font" in item) item.font.pixelSize = 18 * scaleFactor

                    if ("clicked" in item) {
                        item.clicked.connect(() => {
                            stackView.pop();
                        });
                    } else {
                        console.error("customButtonComponent missing 'clicked' signal");
                    }
                }
            }

            Plugin {
                id: mapPlugin
                name: "osm"
                PluginParameter {
                    name: "osm.mapping.custom.host"
                    value: "https://tile.openstreetmap.org/"
                }
            }

            Map {
                id: map
                width: parent.width * 0.9
                height: parent.height * 0.85
                anchors.centerIn: parent
                plugin: mapPlugin
                center: QtPositioning.coordinate(59.91, 10.75)
                zoomLevel: 14
                activeMapType: map.supportedMapTypes[map.supportedMapTypes.length - 1]
                property geoCoordinate startCentroid

                PinchHandler {
                    id: pinch
                    target: null
                    onActiveChanged: if (active) {
                        map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
                    }
                    onScaleChanged: (delta) => {
                        map.zoomLevel += Math.log2(delta)
                        map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                    }
                    onRotationChanged: (delta) => {
                        map.bearing -= delta
                        map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                    }
                    grabPermissions: PointerHandler.TakeOverForbidden
                }

                WheelHandler {
                    acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                        ? PointerDevice.Mouse | PointerDevice.TouchPad
                        : PointerDevice.Mouse
                    rotationScale: 1 / 120
                    property: "zoomLevel"
                }

                DragHandler {
                    target: null
                    onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: (mouse) => {
                        var coord = map.toCoordinate(Qt.point(mouse.x, mouse.y));
                        selectedCoordinate = coord;
                        marker.coordinate = coord;
                    }
                }

                MapQuickItem {
                    id: marker
                    anchorPoint.x: icon.width / 2
                    anchorPoint.y: icon.height
                    coordinate: QtPositioning.coordinate(0, 0)
                    sourceItem: Image {
                        id: icon
                        source: "qrc:/resources/marker.png"
                        width: 32
                        height: 32
                    }
                    visible: selectedCoordinate.latitude !== 0 || selectedCoordinate.longitude !== 0
                }

                Button {
                    id: selectLocation
                    text: "Save Location"
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 20 * scaleFactor
                    width: 160 * scaleFactor
                    height: 50 * scaleFactor

                    onClicked: {
                        console.log("Selected coordinate:", selectedCoordinate.latitude, selectedCoordinate.longitude);
                        // Signal or callback can go here if needed
                    }
                }

                Shortcut {
                    enabled: map.zoomLevel < map.maximumZoomLevel
                    sequence: StandardKey.ZoomIn
                    onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
                }

                Shortcut {
                    enabled: map.zoomLevel > map.minimumZoomLevel
                    sequence: StandardKey.ZoomOut
                    onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
                }
            }
        }
    }



    // Create page

    Component {
        id: createPageComponent

        Item {
            id: root
            anchors.fill: parent

            property real baseWidth: 800
            property real baseHeight: 600
            property real scaleFactor: Math.min(width / baseWidth, height / baseHeight)

            Label {
                text: "Create Meal"
                font.pixelSize: 40  ;
                font.bold: true
                color: "#00b300"
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20  ;
                Material.theme: Material.Dark
            }

            Loader {
                id: backToHomeButtonLoader
                sourceComponent: customButtonComponent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 10  ;
                anchors.leftMargin: 20  ;
                Material.theme: Material.Dark
                onLoaded: {


                    item.text = "Home"
                    item.width = 120
                    item.height = 45

                    item.normalColor = "#33cc33"
                    item.hoverColor = "#00ff00"
                    item.pressedColor = "#00ff00"
                    item.borderColor = "#33cc33"
                    item.textColor = "black"
                    item.textHoverColor = "black"
                    item.textPressedColor = "black"

                    if ("font" in item) {
                        item.font.pixelSize = 18  ;
                    }

                    if ("clicked" in item) {
                        item.clicked.connect(() => {
                            stackView.pop()
                        })
                    } else {
                        console.error("customButtonComponent missing 'clicked' signal")
                    }
                }
            }



            Loader {
                id: selectButtonLoader
                sourceComponent: customButtonComponent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 220  ;
                anchors.leftMargin: 20  ;
                Material.theme: Material.Dark
                onLoaded: {


                    item.text = "Location"
                    item.width = 120  ;
                    item.height = 45  ;

                    item.normalColor = "#33cc33"
                    item.hoverColor = "#00ff00"
                    item.pressedColor = "#00ff00"
                    item.borderColor = "#33cc33"
                    item.textColor = "black"
                    item.textHoverColor = "black"
                    item.textPressedColor = "black"

                    if ("font" in item) {
                        item.font.pixelSize = 18  ;
                    }

                    if ("clicked" in item) {
                        item.clicked.connect(() => {
                            stackView.push(mapSelectComponent)
                        })
                    } else {
                        console.error("customButtonComponent missing 'clicked' signal")
                    }
                }
            }


            Loader {
                id: submitButtonLoader
                sourceComponent: customButtonComponent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 100  ;
                anchors.leftMargin: 20  ;
                Material.theme: Material.Dark
                onLoaded: {


                    item.text = "Submit"
                    item.width = 120  ;
                    item.height = 45  ;

                    item.normalColor = "#33cc33"
                    item.hoverColor = "#00ff00"
                    item.pressedColor = "#00ff00"
                    item.borderColor = "#33cc33"
                    item.textColor = "black"
                    item.textHoverColor = "black"
                    item.textPressedColor = "black"

                    if ("font" in item) {
                        item.font.pixelSize = 18  ;
                    }

                    if ("clicked" in item) {
                        item.clicked.connect(() => {
                            stackView.pop()
                        })
                    } else {
                        console.error("customButtonComponent missing 'clicked' signal")
                    }
                }
            }


            Column {
                anchors.centerIn: parent
                spacing: 20  ;

                function createTextField(idName, placeholder) {
                    return Qt.createQmlObject(`
                        import QtQuick 2.15
                        import QtQuick.Controls 2.15

                        TextField {
                            id: ${idName}
                            placeholderText: "${placeholder}"
                            width: 470  ;
                            height: 50  ;
                            font.pixelSize: 18  ;
                            color: "black"
                            placeholderTextColor: "#000000"
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 12  ;
                            rightPadding: 12  ;

                            background: Rectangle {
                                radius: 8  ;
                                border.color: ${idName}.activeFocus ? "#3399ff" : "#3385ff"
                                border.width: 2  ;
                                color: "#3385ff"
                            }
                        }
                    `, root, idName);
                }

                // Manually create TextFields (can't dynamically create in Column easily)
                TextField {
                    id: mealNameTextBox
                    placeholderText: "Enter your Meal Name"
                    width: 470  ;
                    height: 50  ;
                    font.pixelSize: 18  ;
                    color: "black"
                    placeholderTextColor: "#000000"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 12  ;
                    rightPadding: 12  ;

                    background: Rectangle {
                        radius: 8  ;
                        border.color: mealNameTextBox.activeFocus ? "#3399ff" : "#3385ff"
                        border.width: 2  ;
                        color: "#3385ff"
                    }
                }

                TextField {
                    id: mealDescriptionTextBox
                    placeholderText: "Enter your Meal Description"
                    width: 470  ;
                    height: 50  ;
                    font.pixelSize: 18  ;
                    color: "black"
                    placeholderTextColor: "#000000"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 12  ;
                    rightPadding: 12  ;

                    background: Rectangle {
                        radius: 8  ;
                        border.color: mealDescriptionTextBox.activeFocus ? "#3399ff" : "#3385ff"
                        border.width: 2  ;
                        color: "#3385ff"
                    }
                }

                TextField {
                    id: mealPriceTextBox
                    placeholderText: "Enter Cost of Meal"
                    width: 470  ;
                    height: 50  ;
                    font.pixelSize: 18  ;
                    color: "black"
                    placeholderTextColor: "#000000"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 12  ;
                    rightPadding: 12  ;

                    background: Rectangle {
                        radius: 8  ;
                        border.color: mealPriceTextBox.activeFocus ? "#3399ff" : "#3385ff"
                        border.width: 2  ;
                        color: "#3385ff"
                    }
                }


                TextField {
                    id: mealSpotTextBox
                    placeholderText: "Enter Number of Participants"
                    width: 470  ;
                    height: 50  ;
                    font.pixelSize: 18  ;
                    color: "black"
                    placeholderTextColor: "#000000"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 12  ;
                    rightPadding: 12  ;

                    background: Rectangle {
                        radius: 8  ;
                        border.color: mealSpotTextBox.activeFocus ? "#3399ff" : "#3385ff"
                        border.width: 2  ;
                        color: "#3385ff"
                    }
                }}

                TextField {
                    id: timeTextBox
                    placeholderText: "Enter time (HH:MM:SS)"
                    width: 470  ;
                    height: 50  ;
                    font.pixelSize: 18  ;
                    color: "black"
                    placeholderTextColor: "#000000"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 12  ;
                    rightPadding: 12  ;

                    background: Rectangle {
                        radius: 8  ;
                        border.color: mealSpotTextBox.activeFocus ? "#3399ff" : "#3385ff"
                        border.width: 2  ;
                        color: "#3385ff"
                    }
                }}



        }
    }

    Component {
        id: userPageComponent

        Item {
            anchors.fill: parent

            // page title
            Label {
                text: "User Page"
                font.pixelSize: 40
                font.bold: true
                color: "#00b300"
                Material.theme: Material.Dark
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20
            }

            Loader {
                id: backToHomeButtonLoader2
                sourceComponent: customButtonComponent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 130
                anchors.leftMargin: 20
                Material.theme: Material.Dark
                onLoaded: {
                    item.text = "Back"
                    item.width = 120
                    item.height = 45
                    item.normalColor = "#33cc33"
                    item.hoverColor = "#00ff00"
                    item.pressedColor = "#00ff00"
                    item.borderColor = "#33cc33"
                    item.textColor = "black"
                    item.textHoverColor = "black"
                    item.textPressedColor = "black"
                    item.clicked.connect(() => {
                        stackView.pop()
                    })
                }
            }

            Loader {
                id: settingsButtonLoader
                sourceComponent: customButtonComponent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 70
                anchors.leftMargin: 20
                Material.theme: Material.Dark
                onLoaded: {
                    item.text = "Settings"
                    item.width = 120
                    item.height = 45
                    item.normalColor = "#33cc33"
                    item.hoverColor = "#00ff00"
                    item.pressedColor = "#00ff00"
                    item.borderColor = "#33cc33"
                    item.textColor = "black"
                    item.textHoverColor = "black"
                    item.textPressedColor = "black"
                    item.clicked.connect(() => {
                        stackView.push(userSettingsComponent)
                    })
                }
            }

            Loader {
                id: logoutButtonLoader
                sourceComponent: customButtonComponent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 10
                anchors.leftMargin: 20
                Material.theme: Material.Dark
                onLoaded: {
                    item.text = "Logout"
                    item.width = 120
                    item.height = 45
                    item.normalColor = "#33cc33"
                    item.hoverColor = "#00ff00"
                    item.pressedColor = "#00ff00"
                    item.borderColor = "#33cc33"
                    item.textColor = "black"
                    item.textHoverColor = "black"
                    item.textPressedColor = "black"
                    item.clicked.connect(() => {
                        stackView.push(loginPageComponent)
                    })
                }
            }

            // user profile
            Row {
                id: profileRow
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 100
                spacing: 20

                Column {
                    spacing: 10

                    Rectangle {
                        width: 300
                        height: 80
                        radius: 10
                        border.width: 2
                        Material.theme: Material.Dark
                        border.color: "#293d3d"
                        color: "#293d3d"

                        Label {
                            text: "Username: idkwho"
                            font.pixelSize: 18
                            anchors.centerIn: parent
                            color: "white"
                        }
                    }

                    Rectangle {
                        width: 300
                        height: 80
                        radius: 10
                        border.width: 2
                        Material.theme: Material.Dark
                        border.color: "#293d3d"
                        color: "#293d3d"

                        Label {
                            text: "Email: idk.who@gmail.com"
                            font.pixelSize: 18
                            anchors.centerIn: parent
                            color: "white"
                        }
                    }
                }
            }

            // meals
            Column {
                anchors.top: profileRow.bottom
                anchors.topMargin: 25
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.9

                Label {
                    text: "Hosted Meals:"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#00b300"
                    Material.theme: Material.Dark
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }

                Flickable { // basically mobile scrolling
                    id: hostedFlickable
                    contentWidth: hostedModel.count * (140 + 10)
                    interactive: true
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true
                    height: 130
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Row {
                        spacing: 10
                        anchors.verticalCenter: parent.verticalCenter

                        Repeater {
                            model: hostedModel
                            delegate: Rectangle {
                                width: 140
                                height: 120
                                radius: 10
                                color: "#293d3d"
                                border.color: "#00b300"
                                border.width: 2

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 5

                                    Label {
                                        text: name
                                        font.pixelSize: 14
                                        color: "white"
                                        horizontalAlignment: Text.AlignHCenter
                                        elide: Label.ElideRight
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Column {
                anchors.top: profileRow.bottom
                anchors.topMargin: 180
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.9

                Label {
                    text: "Upcoming Meals:"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#00b300"
                    Material.theme: Material.Dark
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }

                Flickable {
                    id: upcomingFlickable
                    contentWidth: hostedModel.count * (140 + 10)
                    interactive: true
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true
                    height: 130
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Row {
                        spacing: 10
                        anchors.verticalCenter: parent.verticalCenter

                        Repeater {
                            model: hostedModel
                            delegate: Rectangle {
                                width: 140
                                height: 120
                                radius: 10
                                color: "#293d3d"
                                border.color: "#00b300"
                                border.width: 2

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 5

                                    Label {
                                        text: name
                                        font.pixelSize: 14
                                        color: "white"
                                        horizontalAlignment: Text.AlignHCenter
                                        elide: Label.ElideRight
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // example data
            ListModel {
                id: hostedModel
                ListElement { name: "????"; } // add own names
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
            }

            ListModel {
                id: upcomingModel
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
                ListElement { name: "????"; }
            }
        }
    }

    // User settings page

    Component {
        id: userSettingsComponent

        Item {
            anchors.fill: parent

            Column {
                anchors.centerIn: parent
                spacing: 20
                width: 470

                Text {
                    text: "Settings"
                    font.pixelSize: 28
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    color: "#33ff33"
                }

                Row {
                    spacing: 10
                    width: parent.width
                    height: 50

                    Text {
                        text: "📧"
                        font.pixelSize: 24
                        verticalAlignment: Text.AlignVCenter
                    }

                    TextField {
                        id: newEmailTextBox
                        placeholderText: "Enter your new email"
                        width: parent.width - 50
                        height: 50
                        font.pixelSize: 18
                      //  echoMode: TextInput.Password
                        color: "black"
                        placeholderTextColor: "#000000"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 12
                        rightPadding: 12

                        background: Rectangle {
                            radius: 8
                            border.color: newEmailTextBox.activeFocus ? "#3399ff" : "#3385ff"
                            border.width: 2
                            color: "#3385ff"
                        }

                        onTextChanged: {
                            textHandler.processNewEmail(text)
                        }
                    }
                }

                Row {
                    spacing: 10
                    width: parent.width
                    height: 50

                    Text {
                        text: "🔒"
                        font.pixelSize: 24
                        verticalAlignment: Text.AlignVCenter
                    }

                    TextField {
                        id: newPasswordTextBox
                        placeholderText: "Enter your new password"
                        width: parent.width - 50
                        height: 50
                        font.pixelSize: 18
                      //  echoMode: TextInput.Password
                        color: "black"
                        placeholderTextColor: "#000000"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 12
                        rightPadding: 12

                        background: Rectangle {
                            radius: 8
                            border.color: newPasswordTextBox.activeFocus ? "#3399ff" : "#3385ff"
                            border.width: 2
                            color: "#3385ff"
                        }

                        onTextChanged: {
                            textHandler.processNewPwd(text)
                        }
                    }
                }

                Row {
                    spacing: 10
                    width: parent.width
                    height: 50

                    Text {
                        text: "👤"
                        font.pixelSize: 24
                        verticalAlignment: Text.AlignVCenter
                    }

                    TextField {
                        id: newUsernameTextBox
                        placeholderText: "Enter your new username"
                        width: parent.width - 50
                        height: 50
                        font.pixelSize: 18
                      //  echoMode: TextInput.Password
                        color: "black"
                        placeholderTextColor: "#000000"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 12
                        rightPadding: 12

                        background: Rectangle {
                            radius: 8
                            border.color: newUsernameTextBox.activeFocus ? "#3399ff" : "#3385ff"
                            border.width: 2
                            color: "#3385ff"
                        }

                        onTextChanged: {
                            textHandler.processNewUsername(text)
                        }
                    }
                }

                Loader {
                    id: confirmButtonLoader
                    sourceComponent: customButtonComponent
                    width: parent.width
                    height: 50
                    onLoaded: {
                        item.text = "Save & Exit"
                        item.normalColor = "#33cc33"
                        item.hoverColor = "#00ff00"
                        item.pressedColor = "#00ff00"
                        item.borderColor = "#33cc33"
                        item.textColor = "black"
                        item.textHoverColor = "black"
                        item.textPressedColor = "black"
                        item.clicked.connect(() => {
                            btnHandler.handleUserEditBtn()
                            stackView.pop();
                        })
                    }
                }

                Text {
                    text: editController.text
                    font.pixelSize: 17
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }


            }
        }
    }

    // Navbar

    Component {
        id: dashboardPageComponent

        Item {
            id: root
            property real scaleFactor: 1.0
            anchors.fill: parent

            Image {
                source: "qrc:/resources/searchicon.png"
                width: 200
                height: 200
                fillMode: Image.PreserveAspectFit
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 40
            }

            Rectangle {
                id: mainMenuPage
                width: parent.width
                height: 75
                z: 1
                border.width: 2
                border.color: "#293d3d"
                color: "#293d3d"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 0
                Material.theme: Material.Dark

                // Create Meal Button - left aligned + 20 px
                Loader {
                    id: createButtonLoader
                    sourceComponent: customButtonComponent
                    width: 120
                    height: 45
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    onLoaded: {
                        item.text = "Create Meal"
                        item.width = 120
                        item.height = 45
                        item.normalColor = "#33cc33"
                        item.hoverColor = "#00ff00"
                        item.pressedColor = "#00ff00"
                        item.borderColor = "#33cc33"
                        item.textColor = "black"
                        item.textHoverColor = "black"
                        item.textPressedColor = "black"
                        if ("font" in item) item.font.pixelSize = 18
                        item.clicked.connect(() => stackView.push(createPageComponent))
                    }
                }

                // View Profile Button - centered
                Loader {
                    id: profileButtonLoader
                    sourceComponent: customButtonComponent
                    width: 120
                    height: 45
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    onLoaded: {
                        item.text = "View Profile"
                        item.width = 120
                        item.height = 45
                        item.normalColor = "#33cc33"
                        item.hoverColor = "#00ff00"
                        item.pressedColor = "#00ff00"
                        item.borderColor = "#33cc33"
                        item.textColor = "black"
                        item.textHoverColor = "black"
                        item.textPressedColor = "black"
                        if ("font" in item) item.font.pixelSize = 18
                        item.clicked.connect(() => stackView.push(userPageComponent))
                    }
                }

                // Search Button - right aligned - 20 px
                Loader {
                    id: searchButtonLoader
                    sourceComponent: customButtonComponent
                    width: 120
                    height: 45
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    onLoaded: {
                        item.text = "Search"
                        item.width = 120
                        item.height = 45
                        item.normalColor = "#33cc33"
                        item.hoverColor = "#00ff00"
                        item.pressedColor = "#00ff00"
                        item.borderColor = "#33cc33"
                        item.textColor = "black"
                        item.textHoverColor = "black"
                        item.textPressedColor = "black"
                        if ("font" in item) item.font.pixelSize = 18
                        item.clicked.connect(() => stackView.push(searchMealPage))
                    }
                }
            }

            Plugin {
                id: mapPlugin
                name: "osm"
                PluginParameter {
                    name: "osm.mapping.custom.host"
                    value: "https://tile.openstreetmap.org/"
                }
            }

            Map {
                id: map
                width: 1400
                height: 800
                anchors.centerIn: parent
                plugin: mapPlugin
                center: QtPositioning.coordinate(59.91, 10.75)
                zoomLevel: 14
                activeMapType: map.supportedMapTypes[map.supportedMapTypes.length - 1]
                property geoCoordinate startCentroid

                PinchHandler {
                    id: pinch
                    target: null
                    onActiveChanged: if (active) {
                        map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
                    }
                    onScaleChanged: (delta) => {
                        map.zoomLevel += Math.log2(delta)
                        map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                    }
                    onRotationChanged: (delta) => {
                        map.bearing -= delta
                        map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                    }
                    grabPermissions: PointerHandler.TakeOverForbidden
                }

                WheelHandler {
                    id: wheel
                    acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                        ? PointerDevice.Mouse | PointerDevice.TouchPad
                        : PointerDevice.Mouse
                    rotationScale: 1 / 120
                    property: "zoomLevel"
                }

                DragHandler {
                    id: drag
                    target: null
                    onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
                }

                Shortcut {
                    enabled: map.zoomLevel < map.maximumZoomLevel
                    sequence: StandardKey.ZoomIn
                    onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
                }

                Shortcut {
                    enabled: map.zoomLevel > map.minimumZoomLevel
                    sequence: StandardKey.ZoomOut
                    onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
                }
            }
        }
    }
}

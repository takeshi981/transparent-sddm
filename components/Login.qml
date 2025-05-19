import QtQuick 2.15
import QtQuick.Controls 2.4 as QQC
import Qt5Compat.GraphicalEffects 1.0
import org.kde.plasma.plasma5support 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.breeze.components
import org.kde.kirigami 2.20 as Kirigami
import "../assets"
import "../components"
Rectangle {
    id: form
    x: 738
    y: 58
    width: 400
    height: 480
    visible: true
    radius: 10
    color: "#b3000000"
    anchors.centerIn: parent
    property Item password: password


    Column {
        anchors.horizontalCenter: parent.horizontalCenter  // Center everything
        spacing: 20  // Adjust space between elements

        Item { // User Image Container
            width: 150
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
                id: userImage
                z: 10

                width: 150
                height: width
                source: userList.defaultImage
                asynchronous: true
                cache: true
                clip: true
                visible: true
                anchors.fill: parent
                property bool rounded: true
                property bool adapt: true
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Item {
                        width: userImage.width
                        height: userImage.height
                        Rectangle {
                            anchors.centerIn: parent
                            width: userImage.adapt ? userImage.width : Math.min(userImage.width, userImage.height)
                            height: userImage.adapt ? userImage.height : width
                            radius: Math.min(width, height)
                        }
                    }
                }
                MouseArea {
                    width: userImage.width
                    height: userImage.height
                    onClicked: {
                        console.log("Image clicked!");
                        isUserListVisible = !isUserListVisible;
                    }
                }
            }
        }
        UsersList {
            id: userList
            x: 0
            z: 1

            visible: isUserListVisible

            onUserSelected: {
                userImage.source = userList.selectedImage;
                username.text = userList.selectedUsername;
                password.forceActiveFocus();
                isUserListVisible = false;
            }
        }

        QQC.TextField {
            id: username
            width: 362
            height: 40
            text: userList.defaultUser
            horizontalAlignment: Text.AlignLeft
            font.pointSize: 13
            font.weight: Font.Normal
            font.family: localFont.name
            antialiasing: false
            palette.text: "white"
            placeholderText: qsTr("Username")
            placeholderTextColor: "#ffffff"
            background: Rectangle { color: "#b3000000"; radius: 10 }

            onFocusChanged: {
                if (focus) selectAll()
            }
            onAccepted: loginButton.clicked()
            KeyNavigation.down: password
        }
        QQC.TextField {
                id: password
                width: 362
                height: 40
                echoMode: showText ? QQC.TextField.Normal : QQC.TextField.Password
                horizontalAlignment: Text.AlignLeft
                font.pointSize: 13
                font.family: localFont.name
                activeFocusOnPress: true
                palette.text: "white"
                placeholderText: qsTr("Password")
                placeholderTextColor: "#fff"
                background: Rectangle { color: "#b3000000"; radius: 10 }
                passwordCharacter: "•"


                KeyNavigation.down: revealSecret
                states: [
                        State {
                            name: "focused"
                            when: password.activeFocus
                            PropertyChanges {
                                target: password.background
                                border.color: "#5cb3e0"
                            }
                            PropertyChanges {
                                target: password
                                color: "#5cb3e0"
                            }
                        }
                    ]

                    transitions: [
                        Transition {
                            PropertyAnimation {
                                properties: "color, border.color"
                                duration: 150
                            }
                        }
                    ]


                    onAccepted: {
                        sddm.login(username.text.toLowerCase(), password.text, sessionButton.currentIndex);
                    }
            }

            Item {
                id: secretImage
                width: password.width  // Ensures alignment
                height: 20  // Adjust as needed

                Image {
                    id: revealSecret
                    fillMode: Image.PreserveAspectFit
                    source: showText ? "../assets/secret_revealed.png" : "../assets/secret.png"
                    anchors.centerIn: parent  // Now centers within secretImage container
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            showText = !showText;
                        }
                    }
                }
            }
        QQC.Button {
            id: loginButton
            width: 180
            height: 40
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Login")
            highlighted: true
            flat: false
            icon.color: "#2c2d2d"
            font.family: localFont.name
            checkable: true

            background: Rectangle {
                color: isHovered ? "#9ed0ff" : "#2278cd"
                radius: 10
                border.color: "#f9f9f9"
                border.width: 1
            }

            MouseArea {
                anchors.fill: parent
                onEntered: { isHovered = true; }
                onExited: { isHovered = false; }
                onClicked: { sddm.login(username.text.toLowerCase(), password.text, sessionButton.currentIndex) }
            }


        }
        QQC.Label {
            id: notificationMessage
            z: 10

            width: 240
            color: "red"
            text: ""
            font.family: localFont.name
            visible: true
        }

}











Item {
    id: footer
    anchors {
        bottom: parent.bottom
        left: parent.left
        right: parent.right
        margins: Kirigami.Units.smallSpacing
    }
    height: Kirigami.Units.gridUnit * 3
    visible: true

    Rectangle {
        anchors.fill: parent
        color: "#222222"
        opacity: 0.9
        radius: 5
    }

    Row {
        anchors.centerIn: parent
        spacing: Kirigami.Units.largeSpacing

        PlasmaComponents.ToolButton {
            icon.name: "system-suspend"
            icon.color: "white"
            font.family: localFont.name
            text: "<font color=\"#FFFFFF\">Sleep</font>"
            onClicked: sddm.suspend()
            enabled: sddm.canSuspend
        }
        PlasmaComponents.ToolButton {
            icon.name: "system-reboot"
            icon.color: "white"
            font.family: localFont.name
            text: "<font color=\"#FFFFFF\">Restart</font>"
            onClicked: sddm.reboot()
            enabled: sddm.canReboot
        }
        PlasmaComponents.ToolButton {
            icon.name: "system-shutdown"
            icon.color: "white"
            font.family: localFont.name
            text: "<font color=\"#FFFFFF\">Shut Down</font>"
            onClicked: sddm.powerOff()
            enabled: sddm.canPowerOff
        }
    }
}
Connections {
    target: sddm
    function onLoginFailed() {
        notificationMessage.text = i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Login Failed")

    }
    function onLoginSucceeded() {

    }
}
}


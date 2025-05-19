import QtQuick 2.15
import Qt5Compat.GraphicalEffects 1.0
import QtQuick.Controls 2.4 as QQC
import org.kde.plasma.plasma5support 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.breeze.components
import org.kde.kirigami 2.20 as Kirigami
import "components"
import "assets"
Item {
    id: root
    height: 1080
    width: 1920



    QtObject {
        readonly property var localFont: FontLoader {
            id: localFont
            source: "assets/fonts/IndieFlower-Regular.ttf"
        }

    }





    property string selectedImage: ""
    property string selectedUsername: ""
    property string selectedSession: ""
    property string notificationMessage
    property bool isUserListVisible: false
    property bool showText: false
    property bool isHovered: false

    BorderImage {
        id: backgroundImage
        x: 0
        y: 0
        height: parent.height
        width: parent.width
        source: "assets/background.jpg"
        border { left: 0; top: 0; right: 0; bottom: 0;}
        asynchronous: true
        cache: true
        clip: true
        visible: true
        anchors.fill: parent.fill


    }
    Item {
        id: clock
        anchors.fill: parent.fill
        anchors.horizontalCenter: root.horizontalCenter


        Clock {

            anchors.fill: parent


        }

}
    QQC.StackView {
                id: mainStack
                anchors {
                    left: parent.left
                    right: parent.right
                }
                height: root.height
                initialItem: Login {
                    id: userListComponent

    }



    }

    PlasmaComponents.ToolButton {
                       id: virtualKeyboardButton


                            text: i18ndc("<font color=\"#FFFFFF\">plasma-desktop-sddm-theme</font>", "<font color=\"#FFFFFF\">Button to show/hide virtual keyboard</font>", "<font color=\"#FFFFFF\">Virtual Keyboard</font>")

                            font.family: localFont.name
                             font.pixelSize: 18
                             anchors.bottom: parent.bottom
                             anchors.left: parent.left
                             anchors.rightMargin: 50




                        icon.name: "input-keyboard"
                        icon.color: "white"





                       onClicked: {

                           userListComponent.password.forceActiveFocus();
                            inputPanel.showHide();
                       }
                       visible: inputPanel.status === Loader.Ready


                       containmentMask: Item {
                           parent: virtualKeyboardButton
                           anchors.fill: parent


                       }
                   }


    KeyboardButton {
        id: keyboardButton

        onKeyboardLayoutChanged: {

                            userListComponent.password.forceActiveFocus();
                        }


                        containmentMask: Item {
                            parent: keyboardButton
                            anchors.fill: parent
                            anchors.leftMargin: virtualKeyboardButton.visible
                        }
                    }

    VirtualKeyboardLoader {
                id: inputPanel

                z: 1

                screenRoot: root
                mainStack: mainStack
                mainBlock: userListComponent
                passwordField: userListComponent.password
            }
    SessionButton {
    id: sessionButton

        anchors.fill: parent.fill
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        onSessionChanged: {
            userListComponent.password.forceActiveFocus();
        }

    }



}

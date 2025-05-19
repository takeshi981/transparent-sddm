
import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami
import "../assets"
PlasmaComponents.ToolButton {
    id: root

    property int currentIndex: -1

    contentItem: Text {
        font.family: localFont.name
        font.pixelSize: 18
        color: "white"  // Customize text color
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Desktop Session: %1", instantiator.objectAt(currentIndex).text || "")

    }


    visible: menu.count > 1

    Component.onCompleted: {
        currentIndex = sessionModel.lastIndex
    }
    checkable: true
    checked: menu.opened
    onToggled: {
        if (checked) {
            menu.popup(root, 0, 0)
        } else {
            menu.dismiss()
        }
    }

    signal sessionChanged()

   QQC.Menu {

        id: menu

        background: Rectangle{
                    implicitWidth: 300
                    implicitHeight: 40
                    color: "#b3000000"
                    border.color: "#5cb3e0"
                    radius: 2
        }


        Instantiator {
            id: instantiator
            model: sessionModel
            onObjectAdded: (index, object) => menu.insertItem(index, object)
            onObjectRemoved: (index, object) => menu.removeItem(object)
            delegate: PlasmaComponents.MenuItem {
                text: model.name
                contentItem: Text {
                    text: model.name
                    color: "white"
                }

                onTriggered: {
                    root.currentIndex = model.index
                    sessionChanged()
                }
            }

        }


    }
}

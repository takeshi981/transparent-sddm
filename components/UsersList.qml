import QtQuick 2.4
import QtQuick.Controls 2.4
import org.kde.kirigami 2.20 as Kirigami
ListView {
    id: view
    width: parent.width
    height: parent.height
    z: 1
    readonly property string selectedUser: currentItem ? currentItem.userName : ""
    readonly property int userItemWidth: Kirigami.Units.gridUnit * 8
    readonly property int userItemHeight: Kirigami.Units.gridUnit * 9
    readonly property bool constrainText: count > 1
    property int fontSize: Kirigami.Theme.defaultFont.pointSize + 2
    property string selectedImage: ""
    property string selectedUsername: ""
    property string defaultImage: ""
    property string defaultUser: ""
    model: userModel

    signal userSelected()
    orientation: ListView.Horizontal
     highlightRangeMode: ListView.StrictlyEnforceRange
     preferredHighlightBegin: width/2 - userItemWidth/2
     preferredHighlightEnd: preferredHighlightBegin

     interactive: count > 1

     Component.onCompleted: {
         ListView.currentIndex = userModel.lastIndex;
         defaultImage = userModel.data(userModel.index(userModel.lastIndex,0), 260);
         defaultUser = userModel.data(userModel.index(userModel.lastIndex,0), 257);
         console.log(userModel.lastUser);
     }
    delegate: UserDelegate {

        avatarPath: {
            var incompatible = /\/usr\/share\/sddm\/faces\/((root)?)\.face\.icon$/
            if (!model.icon || incompatible.test(model.icon))
                return ""

            return model.icon
        }
        iconSource: model.iconName || "user-identity"
        fontSize: view.fontSize
        needsPassword: model.needsPassword !== undefined ? model.needsPassword : true
        vtNumber: model.vtNumber

        name: {
            const displayName = model.realName || model.name

            if (model.vtNumber === undefined || model.vtNumber < 0) {
                return displayName
            }

            if (!model.session) {
                return i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "Nobody logged in on that session", "Unused")
            }


            let location = undefined
            if (model.isTty) {
                location = i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "User logged in on console number", "TTY %1", model.vtNumber)
            } else if (model.displayNumber) {
                location = i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "User logged in on console (X display number)", "on TTY %1 (Display %2)", model.vtNumber, model.displayNumber)
            }

            if (location !== undefined) {
                return i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "Username (location)", "%1 (%2)", displayName, location)
            }

            return displayName
        }

        userName: model.name

        width: userItemWidth
        height: userItemHeight

        //if we only have one delegate, we don't need to clip the text as it won't be overlapping with anything
        constrainText: view.constrainText

        isCurrent: ListView.isCurrentItem

        onClicked: {
            ListView.currentIndex = index;
             userList.selectedImage = model.icon;
             userList.selectedUsername = model.name;
             userList.userSelected();
        }

    }




    Keys.onEscapePressed: view.userSelected()
    Keys.onEnterPressed: view.userSelected()
    Keys.onReturnPressed: view.userSelected()
}



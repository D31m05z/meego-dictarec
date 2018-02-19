/** * * * Gergely Boross - 2012_02_27 * * * * * * * * * * * * *\
*    _ _____   _____        __ _                              *
*   (_)  __ \ / ____|      / _| |                             *
*   |_| |__)| (___    ___ | |_| |___      ____ _ _ __ ___     *
*   | |  _  / \___ \ / _ \|  _| __\ \ /\ / / _` | '__/ _ \    *
*   | | | \ \ ____) | (_) | | | |_ \ V  V / (_| | | |  __/    *
*   |_|_|  \_\_____/ \___/|_|  \__| \_/\_/ \__,_|_|  \___|    *
*                                                             *
*                http://irsoftware.net                        *
*                                                             *
*              contact_adress: sk8Geri@gmail.com               *
*                                                               *
*       This file is a part of the work done by aFagylaltos.     *
*         You are free to use the code in any way you like,      *
*         modified, unmodified or copied into your own work.     *
*        However, I would like you to consider the following:    *
*                                                               *
*  -If you use this file and its contents unmodified,         *
*              or use a major part of this file,               *
*     please credit the author and leave this note untouched.   *
*  -If you want to use anything in this file commercially,      *
*                please request my approval.                    *
*                                                              *
\* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

import QtQuick 1.1
import com.nokia.meego 1.0

import ShareCommand 1.0

Page {
    id : controlID;
    opacity: 0
    orientationLock:  PageOrientation.LockPortrait
    clip: true

    property int numOfSelectedItems: 0
    property alias removeMode: playlist.removeMode
    property string info_warning

    function clearSelection(remove) {
        var currentSongRemoved = false
        for (var i = 0; i < player.playlistModel.count; i++) {
            if (player.playlistModel.get(i).selected) {
                if (remove) {
                    if (i == player.index)
                        currentSongRemoved = true

                    player.remove(i)
                    i--
                } else {
                    player.playlistModel.setProperty(i, "selected", false)
                }
            }
        }
        if (currentSongRemoved)
            player.refreshSong()

        numOfSelectedItems = 0
    }

    ShareCommand {
        id: sharer
    }

    Dialog {
        id: itemEditorQ
        title: Item {
            id: titleField
            height: itemEditorQ.platformStyle.titleBarHeight
            width: parent.width
            Image {
                id: supplement
                source: "../images/trash-icon.png"
                height: parent.height - 10
                width: 75
                fillMode: Image.PreserveAspectFit
                anchors.leftMargin: 5
                anchors.rightMargin: 5
            }

            Label {
                id: titleLabel
                anchors.left: supplement.right
                anchors.verticalCenter: titleField.verticalCenter
                font.capitalization: Font.MixedCase
                color: "white"
                text: "DELETE"
            }

            Image {
                id: closeButton
                anchors.verticalCenter: titleField.verticalCenter
                anchors.right: titleField.right

                source: "image://theme/icon-m-common-dialog-close"

                MouseArea {
                    id: closeButtonArea
                    anchors.fill: parent
                    onClicked:  { itemEditorQ.reject(); }
                }
            }
        }

        content:Item {
            id: name
            height: childrenRect.height
            Text {
                id: text
                font.pixelSize: 22
                color: "white"
                text: "Are you sure\ndelete these selected files?"
            }
        }

        buttons: ButtonRow {
            platformStyle: ButtonStyle { }
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                id: b1; text: "Yes"; onClicked:{
                    playlist.state = "outTrash"
                    clearSelection(true);
                    itemEditorQ.reject();
                    playlist.removeMode = false
                    background.state = "back"
                }
            }
            Button {id: b2; text: "No"; onClicked: {itemEditorQ.reject()}}
        }
    }

    QueryDialog {
        id: coming_soon
        icon: "../images/under-construction.png"
        titleText: "Coming Soon!!!"
        message: "Coming Soon..."
        acceptButtonText: "Ok"
    }

    QueryDialog {
        id: warning
        icon: "../images/information-alert-48.png"
        titleText: "Warning!!!"
        message: info_warning
        acceptButtonText: "Ok"
    }

    Dialog {
        id: rename_dialog
        title: Item {
            id: titleField2
            height: rename_dialog.platformStyle.titleBarHeight
            width: parent.width
            Image {
                id: supplement2

                source: "../images/rename.png"
                height: 84
                width: 84
                fillMode: Image.PreserveAspectFit
            }

            Label {
                anchors.left: supplement2.right
                anchors.leftMargin: 10
                anchors.top: supplement2.top
                anchors.topMargin:20
                anchors.verticalCenter: titleField2.verticalCenter
                font.capitalization: Font.MixedCase
                color: "white"
                text: "RENAME FILE"
            }

            Image {
                anchors.verticalCenter: titleField2.verticalCenter
                anchors.right: titleField2.right

                source: "image://theme/icon-m-common-dialog-close"

                MouseArea {
                    anchors.fill: parent
                    onClicked:  { rename_dialog.reject(); }
                }
            }
        }

        content:Item {
            TextField {
                id: custom
                x:-40
                y: 15
                width:400

                placeholderText: player.title
                platformStyle: TextFieldStyle { paddingRight: clearButton.width }

                platformSipAttributes: SipAttributes {
                    actionKeyLabel: "rename"
                    actionKeyHighlighted: true
                }

                Image {
                    id: clearButton
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image://theme/icon-m-input-clear"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            //InputContext.reset();
                            custom.text = "";
                        }
                    }
                }

                Keys.onReturnPressed: {
                    if(custom.text==""){
                        info_warning="must be named";
                        warning.open();
                    }else{
                        player.rename(player.index,custom.text.toString());
                        rename_dialog.reject();
                        inputContext.reset();
                        custom.closeSoftwareInputPanel();
                        custom.text = "";
                    }
                }

            }
        }
    }

    Playlist {
        id: playlist

        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 110
        anchors.bottomMargin: 160
        anchors.fill: parent

        states: [
            State {
                name: "inTrash"
                PropertyChanges {
                    target: playlist
                    anchors.topMargin: 10
                }
            },
            State {
                name: "outTrash"
                PropertyChanges {
                    target: playlist
                    anchors.topMargin: 110
                }
            }
        ]

        transitions: Transition {
            NumberAnimation {properties:"topMargin" ; duration: 100 }
            //  PropertyAnimation { properties: "opacity"; duration: 100 }
        }
    }

    ToolBarLayout {
        id: itemEditor
        visible:  playlist.removeMode

        anchors {
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
            bottom: parent.bottom
            bottomMargin: -330
        }

        Button {
            text: qsTr("Remove")
            width: 150
            enabled: numOfSelectedItems > 0
            onClicked: itemEditorQ.open();
        }

        Button {
            text: qsTr("Cancel")
            width: 150
            onClicked: {
                playlist.state = "outTrash"
                background.state = "back"
                clearSelection(false)
                playlist.removeMode = false
            }
        }
    }

    Image {
        id: black_bg
        anchors.fill: parent
        z: -1
        opacity: 0.6
        source: "../images/bg_black.png"
    }

    Image {
        id: share_bg
        anchors.fill: parent
        z: -1
        opacity: 0
        source: "../images/playlist-share.png"
    }

    Image {
        id: edit_bg
        anchors.fill: parent
        z: -1
        opacity: 0
        source: "../images/playlist-editor.png"
    }

    Image {
        id: remove_bg
        anchors.fill: parent
        z: -1
        opacity: 0
        source: "../images/irREC-playlist2_remove.png"
    }

    Image {
        id: background
        anchors.fill: parent
        z: -1
        opacity: 1
        source:  "../images/irREC-playlist2.png"

        //----------------swipe---------------------------------
        MouseArea {
            anchors.fill: background

            property int oldX: 0
            property int oldY: 0

            onPressed: {
                oldX = mouseX;
                oldY = mouseY;
            }

            onReleased: {
                if(!playlist.removeMode){
                    var xDiff = oldX - mouseX;
                    var yDiff = oldY - mouseY;
                    if( Math.abs(xDiff) > Math.abs(yDiff) ) {
                        if( oldX > mouseX) {
                            if(controlPage.status == PageStatus.Active){
                                console.log("loadSettings");
                                pageStack.push(settingsPage);
                                player.stop();
                            }
                        } else {
                            if(controlPage.status == PageStatus.Active){
                                console.log("loadMain");
                                myRecorder.powerSave(false);
                                pageStack.pop(imainPage);
                                player.stop();
                            }
                        }
                    }

                    if(mouseY<115){
                        if(mouseX<150){
                            if(controlPage.status == PageStatus.Active){
                                console.log("loadMain");
                                myRecorder.powerSave(false);
                                pageStack.pop(imainPage);
                                player.stop();
                            }
                        }else if(mouseX>340){
                            if(controlPage.status == PageStatus.Active){
                                console.log("loadSettings");
                                pageStack.push(settingsPage);
                                player.stop();
                            }
                        }
                    }
                }
            }
        }
        //----------------swipe---------------------------------

        states: [
            State {
                name: "share"
                PropertyChanges {
                    target: share_bg
                    opacity: 1
                }
                PropertyChanges {
                    target: background
                    opacity: 0
                }
            },
            State {
                name: "edit"
                PropertyChanges {
                    target: edit_bg
                    opacity: 1
                }
                PropertyChanges {
                    target: background
                    opacity: 0
                }
            },
            State {
                name: "remove"
                PropertyChanges {
                    target: remove_bg
                    opacity: 1
                }
                PropertyChanges {
                    target: background
                    opacity: 0
                }
            },
            State {
                name: "back"
                PropertyChanges {
                    target: background
                    opacity: 1
                }
            }
        ]

        transitions: Transition {
            PropertyAnimation { properties: "opacity"; duration: 300 }
        }
    }



    Item {
        id: controlContainer
        visible:  !playlist.removeMode
        x: 0
        y: 0

        height: parent.height
        anchors.rightMargin: 0
        width: Math.min(parent.width, parent.height)
        anchors.right: parent.right



        Item {
            id: seekSlider
            visible:  !playlist.removeMode

            anchors { bottom: parent.bottom; bottomMargin: 2 }
            width: parent.width
            height: slider.height + positionTime.height


            Slider {
                id: slider

                anchors.top: parent.top
                anchors.topMargin: -30
                width: parent.width
                maximumValue: player.duration
                stepSize: 1

                onPressedChanged: {
                    //if (!pressed)
                    player.position = value
                }

                Binding {
                    target: slider
                    property: "value"
                    value: player.position
                    when: !slider.pressed
                }
            }

            Text {
                id: positionTime

                anchors { left: parent.left; top: slider.bottom; leftMargin: 15; topMargin: -2 }
                color: "white"
                font.bold: true
                font.pixelSize: 18
                text: player.positionTime
            }

            Text {
                id: durationTime

                anchors { right: parent.right; top: slider.bottom; rightMargin: 15; topMargin: -2 }
                color: "white"
                font.bold: true
                font.pixelSize: 18
                text: player.durationTime
            }
        }

        Item {
            id: infoText
            visible:  !playlist.removeMode

            anchors { bottom: seekSlider.top; bottomMargin: 36 }
            width: parent.width
            height: title.height + 15
            clip: true


            Text {
                id: title

                width: parent.width
                anchors.bottom: parent.bottom
                horizontalAlignment: Text.AlignHCenter
                text: player.title
                color: "black"
                font.bold: true
                font.pixelSize: 20
                wrapMode: Text.WordWrap

                Behavior on text {
                    NumberAnimation {
                        target: title
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 1000
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "begin"
            when: controlID.visible
            PropertyChanges {
                target: controlID
                opacity: 1
            }
        }
    ]
    transitions: [
        Transition {
            from: "*"
            to: "begin"
            PropertyAnimation { properties: "opacity"; duration: 800 }
        }
    ]
}

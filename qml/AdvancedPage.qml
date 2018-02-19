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

Page {
    id: settingsID
    opacity: 0
    orientationLock:  PageOrientation.LockPortrait
    clip: true

    property alias backgroundImage:  background.source
    property string info_warning

    FontLoader { id: iFont; source: "../fonts/cordiau.ttf" }

    QueryDialog {
        id: warning
        icon: "../images/information-alert-48.png"
        titleText: "Warning!!!"
        message: info_warning
        acceptButtonText: "Ok"
    }

    Dialog {
        id: saveFolderInput
        title: Item {
            id: titleField2

            Label {
                anchors.left: parent.right
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin:20
                anchors.verticalCenter: titleField2.verticalCenter

                font.family: "iFont"
                color:"#bbb"
                font.pointSize: 20

                text: "Save to folder"
            }

            Image {
                anchors.verticalCenter: titleField2.verticalCenter
                anchors.right: titleField2.right

                source: "image://theme/icon-m-common-dialog-close"

                MouseArea {
                    anchors.fill: parent
                    onClicked:  { saveFolderInput.reject(); }
                }
            }
        }

        content:Item {
            TextField {
                id: custom
                x:-40
                y: 15
                width:400

                placeholderText: saveFolder
                platformStyle: TextFieldStyle { paddingRight: clearButton.width }

                platformSipAttributes: SipAttributes {
                    actionKeyLabel: "change"
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
                        saveFolder = custom.text.toString();
                        myRecorder.changeSaveFolder(saveFolder);

                        saveFolderInput.reject();
                        inputContext.reset();
                        custom.closeSoftwareInputPanel();
                        custom.text = "";
                    }
                }

            }
        }
    }

    Image {
        id: background
        anchors.fill: parent
        z: -1

        // swipe
        MouseArea {
            anchors.fill: background
            property int oldX: 0
            property int oldY: 0

            onPressed: {
                oldX = mouseX;
                oldY = mouseY;
            }

            onReleased: {
                var xDiff = oldX - mouseX;
                var yDiff = oldY - mouseY;
                if( Math.abs(xDiff) > Math.abs(yDiff) ) {
                    if( oldX < mouseX) {
                        if(advancedPage.status == PageStatus.Active){
                            console.log("loadSettings");
                            pageStack.pop(settingsPage);
                        }
                    }
                }

                if(mouseY<115 && mouseX<150){
                    if(advancedPage.status == PageStatus.Active){
                        console.log("loadSettings");
                        pageStack.pop(settingsPage);
                    }
                }
            }
        }
    }

    Column {
        id:functions
        width: parent.width
        x:20
        y:150

        Text {
            text: (("Advanced User Settings | ") +  ( advancedUse ? "enabled" : "disabled" ))
            font.family: "iFont"
            color:"#bbb"
            font.pointSize: 20

        }

        Row {
            spacing: 20

            Image {
                id:advanced_on
                x:200
                source: advancedUse ? "../images/advanced_icon_on.png" : "../images/advanced_icon_off.png"
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        advancedUse = !advancedUse;

                        if(advancedUse) {
                            advancedDescriptionSampleRate = "44.1 kHz";
                            advancedDescriptionCodec = "AAC";
                            advancedDescriptionBitrate = bitrate;
                            myRecorder.changeQuality(1,44100,128000)
                        }else {
                            appWindow.cdQuality = true;
                            container = ".aac"
                            myRecorder.changeQuality(1,44100,128000)
                        }
                    }
                }
            }

            Text {
                y:20
                text: advancedUse ? "WARNING!\nadvanced users settings" : "Simple settings"
                font.family: "iFont"
                color:"#bbb"
                font.pointSize: 20

            }
        }


        //     Text {
        //         text: "-------------------------------------------------------------"
        //         font.family: "iFont"
        //         color:"#bbb"
        //         font.pointSize: 20

        //     }

        //       Row{
        //             spacing: 10
        //             Image {
        //                 id: saveFolderImg
        //                 visible: advancedUse

        //                 source: "../images/saveFolder.png"

        //                 MouseArea {
        //                     anchors.fill: parent
        //                     onClicked:  { saveFolderInput.open(); }
        //                 }
        //             }

        //             Text{
        //                 y:40
        //                 visible: advancedUse

        //                 text: "Save to " + saveFolder
        //                 font.family: "iFont"
        //                 color:"#bbb"
        //                 font.pointSize: 20
        //             }

        //         }
    }

    Text {  font.pointSize: 30; text: "DictaRec Aug-2013"; anchors.bottom: parent.bottom; anchors.bottomMargin: 50; anchors.horizontalCenterOffset: 0; font.bold: true; verticalAlignment: Text.AlignTop; horizontalAlignment: Text.AlignHCenter; anchors.horizontalCenter: parent.horizontalCenter; font.family: "iFont"; color:"#bbb"}
    Text {  font.pointSize: 10; text: "developer: Gergely Boross | aFagylaltos(c)"; anchors.bottom: parent.bottom; anchors.bottomMargin: 30; anchors.horizontalCenterOffset: 0; font.bold: false; verticalAlignment: Text.AlignTop; horizontalAlignment: Text.AlignHCenter; anchors.horizontalCenter: parent.horizontalCenter; font.family: "iFont"; color:"#bbb"}

    states: [
        State {
            name: "begin"
            when: settingsID.visible
            PropertyChanges {
                target: settingsID
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

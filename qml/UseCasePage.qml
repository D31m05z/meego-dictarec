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

    FontLoader { id: iFont; source: "../fonts/cordiau.ttf" }

    Image {
        id: background
        anchors.fill: parent
        z: -1

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
                var xDiff = oldX - mouseX;
                var yDiff = oldY - mouseY;
                if( Math.abs(xDiff) > Math.abs(yDiff) ) {
                    if( oldX < mouseX) {
                        if(useCasePage.status == PageStatus.Active){
                            console.log("loadSettings");
                            pageStack.pop(settingsPage);
                        }
                    }
                }

                if(mouseY<115 && mouseX<150){
                    if(useCasePage.status == PageStatus.Active){
                        console.log("loadSettings");
                        pageStack.pop(settingsPage);
                    }
                }
            }
        }
        //----------------swipe---------------------------------
    }

    QueryDialog {
        opacity: 0.5
        id: youTube
        icon: "../images/youtube.png"
        titleText: "DictaRec the professional recorder for N9"
        message: "Please wait...\n"
        acceptButtonText: "Ok"
        onAccepted: {
            youTube.close();
        }
    }

    //////////////////////////DESCRIPTION/////////////////////////////////////////

    Column{
        id:functions
        width: parent.width
        x:50
        y:140

        Text {
            id: function1
            color: "#bbb"
            text: "simple click: play/pause"
            font.pointSize: 27
            font.family: "iFont"
        }

        Text {
            id: function2
            color: "#bbb"
            text: "double click: rename"
            font.pointSize: 27
            font.family: "iFont"
        }

        Text {
            id: function3
            color: "#bbb"
            text: "hold: remove"
            font.pointSize: 27
            font.family: "iFont"
        }

        /*Text {
            id: function4
            color: "#bbb"
            text: "swipe right: editor"
            font.pointSize: 27
            font.family: "iFont"
        }*/

        Text {
            id: function5
            color: "#bbb"
            text: "swipe left: share"
            font.pointSize: 27
            font.family: "iFont"
        }
    }


    Text {
        id: showYouTubeText
        color: "#bbb"
        text: "Show on YouTube"

        x:80
        y:550
        font.bold: true
        font.pointSize: 30
        font.family: "iFont"
    }

    Image {
        id: showYouTbe
        source: "../images/youtube.png"
        x:180
        y:600
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                Qt.openUrlExternally("http://youtu.be/KWwGRoQc0Cw");
                youTube.open();
            }
        }
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

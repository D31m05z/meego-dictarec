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
                        if(mouseY>138 && mouseY<278){
                            if(settingsPage.status == PageStatus.Active){
                                console.log("loadUseCase");
                                pageStack.push(useCasePage);
                            }
                        }if(mouseY>358 && mouseY<498){
                            if(settingsPage.status == PageStatus.Active){
                                console.log("loadQuality");
                                pageStack.push(qualityPage);
                            }
                        }if(mouseY>588 && mouseY<728){
                            if(settingsPage.status == PageStatus.Active){
                                console.log("loadAdvanced");
                                pageStack.push(advancedPage);
                            }
                        }else if(settingsPage.status == PageStatus.Active){
                            console.log("loadPlaylist");
                            pageStack.pop(controlPage);
                        }
                    }
                }

                if(mouseY<115 && mouseX<150){
                    if(settingsPage.status == PageStatus.Active){
                        console.log("loadPlaylist");
                        pageStack.pop(controlPage);
                    }
                }if(mouseY>138 && mouseY<278){
                    if(settingsPage.status == PageStatus.Active){
                        console.log("loadUseCase");
                        pageStack.push(useCasePage);
                    }
                }if(mouseY>358 && mouseY<498){
                    if(settingsPage.status == PageStatus.Active){
                        console.log("loadQuality");
                        pageStack.push(qualityPage);
                    }
                }if(mouseY>588 && mouseY<728){
                    if(settingsPage.status == PageStatus.Active){
                        console.log("loadAdvanced");
                        pageStack.push(advancedPage);
                    }
                }
            }
        }
        //----------------swipe---------------------------------
    }

    Image{
        id: settings_items
        source: "../images/settings-items.png"
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

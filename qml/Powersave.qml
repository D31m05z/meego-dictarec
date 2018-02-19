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

Page{
    id: iSuspend
    opacity: 0
    orientationLock:  PageOrientation.LockPortrait

    Image {
        id: main
        source: "../images/powersave.png"
        anchors.fill: parent

        Text {
            id: suspend
            x: 5
            y: 20
            color: (appWindow.record && !appWindow.pause_rec) ? "red":"white"
            text: appWindow.recordStatus
            font.bold: true
            font.pixelSize: 50
        }

        Text {
            id: record_suspend
            x: 5
            y: 650
            color: (appWindow.record && !appWindow.pause_rec) ? "red":"white"
            text: player.playing ? "Playing" : (appWindow.record && !appWindow.pause_rec) ? "Recording" : "Powersave"
            font.bold: true
            font.pixelSize: (appWindow.record && !appWindow.pause_rec) ? 100 : 95
        }
    }


    states: [
        State {
            name: "begin"
            when: iSuspend.visible
            PropertyChanges {
                target: iSuspend
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

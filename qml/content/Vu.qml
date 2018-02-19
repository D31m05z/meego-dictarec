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

Item {
    id: root
    property real value : 0

    width: 210; height: 210

    Image { source: "../../images/background.png" }

    Image {
        x: 88
        y: 48
        source: "../../images/ir-shadow.png"
        transform: Rotation {
            origin.x: 9; origin.y: 67
            angle: needleRotation.angle
        }
    }

    Image {
        id: needle
        x: 90; y: 46
        smooth: true
        source: "../../images/ir-needle.png"
        transform: Rotation {
            id: needleRotation
            origin.x: 5; origin.y: 65

            angle: Math.min(Math.max(-50, root.value*2.6 - 50), 50)
            Behavior on angle {
                SpringAnimation {
                    spring: 1.4
                    damping: .15
                }
            }

        }
    }

    Image { x: 11; y: 9; width: 150; height: 105; source: "../../images/ir-overlay.png"

        Image {
            id: image1
            x: 67
            y: 90
            width: 34
            height: 38
            source: "../../images/ir-butt.png"
        } }
}

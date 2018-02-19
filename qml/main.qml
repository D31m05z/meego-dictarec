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

PageStackWindow {
    id: appWindow

    property bool record: false
    property bool play: false
    property bool pause: false
    property bool pause_rec: false
    property bool cdQuality: true

    property bool edit: false
    property bool share: false

    property string recordStatus
    property string file_name
    property string note
    property real volume
    property real duration

    property int encoding : 1
    property int sample_rate : 44100
    property int bitrate : 128000
    property string container : ".aac"
    property bool advancedUse : false

    property string editFileName;
    property string saveFolder: "rec"

    property string advancedDescriptionCodec;
    property string advancedDescriptionBitrate;
    property string advancedDescriptionSampleRate;

    initialPage: Mainwindow {
        id: root;
    }
    showToolBar: false
}



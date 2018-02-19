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

import QtMultimediaKit 1.1
import com.meego.extras 1.0

import "content"

Page{
    id: irMAIN
    opacity: 0
    orientationLock:  PageOrientation.LockPortrait

    function start_stop() {
        appWindow.record = !appWindow.record
        if(record) {
            record_status.state = "recording"
            iQuality.state = "recording"
            iQualityAdvanced.state = "recording"
            myRecorder.recStart()

        } else {
            record_status.state = "stopped"
            iQuality.state = "stopped"
            iQualityAdvanced.state = "stopped"
            myRecorder.recStop()
            var file = "file:///" + file_name
            player.addSong(file, "new note", duration)
            player.stop()
            player.refreshSong();
            console.log("--REFRESH-SONG--");
        }
        if(pause_rec)pause_rec = !pause_rec
    }

    function record_pause() {
        appWindow.pause_rec = !appWindow.pause_rec

        if(pause_rec)myRecorder.recPause()
        else myRecorder.recPause()
    }

    //----------------swipe---------------------------------
    MouseArea {
        id: mouseArea
        anchors.fill: main;

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
                if( oldX > mouseX) {
                    if(!appWindow.record && imainPage.status == PageStatus.Active){
                        console.log("loadPlaylist");
                        myRecorder.powerSave(true);
                        pageStack.push(controlPage);
                    }
                }
            }

            if( (mouseX>380 && mouseX<480) && (mouseY>310 && mouseY<430)){
                if(!appWindow.record && imainPage.status == PageStatus.Active){
                    console.log("loadPlaylist");
                    myRecorder.powerSave(true);
                    pageStack.push(controlPage);
                }
            }
        }
    }
    //----------------swipe---------------------------------

    Image {
        id: main
        source:  (appWindow.record && !appWindow.pause_rec) ? "../images/background_rec.jpg" : "../images/background.jpg"
        anchors.fill: parent
        Image {
            id: blank_rec
            x:10
            y:28
            source:  appWindow.pause_rec ? "../images/rec-pause-icon.png" : "../images/rec-start-icon2.png"
            visible: (appWindow.record || appWindow.pause_rec)
            opacity: 0.0

            SequentialAnimation {
                id: blank_rec_anim
                running: true
                loops: Animation.Infinite
                NumberAnimation { target: blank_rec; property: "opacity"; to: appWindow.pause_rec? 0.5 : 1.0; duration: 800}
                NumberAnimation { target: blank_rec; property: "opacity"; to: 0.0; duration: 800}
            }
        }

        FontLoader { id: iFont; source: "../fonts/cordiau.ttf" }

        Text {
            id: record_status
            x: 80
            y: -30
            color: appWindow.pause_rec ? "#bbb" : "#bbb"
            text: appWindow.recordStatus
            width: parent.width
            font.pixelSize:  120
            font.family: iFont.name
            font.bold: false

            anchors.topMargin: -80
            anchors.leftMargin: 70
            anchors.rightMargin: 10
            anchors.fill: parent

            states: [
                State {
                    name: "stopped"
                    PropertyChanges {
                        target: record_status
                        anchors.topMargin:-50
                    }

                    PropertyChanges {
                        target: record_status
                        opacity: 0
                    }
                },
                State {
                    name: "recording"
                    PropertyChanges {
                        target: record_status
                        anchors.topMargin:-30
                    }

                    PropertyChanges {
                        target: record_status
                        opacity: 1
                    }
                }
            ]

            transitions: Transition {
                NumberAnimation {properties:"topMargin" ; duration: 180 }
                PropertyAnimation { properties: "opacity"; duration: 180 }
            }
        }

        Item {
            id:iQuality;
            opacity: 1
            anchors.fill: main
            visible: !advancedUse

            Image {
                id: speech_quality_img
                x:0
                y:10
                source:  appWindow.cdQuality ? "../images/speech-quality.png" : "../images/speech-quality_.png"
                opacity: 1.0

                SequentialAnimation {
                    id: speech_quality_anim
                    running: !appWindow.cdQuality
                    loops: Animation.Infinite
                    NumberAnimation { target: speech_quality_img; property: "opacity"; to: 1.0; duration: 800}
                    NumberAnimation { target: speech_quality_img; property: "opacity"; to: 0.2; duration: 800}

                }

                MouseArea{
                    id: speech_click0
                    anchors.fill: speech_quality_img;
                    onClicked: {
                        appWindow.cdQuality = false;
                        myRecorder.changeQuality(1,22050,64000)
                    }
                }
            }

            Text {
                id: quality1
                x: 100
                y: 0
                height:150
                color: appWindow.pause_rec ? "#bbb" : "#bbb"
                text: "speech"

                font.pixelSize:  55
                font.family: iFont.name
                MouseArea{
                    id: quality1_click
                    anchors.fill: quality1;
                    onClicked: {
                        appWindow.cdQuality = false;
                        myRecorder.changeQuality(1,22050,64000)
                    }
                }
            }

            Image {
                id: cd_quality_img
                x:280
                y:10
                source:  appWindow.cdQuality ? "../images/cd-quality_.png" : "../images/cd-quality.png"
                opacity: 1.0

                SequentialAnimation {
                    id: cd_quality_anim
                    running: appWindow.cdQuality
                    loops: Animation.Infinite
                    NumberAnimation { target: cd_quality_img; property: "opacity"; to: 1.0; duration: 800}
                    NumberAnimation { target: cd_quality_img; property: "opacity"; to: 0.2; duration: 800}

                }

                MouseArea{
                    id: cd_click0
                    anchors.fill: cd_quality_img;
                    onClicked: {
                        appWindow.cdQuality = true;
                        myRecorder.changeQuality(1,44100,128000)
                    }
                }
            }

            Text {
                id: quality2
                x: 370
                y: 0
                height:150
                color: appWindow.pause_rec ? "#bbb" : "#bbb"
                text: "cd"

                font.pixelSize:  55
                font.family: iFont.name

                MouseArea{
                    id: quality2_click
                    anchors.fill: quality2;
                    onClicked: {
                        appWindow.cdQuality = true;
                        myRecorder.changeQuality(1,44100,128000)
                    }
                }
            }

            states: [
                State {
                    name: "recording"
                    PropertyChanges {
                        target: iQuality
                        anchors.topMargin:-50
                    }
                    PropertyChanges {
                        target: iQuality
                        opacity: 0
                    }
                },
                State {
                    name: "stopped"
                    PropertyChanges {
                        target: iQuality
                        anchors.topMargin:0
                    }
                    PropertyChanges {
                        target: iQuality
                        opacity: 1
                    }
                }
            ]

            transitions: Transition {
                NumberAnimation {properties:"topMargin" ; duration: 180 }
                PropertyAnimation { properties: "opacity"; duration: 180 }
            }
        }

        //------------------advanced-------------------------

        Item {
            id:iQualityAdvanced;
            opacity: 1
            anchors.fill: main
            visible: advancedUse

            Image {
                id: advancedImage
                x:0
                y:10
                source:  "../images/advanced_icon_on.png"
                opacity: 1.0

                SequentialAnimation {
                    id: advancedImage_anim
                    running: !appWindow.cdQuality
                    loops: Animation.Infinite
                    NumberAnimation { target: speech_quality_img; property: "opacity"; to: 1.0; duration: 800}
                    NumberAnimation { target: speech_quality_img; property: "opacity"; to: 0.2; duration: 800}

                }

                MouseArea{
                    id: advancedImageClick
                    anchors.fill: advancedImage;
                    onClicked: {
                        if(imainPage.status == PageStatus.Active){
                            console.log("loadQuality");
                            pageStack.push(qualityPage);
                        }
                    }
                }
            }

            Text {
                id: advancedText
                x: 100
                y: 20
                height:150
                color: "#bbb"
                text: "advanced"

                font.pixelSize:  55
                font.family: iFont.name
            }

            Text {
                id: advancedDescription1
                x: 270
                y: 5
                height:150
                color: "#bbb"
                text: "codec| " + advancedDescriptionCodec

                font.pixelSize:  30
                font.family: iFont.name
            }

            Text {
                id: advancedDescription2
                x: 270
                y: 30
                height:150
                color: "#bbb"
                text: "bitrate| " + advancedDescriptionBitrate

                font.pixelSize:  30
                font.family: iFont.name
            }

            Text {
                id: advancedDescription3
                x: 270
                y: 50
                height:150
                color: "#bbb"
                text: "sampleRate| " + advancedDescriptionSampleRate

                font.pixelSize:  30
                font.family: iFont.name
            }

            states: [
                State {
                    name: "recording"
                    PropertyChanges {
                        target: iQualityAdvanced
                        anchors.topMargin:-50
                    }
                    PropertyChanges {
                        target: iQualityAdvanced
                        opacity: 0
                    }
                },
                State {
                    name: "stopped"
                    PropertyChanges {
                        target: iQualityAdvanced
                        anchors.topMargin:0
                    }
                    PropertyChanges {
                        target: iQualityAdvanced
                        opacity: 1
                    }
                }
            ]

            transitions: Transition {
                NumberAnimation {properties:"topMargin" ; duration: 180 }
                PropertyAnimation { properties: "opacity"; duration: 180 }
            }
        }

        ////-RECORDER//////////////////////////////////////////////////////////////////
        ToolButton {
            id: record_button
            flat: true
            anchors.left: parent.left
            anchors.leftMargin: -20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            iconSource: appWindow.record ? "../images/irREC-black-stop.png" : "../images/irREC-black-rec.png"
            height:128
            onClicked: {
                start_stop()
                pause_banner.hide();
                record_banner.show();
            }
        }

        ToolButton {
            id: pause_button
            flat: true
            visible: appWindow.record
            anchors.right: parent.right
            anchors.rightMargin: -25
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            iconSource: appWindow.pause_rec ? "../images/irREC-black-rec.png" : "../images/irREC-black-pause.png"
            height:128
            onClicked: {
                record_pause()
                record_banner.hide();
                pause_banner.show();

            }
        }

        ToolButton {
            id: play_button
            flat: true
            visible: !appWindow.record
            anchors.right: parent.right
            anchors.rightMargin: -25
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15

            iconSource: "../images/irREC-black-play.png"
            height:128
            onClicked: {
                if(!appWindow.record && imainPage.status == PageStatus.Active){
                    myRecorder.powerSave(true);
                    pageStack.push(controlPage);
                }
            }
        }

        Vu {
            id: dial
            anchors.horizontalCenterOffset: 17
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -10
            value: volume*30
        }

        InfoBanner {
            id: record_banner
            text: appWindow.record ? "Recording..." : "Stopped"
            timerEnabled: true
            iconSource: appWindow.record ? "../images/rec-start-icon.png" : "../images/rec-stop-icon.png"
            timerShowTime: 1000
            y:550
        }

        InfoBanner {
            id: pause_banner
            text: appWindow.pause_rec ? "Paused" : "Recording..."
            timerEnabled: true
            iconSource: appWindow.pause_rec ? "../images/rec-pause-icon.png" : "../images/rec-start-icon.png"
            timerShowTime: 1000
            y:550
        }
    }

    states: [
        State {
            name: "begin"
            when: irMAIN.visible
            PropertyChanges {
                target: irMAIN
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

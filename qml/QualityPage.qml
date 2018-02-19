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



    function change(){
        var actual = select_sample_rates.model.get(select_sample_rates.selectedIndex).name;
        if(actual=="22.05 kHz"){
            sample_rate=22050;
            advancedDescriptionSampleRate = "22.05 kHz";
        }
        else if(actual=="44.1 kHz"){
            sample_rate=44100;
            advancedDescriptionSampleRate = "44.1 kHz";
        }


        actual = select_bitrates.model.get(select_bitrates.selectedIndex).name;
        if(actual=="32000")
            bitrate=32000;
        else if(actual=="64000")
            bitrate=64000;
        else if(actual=="96000")
            bitrate=96000;
        else if(actual=="128000")
            bitrate=128000;

        actual = select_audio_codec.model.get(select_audio_codec.selectedIndex).name;
        if(actual=="AAC"){
            encoding=1;
            container=".aac";
            advancedDescriptionCodec = "AAC";
        } else if(actual=="FLAC"){
            encoding=2;
            container=".flac";
            advancedDescriptionCodec = "FLAC";
        } else if(actual=="PCM"){
            encoding=3;
            container=".pcm";
            advancedDescriptionCodec = "PCM";
        } else if(actual=="SPX"){
            encoding=4;
            container=".spx";
            advancedDescriptionCodec = "SPX";
        } else if(actual=="AMR"){
            encoding=5;
            container=".amr";
            advancedDescriptionCodec = "AMR";
        } else if(actual=="AMR-WB"){
            encoding=6;
            container=".awb";
            advancedDescriptionCodec = "AMR-WB";
        }


        advancedDescriptionBitrate = bitrate;


        //int,int,int
        myRecorder.changeQuality(encoding,sample_rate,bitrate);
    }


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
                        if(qualityPage.status == PageStatus.Active){
                            console.log("loadSettings");
                            change();
                            pageStack.pop(settingsPage);

                            if(pageStack.currentPage == suspend){
                                pageStack.push(imainPage);
                            }
                        }
                    }
                }

                if(mouseY<115 && mouseX<150){
                    if(qualityPage.status == PageStatus.Active){
                        console.log("loadSettings");
                        change();
                        pageStack.pop(settingsPage);

                        if(pageStack.currentPage == suspend){
                            pageStack.push(imainPage);
                        }
                    }
                }
            }
        }
        //----------------swipe---------------------------------
    }

    Item{
        id: simpleSetting
        visible: !advancedUse
        /////////////////////////////SPEECH_QUALITY/////////////////////////////////////////////////////
        Image {
            id: speech_quality_img
            x:50
            y:100
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
            id: speech_quality_text
            x: 150
            y: 100
            color: "#bbb"
            text: "speech quality"
            height: 300

            font.pixelSize:  60
            font.family: iFont.name

            MouseArea{
                id: speech_click1
                anchors.fill: speech_quality_text;
                onClicked: {
                    appWindow.cdQuality = false;
                    container=".aac";
                    myRecorder.changeQuality(1,22050,64000)
                }
            }
        }

        Text {
            id: speech
            x: 150
            y: 150
            color: "#bbb"
            text: "simple dialog record\nsmall file size"

            font.pixelSize:  40
            font.family: iFont.name
        }

        ///////////////////////////////CD_QUALITY/////////////////////////////////////////////////////
        Image {
            id: cd_quality_img
            x:50
            y:250
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
            id: cd_quality_text
            x: 150
            y: 250
            color: "#bbb"
            text: "cd quality"
            height: 300

            font.pixelSize:  60
            font.family: iFont.name

            MouseArea{
                id: cd_click1
                anchors.fill: cd_quality_text;
                onClicked: {
                    appWindow.cdQuality = true;
                    container=".aac";
                    myRecorder.changeQuality(1,44100,128000)
                }
            }
        }

        Text {
            id: cd
            x: 150
            y: 300
            color: "#bbb"
            text: "professional quality"

            font.pixelSize:  40
            font.family: iFont.name
        }
    }
    //-------------------CHOSE FILE FORMAT--------------------------


    SelectionDialog {
        id: select_sample_rates
        titleText: "Select sample rate"
        selectedIndex: 1

        model: ListModel {
            ListElement { name: "22.05 kHz" }
            ListElement { name: "44.1 kHz" }
        }
    }

    SelectionDialog {
        id: select_bitrates
        titleText: "Select bitrate"
        selectedIndex: 3

        model: ListModel {
            ListElement { name: "32000" }
            ListElement { name: "64000" }
            ListElement { name: "96000" }
            ListElement { name: "128000" }
        }
    }

    SelectionDialog {
        id: select_audio_codec
        titleText: "Select encoding"
        selectedIndex: 0

        model: ListModel {
            ListElement { name: "AAC" }
            ListElement { name: "FLAC" }
            ListElement { name: "PCM" }
            ListElement { name: "SPX" }
            //    ListElement { name: "AMR" }
            //    ListElement { name: "AMR-WB" }
        }
    }

    Column {
        id: column1
        x:100
        y:150
        spacing: 5
        visible: advancedUse


        Text { id: text1; font.pointSize: 20; text: "Select encoding "; font.family: "Impact"; style: Text.Outline; styleColor: "#0077ff" }
        Button {
            opacity: 0.5
            text: select_audio_codec.model.get(select_audio_codec.selectedIndex).name;
            onClicked: {
                select_audio_codec.open();
            }
        }

        Text { id: text2; font.pointSize: 20; text: "Select sample rate "; font.family: "Impact"; style: Text.Outline; styleColor: "#0077ff" }
        Button {
            opacity: 0.5
            text: select_sample_rates.model.get(select_sample_rates.selectedIndex).name;
            onClicked: {
                select_sample_rates.open();
            }
        }

        Text { id: text3; font.pointSize: 20; text: "Select bitrates"; font.family: "Impact"; style: Text.Outline; styleColor: "#0077ff"}

        Button {
            opacity: 0.5
            text: select_bitrates.model.get(select_bitrates.selectedIndex).name;
            onClicked: {
                select_bitrates.open();
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

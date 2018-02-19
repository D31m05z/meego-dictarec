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

//import QtMobility.feedback 1.1

Item {
    property bool removeMode: false
    property alias header: listview.header

    property real oldX: 0
    property real oldY: 0
    property bool mousePressed: false
    property real changeX: 0
    property bool canPlay: true
    property bool shotVibrate: false

    property bool needUpdate: false

    //    HapticsEffect {
    //            id: rumbleEffect
    //            attackIntensity: 0.0
    //            attackTime: 100
    //            intensity: 0.8
    //            duration: 100 // set up the duration here, in millisecond
    //            fadeTime: 100
    //            fadeIntensity: 0.0
    //        }

    //    FileEffect {
    //        id: myFileEffect
    //        loaded: false

    //        source: "file:///usr/share/sounds/vibra/tct_small_alert.ivt"
    //    //     source: "file:///usr/share/sounds/ui-tones/snd_default_beep.wav"
    //    }


    Component {
        id: playlistDelegate


        Item {
            height: 75
            width: listview.width
            x: index == player.index ? -changeX/2 : 0
            opacity:  ((index == player.index) ? 1 : 15/Math.abs(changeX))

            Rectangle{
                anchors.fill: parent
                color: ( (index == player.index) ? ((edit==true || share==true) ? "red":"#eeebeb") : "gray" )

                opacity: 0.2
            }

            Row {
                anchors { top: parent.top; bottom: parent.bottom; margins: 10 }
                width: parent.width

                Item {
                    id: numText

                    width: 25
                    height: parent.height
                    anchors.top: parent.top

                    Image {
                        anchors.top: parent.top
                        anchors.topMargin: 8
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: (index == player.index) && !removeMode && !share && !edit
                        source: player.playing ? "../images/ir_current_track_play.svg" : "../images/ir_current_track_pause.svg"
                    }
                }

                Column {
                    width: (listview.width > 300) ? (parent.width - timeText.width - numText.width) : (parent.width - timeText.width)
                    spacing: 5

                    Text {
                        id: titleText
                        width: parent.width

                        elide: Text.ElideRight
                        font.pixelSize:  index == player.index ? 33 : 30
                        font.letterSpacing: -1
                        font.family: "Chaparral Pro Light"
                        color: index == player.index ? "white" : "#c8c4c4"
                        text: /*(index == player.index) ? (edit==true) ? "EDIT >>" : share==true ? "<< SHARE" : title : */title
                    }
                }

                Item {
                    width: 60
                    height: parent.height

                    Text {
                        id: timeText

                        width: parent.width
                        font.bold: true
                        visible: !removeMode && listview.width > 300 && !share && !edit
                        anchors.top: parent.top
                        anchors.topMargin: 8
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        font.pixelSize: 22
                        font.letterSpacing: -1
                        color: "steelblue"
                        text: time
                    }

                    CheckBox {
                        visible: removeMode
                        anchors.centerIn: parent
                        checked: selected
                    }
                }
            }

            MouseArea {
                id:mouseEvent
                anchors.fill: parent

                onPressed: {
                    console.log("onPressed");
                    oldX = mouseX;
                    oldY = mouseY;
                    mousePressed = true;
                }

                onMouseXChanged: {
                    if(!playlist.removeMode && mousePressed){

                        if(player.index != index)
                            needUpdate = true;

                        player.index = index;
                        changeX =  oldX-mouseX;

                        if(changeX>=10){
                            share = true;
                            player.stop();

                            if(background.state != "share")
                                background.state = "share"

                            if(!shotVibrate) {
                                //myFileEffect.start();
                                myRecorder.vibrate();
                            }

                            canPlay = false;
                            shotVibrate = true;
                        }/* else if(changeX<=-10){
                      edit = true;
                      player.stop();

                      if(!background.state != "edit")
                          background.state = "edit"

                     if(!shotVibrate)
                         myRecorder.vibrate();

                      canPlay = false;
                      shotVibrate = true;
                    }*/

                        if(changeX>=100) {
                            console.log("share");

                            if(!shotVibrate)
                                myRecorder.vibrate();

                            if(needUpdate){
                                console.log("updateSource");
                                player.updateSource();
                                needUpdate = false;
                            }

                            sharer.share("/home/user/MyDocs/" + saveFolder + "/" + player.title.toString() );
                            player.stop();

                            mousePressed = false;
                            edit = false;
                            share = false;
                            changeX = 0;
                            background.state = "back"
                            shotVibrate = false;
                        }
                        /*else if(changeX<=-100){
                       console.log("edit");

                       if(!shotVibrate)
                           myRecorder.vibrate();

                       if(needUpdate){
                           console.log("updateSource");
                           player.updateSource();
                           needUpdate = false;
                       }

                       editFileName = player.title.toString()
                       pageStack.push(editorPage);
                       player.stop();

                       mousePressed = false;
                       edit = false;
                       share = false;
                       changeX = 0;
                       background.state = "back"
                       shotVibrate = false;
                   }*/
                    }
                }

                onDoubleClicked: {
                    console.log("onDoubleClicked");
                    if(!removeMode){
                        myRecorder.vibrate();
                        player.stop();
                        rename_dialog.open();
                        custom.forceActiveFocus();
                    }
                }

                onPressAndHold: {
                    console.log("onPressAndHold");
                    if(!share && !edit && !removeMode && !shotVibrate){
                        console.log("removeMode");
                        background.state = "remove"
                        changeX = 0;
                        shotVibrate = true;

                        playlist.state = "inTrash"
                        playlist.removeMode = true ;
                        player.stop();
                        player.playlistModel.setProperty(player.index, "selected", true);
                        numOfSelectedItems++;
                        //          rumbleEffect.start();
                        myRecorder.vibrate();
                    }
                }

                onClicked: {
                    console.log("onClicked");
                    if (removeMode) {
                        var selected = player.playlistModel.get(index).selected
                        player.playlistModel.setProperty(index, "selected", !selected)
                        if (selected)
                            numOfSelectedItems--
                        else
                            numOfSelectedItems++

                    } else {
                        if (player.index == index && canPlay ) {
                            console.log("PLAY");

                            if(needUpdate){
                                console.log("updateSource");
                                player.updateSource();
                                needUpdate = false;
                            }

                            play_banner.show()
                            if (player.playing)
                                player.pause()
                            else
                                player.play()

                        } else {
                            //  player.index = index
                            //  player.refreshSong()
                        }
                    }

                    canPlay = true;
                }

                onReleased: {
                    console.log("onReleased");
                    edit = false;
                    share = false;
                    changeX = 0;
                    if(!removeMode)
                        background.state = "back"

                    shotVibrate = false;
                }
            }

            Behavior on x {
                SpringAnimation {
                    spring: 2
                    damping: 0.2
                }
            }
        }
    }

    ListView {
        id: listview

        anchors.fill: parent
        model: player.playlistModel
        delegate: playlistDelegate
        currentIndex: player.index
        cacheBuffer: height
        clip: true
        highlightMoveDuration: 500
        spacing: 5


        ScrollDecorator {
            flickableItem: parent
        }

        onContentYChanged: {
            //   console.log("onContentYChanged");

            edit = false;
            share = false;
            changeX = 0;
            if(!removeMode)
                background.state = "back"

            shotVibrate = false;
        }
    }

    InfoBanner{
        id: play_banner
        text: player.playing ? "Playing..." : "Pause"
        timerEnabled: true
        iconSource: player.playing ? "../images/play-icon.png" : "../images/stop-icon.png"
        timerShowTime: 1000

    }
}

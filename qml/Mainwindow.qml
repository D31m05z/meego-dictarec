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

import MediaKeysObserver 1.0
import "Storage.js" as Storage
//import QtMobility.gallery 1.1

Page {
    id: mainwindow

    orientationLock:  PageOrientation.LockPortrait

    property Item musicPickerPage

    function change() {
        if(sample_rate==22050) {
            advancedDescriptionSampleRate = "22.05 kHz";
        } else if(sample_rate==44100) {
            advancedDescriptionSampleRate = "44.1 kHz";
        }

        if(encoding==1) {
            advancedDescriptionCodec = "AAC";
        } else if(encoding==2) {
            advancedDescriptionCodec = "FLAC";
        } else if(encoding==3) {
            advancedDescriptionCodec = "PCM";
        } else if(encoding==4) {
            advancedDescriptionCodec = "SPX";
        } else if(encoding==5) {
            advancedDescriptionCodec = "AMR";
        } else if(encoding==6) {
            advancedDescriptionCodec = "AMR-WB";
        }

        advancedDescriptionBitrate = bitrate;
    }

    Player {
        id: player

        Component.onCompleted: {

            console.log("onCompleted | LOAD SETTINGS");

            Storage.initialize()

            Storage.getPlaylist(playlist)
            playlistLoaded()

            var res = Storage.getSetting("volume")
            if (res != "Unknown")
                volume = parseFloat(res)

            res = Storage.getSetting("index")
            if (res != "Unknown") {
                index = parseInt(res)
                refreshSong()
            }

            res = Storage.getSetting("encoding")
            if (res != "Unknown") {
                encoding = parseInt(res)
            }
            res = Storage.getSetting("sample_rate")
            if (res != "Unknown") {
                sample_rate = parseInt(res)
            }
            res = Storage.getSetting("bitrate")
            if (res != "Unknown") {
                bitrate = parseInt(res)
            }

            res = Storage.getSetting("advancedUse")
            if (res != "Unknown") {
                advancedUse = res
            }
            res = Storage.getSetting("container")
            if (res != "Unknown") {
                container = res.toString()
            }
            res = Storage.getSetting("saveFolder")
            if (res != "Unknown") {
                saveFolder = res.toString()
            }
            res = Storage.getSetting("cdQuality")
            if (res != "Unknown") {
                cdQuality = res
            }

            if(advancedUse)
                change()
            else {
                if(cdQuality) {
                    sample_rate = 44100
                    bitrate = 128000
                } else{
                    sample_rate = 22050
                    bitrate = 64000
                }
                encoding = 1
                container = ".aac"
            }

            myRecorder.changeQuality(encoding,sample_rate,bitrate);
            myRecorder.changeSaveFolder(saveFolder);
            console.log("onCompleted | LOADED");
            console.log(container);

            myRecorder.powerSave(false);
            console.log("=====SUSPEND-SWITCH-==OFF======");
        }

        Component.onDestruction: {

            console.log("onDestruction | SAVE SETTINGS");

            Storage.setSetting("volume", volume)
            Storage.setSetting("index", index)
            Storage.setSetting("encoding", encoding)
            Storage.setSetting("sample_rate", sample_rate)
            Storage.setSetting("bitrate", bitrate)
            Storage.setSetting("advancedUse", advancedUse)
            Storage.setSetting("container", container)
            Storage.setSetting("saveFolder", saveFolder)
            Storage.setSetting("cdQuality", cdQuality)
            Storage.setPlaylist(playlist)

            console.log("onDestruction | SAVED");
        }

        MediaKeysObserver {
            id: mediakeysobserver

            property int key

            onMediaKeyClicked: {
                switch (key) {
                case MediaKeysObserver.EVolIncKey:
                    audio.volume += 0.1
                    break
                case MediaKeysObserver.EVolDecKey:
                    audio.volume -= 0.1
                    break
                case MediaKeysObserver.EStopKey:
                    stop()
                    break
                case MediaKeysObserver.EBackwardKey:
                    previous()
                    break
                case MediaKeysObserver.EForwardKey:
                    next()
                    break
                case MediaKeysObserver.EPlayPauseKey:
                    if (playing)
                        pause()
                    else
                        play()

                    break
                }
            }

            onMediaKeyPressed: {
                mediakeysobserver.key = key
                timer.start()
            }

            onMediaKeyReleased: {
                timer.stop()
            }
        }

        Timer {
            id: timer
            interval: 300
            repeat: true
            onTriggered: {
                switch (mediakeysobserver.key) {
                case MediaKeysObserver.EVolIncKey:
                    player.volume += 0.1
                    break

                case MediaKeysObserver.EVolDecKey:
                    player.volume -= 0.1
                    break
                }
            }
        }
    }


    ListModel {
        id: selection
    }

    ///////////////////////////////////////////////////

    PageStack {
        id: pageStack

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        MainPage{
            id: imainPage
        }

        ControlsPage {
            id: controlPage
        }

        SettingsPage {
            id: settingsPage
            backgroundImage: "../images/settings-background.png"
        }

        UseCasePage {
            id: useCasePage
            backgroundImage: "../images/use_case_bg.png"
        }

        QualityPage {
            id: qualityPage
            backgroundImage: "../images/quality_bg.png"
        }

        AdvancedPage {
            id: advancedPage
            backgroundImage: "../images/advanced_bg.png"
        }

        Powersave {
            id: suspend
        }

        EditorPage {
            id: editorPage
            backgroundImage: "../images/editor-bg.png"
        }
    }

    Component.onCompleted: {
        pageStack.push(imainPage);
        //appWindow.cdQuality = true;
    }

    Component.onDestruction: {
        console.log("--DESTRUCTOR");

        if(record){
            myRecorder.recordStop()
            var file = "file:///" + file_name
            console.log(file + duration);

            player.addSong(file, "new note",duration)

            player.stop()
            player.refreshSong();
            console.log("--REFRESH-SONG--");
        }
    }

    function powerSaveON(){
        if(pageStack.currentPage!=suspend){
            myRecorder.powerSave(true);
            pageStack.push(suspend);
            console.log("=====SUSPEND-SWITCH-==ON=======");
        }
    }

    function powerSaveOFF(){
        if(pageStack.currentPage!=imainPage){
            if(player.playing)
                pageStack.push(controlPage);
            else {
                myRecorder.powerSave(false);
                pageStack.push(imainPage);
            }
            console.log("=====SUSPEND-SWITCH-==OFF======");
        }
    }

    states: [
        State {
            name: "fullsize-visible"
            when: platformWindow.viewMode == WindowState.Fullsize && platformWindow.visible
            StateChangeScript {
                script: {
                    powerSaveOFF();
                }
            }
        },
        State {
            name: "thumbnail-or-invisible"
            when: platformWindow.viewMode == WindowState.Thumbnail || !platformWindow.visible
            StateChangeScript {
                script: {
                    powerSaveON();
                }
            }
        }
    ]
}

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

Item {
    id: player

    property bool playing: false
    property int index: -1
    property alias playlistModel: playlist
    property alias count: playlist.count
    property string title : audio.metaData.title!= undefined && audio.source != "" ? audio.metaData.title : getFileFromPath(audio.source.toString())

    property string src: audio.metaData.title!= undefined && audio.source != "" ? audio.metaData.title : getFileFromPath(audio.source.toString())
    property int duration: audio.source != "" ? audio.duration : 0
    property string durationTime: audio.source != "" ? getTimeFromMSec(audio.duration) : ""
    property alias position: audio.position
    property string positionTime: getTimeFromMSec(position)
    property alias volume: audio.volume
    property string error: audio.errorString
    property alias playlist:  playlist


    property string title_temp

    signal playlistLoaded

    function play() {
        var file = "file:///home/user/MyDocs/" + saveFolder + "/" + src
        audio.source = file
        audio.play()
        console.log(audio.source)

        playing = true
    }

    function pause() {
        audio.pause()
        playing = false
    }

    function stop() {
        audio.stop()
        playing = false
    }

    function previous() {
        var i = index - 1
        if (i < 0)
            i =  0

        index = i
        refreshSong()
    }

    function next() {
        var i =index + 1
        if (i > count - 1) {
            i = count - 1
            playing = false
        }

        index = i
        refreshSong()
    }

    function addSong(file, title, duration) {
        playlist.append({"source": file, "title": title, "time": getTimeFromMSec(duration), "selected": false})

        if (playlist.count == 1) {
            index = 0
            refreshSong()
            play()
        }
    }

    function remove(i) {
        //    console.log(playlist.get(i).source)
        myRecorder.removeFile(playlist.get(i).title)
        playlist.remove(i)

        if (playlist.count == 0) {
            stop()

            audio.source = ""
            return
        }

        if (i < index) {
            index--
        } else if (i == index) {
            if (index > count - 1)
                index = count - 1
        }
    }

    function rename(i,new_name) {
        console.log("-------------rename------------------")
        title_temp = playlist.get(i).title
        console.log(title_temp)

        var str=title_temp
        var n=str.indexOf(".")
        var sSubstring = str.substring(n);
        console.log(n)
        console.log(sSubstring)
        new_name +=sSubstring
        playlist.get(i).title = new_name
        console.log(playlist.get(i).title)

        playlist.get(i).source = "file:///home/user/MyDocs/" + saveFolder + "/" + new_name
        refreshSong()
        updatePlaylistData()
        myRecorder.renameFile(title_temp,new_name)
    }

    function refreshSong() {
        var wasPlaying = playing
        stop()

        if (index >= 0 && playlist.count > 0) {
            audio.source = playlist.get(index).source
            if (wasPlaying)
                play()
        }
    }


    function updateSource() {
        if (index >= 0 && playlist.count > 0) {
            audio.source = playlist.get(index).source
        }
    }

    function getFileFromPath(path) {
        return path.substring(path.lastIndexOf(path.charAt(path.indexOf(":") + 1)) + 1)
    }

    function getTimeFromMSec(msec) {
        if (msec <= 0 || msec == undefined) {
            return ""

        } else {
            var sec = "" + Math.floor(msec / 1000) % 60
            if (sec.length == 1)
                sec = "0" + sec

            var hour = Math.floor(msec / 3600000)
            if (hour < 1) {
                return Math.floor(msec / 60000) + ":" + sec
            } else {
                var min = "" + Math.floor(msec / 60000) % 60
                if (min.length == 1)
                    min = "0" + min

                return hour + ":" + min + ":" + sec
            }
        }
    }

    function updatePlaylistData() {
        playlist.setProperty(index, "time", durationTime)
        //    playlist.setProperty(index, "title", title)
    }

    onDurationTimeChanged: playlist.setProperty(index, "time", durationTime)
    onTitleChanged: playlist.setProperty(index, "title", title)

    // TODO: QML ListModel: set: index 0 out of range
    ListModel {
        id: playlist
    }

    Audio {
        id: audio

        volume: 0.5
        onStatusChanged: {
            if (status == Audio.EndOfMedia) {
                next()
            }
        }

        onPlayingChanged: updatePlaylistData()
    }
}

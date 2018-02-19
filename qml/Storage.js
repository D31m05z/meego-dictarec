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


function openDatabase() {
    return openDatabaseSync("irplayer2", "1.2", "Settings", 100000)
}

function initialize() {
    var db = openDatabase()
    db.transaction(
        function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)")
            tx.executeSql("CREATE TABLE IF NOT EXISTS playlist(source TEXT, title TEXT, time TEXT)")
        }
    )
}

function setSetting(setting, value) {
    var db = openDatabase()
    var res = "Error"
    db.transaction(
        function(tx) {
            var rs = tx.executeSql("INSERT OR REPLACE INTO settings VALUES (?,?);", [setting,value])
            if (rs.rowsAffected > 0)
                res = "OK"
        }
    )
    return res
}

function getSetting(setting) {
    var db = openDatabase()
    var res = "Unknown"
    db.transaction(
        function(tx) {
            var rs = tx.executeSql("SELECT value FROM settings WHERE setting=?;", [setting])
            if (rs.rows.length > 0)
                res = rs.rows.item(0).value
        }
    )
    return res
}

function getPlaylist(playlist) {
    var db = openDatabase()
    var res = "Unknown"
    db.transaction(
        function(tx) {
            var rs = tx.executeSql("SELECT * FROM playlist;")
            if (rs.rows.length > 0) {
                for (var i = 0; i < rs.rows.length; i++) {
                    playlist.append({"source": rs.rows.item(i).source, "title": rs.rows.item(i).title, "time": rs.rows.item(i).time, "selected": false})
                }
                res = "OK"
            }
        }
    )
    return res
}

function setPlaylist(playlist) {
    var db = openDatabase()
    var res = "Error"
    db.transaction(
        function(tx) {
            var rs = tx.executeSql("DELETE FROM playlist;")
            var count = 0
            for (var i = 0; i < playlist.count; i++) {
                rs = tx.executeSql("INSERT INTO playlist VALUES (?,?,?);", [playlist.get(i).source, playlist.get(i).title, playlist.get(i).time])
                count += rs.rowsAffected
            }

            if (count > 0)
                res = "OK"
        }
    )
    return res
}

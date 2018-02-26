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

#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QDebug>
#include "src/recorder.h"
#include "src/mediakeysobserver.h"
#include "src/sharecommand.h"
#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QSplashScreen* pSplash = new QSplashScreen();
    pSplash->setPixmap(QPixmap(":/images/splash.png"));
    pSplash->show();

    qmlRegisterType<MediaKeysObserver>("MediaKeysObserver", 1, 0, "MediaKeysObserver");
    qmlRegisterType<ShareCommand>("ShareCommand", 1, 0, "ShareCommand");

    QDeclarativeView viewer;

    Recorder service;
    viewer.rootContext()->setContextProperty("myRecorder", &service);
    viewer.setSource(QUrl("qrc:/qml/main.qml"));
    viewer.showFullScreen();

    service.inicialize(dynamic_cast<QObject*>(viewer.rootObject()));

    pSplash->close();
    delete pSplash;

    return app->exec();
}

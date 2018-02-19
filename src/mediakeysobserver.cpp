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

#include "mediakeysobserver.h"

MediaKeysObserver::MediaKeysObserver(QObject *parent) : QObject(parent)
{
    interfaceSelector = CRemConInterfaceSelector::NewL();
    coreTarget = CRemConCoreApiTarget::NewL(*interfaceSelector, *this);
    interfaceSelector->OpenTargetL();
}

MediaKeysObserver::~MediaKeysObserver()
{
    delete interfaceSelector;
}

void MediaKeysObserver::MrccatoCommand(TRemConCoreApiOperationId operationId,
                                       TRemConCoreApiButtonAction buttonAct)
{
    switch (operationId) {
    case ERemConCoreApiPausePlayFunction:
        if (buttonAct == ERemConCoreApiButtonClick)
            emit mediaKeyClicked(MediaKeysObserver::EPlayPauseKey);
        break;

    case ERemConCoreApiStop:
        if (buttonAct == ERemConCoreApiButtonClick)
            emit mediaKeyClicked(MediaKeysObserver::EStopKey);
        break;

    case ERemConCoreApiRewind:
        if (buttonAct == ERemConCoreApiButtonClick)
            emit mediaKeyClicked(MediaKeysObserver::EFastRewindKey);
        break;

    case ERemConCoreApiForward:
        if (buttonAct == ERemConCoreApiButtonClick)
            emit mediaKeyClicked(MediaKeysObserver::EForwardKey);
        break;

    case ERemConCoreApiVolumeUp:
        if (buttonAct == ERemConCoreApiButtonClick)
            emit mediaKeyClicked(MediaKeysObserver::EVolIncKey);
        else if (buttonAct == ERemConCoreApiButtonPress)
            emit mediaKeyPressed(MediaKeysObserver::EVolIncKey);
        else if (buttonAct == ERemConCoreApiButtonRelease)
            emit mediaKeyReleased(MediaKeysObserver::EVolIncKey);
        break;

    case ERemConCoreApiVolumeDown:
        if (buttonAct == ERemConCoreApiButtonClick)
            emit mediaKeyClicked(MediaKeysObserver::EVolDecKey);
        else if (buttonAct == ERemConCoreApiButtonPress)
            emit mediaKeyPressed(MediaKeysObserver::EVolDecKey);
        else if (buttonAct == ERemConCoreApiButtonRelease)
            emit mediaKeyReleased(MediaKeysObserver::EVolDecKey);
        break;

    case ERemConCoreApiFastForward:
        if (buttonAct == ERemConCoreApiButtonClick)
            emit mediaKeyClicked(MediaKeysObserver::EFastForwardKey);
        else if (buttonAct == ERemConCoreApiButtonPress)
            emit mediaKeyPressed(MediaKeysObserver::EFastForwardKey);
        else if (buttonAct == ERemConCoreApiButtonRelease)
            emit mediaKeyReleased(MediaKeysObserver::EFastForwardKey);
        break;

    case ERemConCoreApiBackward:
        if (buttonAct == ERemConCoreApiButtonClick)
            emit mediaKeyClicked(MediaKeysObserver::EBackwardKey);
        else if (buttonAct == ERemConCoreApiButtonPress)
            emit mediaKeyPressed(MediaKeysObserver::EBackwardKey);
        else if (buttonAct == ERemConCoreApiButtonRelease)
            emit mediaKeyReleased(MediaKeysObserver::EBackwardKey);
        break;

    default:
        break;
    }
}

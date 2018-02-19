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

#ifndef RECORDER_H
#define RECORDER_H

#include <QObject>
#include <QtDeclarative>
#include <QtCore/qurl.h>
#include <QtGui/qmainwindow.h>
#include <qmediarecorder.h>
#include <QRadioTuner>
#include <qaudioinput.h>

class QAudioCaptureSource;

class AudioInfo : public QIODevice
{
    Q_OBJECT
public:
    AudioInfo( QObject *parent);
    ~AudioInfo();

    void start();
    void stop();

    qreal level() const { return m_level; }
    qint64 readData(char *data, qint64 maxlen);
    qint64 writeData(const char *data, qint64 len);

private:
    const QAudioFormat m_format;
    quint16 m_maxAmplitude;
    qreal m_level;
signals:
    void update();
};

class Recorder : public QObject
{
    Q_OBJECT
public:
    Recorder();
    ~Recorder();

    Q_INVOKABLE void vibrate();
    Q_INVOKABLE void recStart();
    Q_INVOKABLE void recStop();
    Q_INVOKABLE void recPause();
    Q_INVOKABLE void playStart();
    Q_INVOKABLE void removeFile(QString name);
    Q_INVOKABLE void renameFile(QString old_name, QString new_name);
    Q_INVOKABLE void powerSave(bool iSuspend);
    Q_INVOKABLE void changeQuality(int m_encoding,int sample_rate,int bitrate);
    Q_INVOKABLE void changeSaveFolder(QString folder);

    void inicialize(QObject *parent);

private slots:
    void setOutputLocation();
    void togglePause();
    void updateProgress(qint64 pos);
    QUrl generateAudioFilePath();
    void effectStateChanged();
    void refreshDisplay();

private:
    QAudioCaptureSource* m_audiosource;
    QAudioEncoderSettings* m_audiosettings;
    QMediaRecorder* m_capture;

    bool m_recording;
    bool m_outputLocationSet;
    bool m_active;
    bool m_powerSave;

    QDir m_outputDir;
    QUrl m_note;
    qreal m_duration;

    AudioInfo *m_audioInfo;
    QAudioFormat m_format;
    QAudioInput *m_audioInput;
    QIODevice *m_input;

    QObject* m_root;

    int m_encoding;
    QString m_codec;
    QString m_container;
    int m_sampleRate;
    int m_bitRate;
    QString m_saveFolder;
};

#endif // RECORDER_H

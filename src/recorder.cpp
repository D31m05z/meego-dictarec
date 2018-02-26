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

#include <QDebug>
#include <QtCore/qdir.h>
#include <QtGui/qfiledialog.h>

#include <qaudiocapturesource.h>
#include <qmediarecorder.h>

#include "recorder.h"

using namespace QtMobility;

AudioInfo::AudioInfo( QObject *parent)
    : QIODevice(parent)
{
    m_maxAmplitude = 32767;
    m_level = 0;
}

AudioInfo::~AudioInfo()
{
}

void AudioInfo::start()
{
    open(QIODevice::WriteOnly);
}

void AudioInfo::stop()
{
    close();
}

qint64 AudioInfo::readData(char *, qint64)
{
    return 0;
}

qint64 AudioInfo::writeData(const char *data, qint64 len)
{
    if (m_maxAmplitude) {
        Q_ASSERT(16 % 8 == 0);
        const int channelBytes = 16 / 8;
        const int sampleBytes = 1 * channelBytes;
        Q_ASSERT(len % sampleBytes == 0);
        const int numSamples = len / sampleBytes;

        quint16 maxValue = 0;
        const unsigned char *ptr = reinterpret_cast<const unsigned char *>(data);

        for (int i = 0; i < numSamples; ++i) {
            for(int j = 0; j <1; ++j) {
                quint16 value = 0;
                value = qAbs(qFromLittleEndian<qint16>(ptr));
                maxValue = qMax(value, maxValue);
                ptr += channelBytes;
            }
        }

        maxValue = qMin(maxValue, m_maxAmplitude);
        m_level = qreal(maxValue) / m_maxAmplitude;
    }

    emit update();
    return len;
}

void Recorder::refreshDisplay()
{
    if(!m_powerSave) {
        // qDebug() << "hang  = " <<  m_audioInfo->level();
        m_root->setProperty("volume", m_audioInfo->level());
    }

    if(m_recording) {
        int msecs = m_capture->duration();
        QString formattedTime;

        int hours = msecs/(1000*60*60);
        int minutes = (msecs-(hours*1000*60*60))/(1000*60);
        int seconds = (msecs-(minutes*1000*60)-(hours*1000*60*60))/1000;
        int milliseconds = msecs-(seconds*1000)-(minutes*1000*60)-(hours*1000*60*60);

        formattedTime.append(QString("%1").arg(hours, 2, 10, QLatin1Char('0')) + ":" +
                             QString( "%1" ).arg(minutes, 2, 10, QLatin1Char('0')) + ":" +
                             QString( "%1" ).arg(seconds, 2, 10, QLatin1Char('0')) + ":" +
                             QString( "%1" ).arg(milliseconds/100));

        m_root->setProperty("recordStatus",formattedTime);
    }
}

void Recorder::inicialize(QObject *parent)
{
    m_root=parent;
    m_root->setProperty("recordStatus","");

    qDebug() << "Set the root direction > MyDocs/"+m_saveFolder ;
    QDir dir(QDir::homePath() + QString("/MyDocs/"+m_saveFolder) );
    if(!dir.exists()) {
        qDebug() << "Create MyDocs/" + m_saveFolder;
        dir.mkdir(QDir::homePath() + QString("/MyDocs/"+m_saveFolder));
    }

    connect(m_capture, SIGNAL(durationChanged(qint64)), this, SLOT(updateProgress(qint64)));

    m_format.setSampleSize(16);

    //-relese 0.8.3
    m_format.setChannels(1);

    QAudioDeviceInfo info(QAudioDeviceInfo::defaultInputDevice());
    if (!info.isFormatSupported(m_format)) {
        qDebug() << "Default format not supported - trying to use nearest";
        m_format = info.nearestFormat(m_format);
    }

    m_audioInfo  = new AudioInfo(this);
    connect(m_audioInfo, SIGNAL(update()), SLOT(refreshDisplay()));
    m_audioInput = new QAudioInput(m_format, this);
    m_audioInfo->start();
    m_audioInput->start(m_audioInfo);
}

Recorder::Recorder()
    : m_recording(false)
    , m_outputLocationSet(false)
    , m_active(false)
    , m_powerSave(false)
    , m_duration(0.0)
    , m_encoding(0)
    , m_sampleRate(0)
{
    m_audiosource = new QAudioCaptureSource();
    m_capture = new QMediaRecorder(m_audiosource);
    m_audiosettings = new QAudioEncoderSettings();

    m_rumble = new QFeedbackHapticsEffect();
    m_rumble->setAttackIntensity(0.0);
    m_rumble->setAttackTime(100);
    m_rumble->setIntensity(0.8);
    m_rumble->setDuration(100);
    m_rumble->setFadeTime(100);
    m_rumble->setFadeIntensity(0.+0);
    connect(m_rumble, SIGNAL(stateChanged()), this, SLOT(effectStateChanged()));
}

Recorder::~Recorder()
{
    delete m_capture;
    delete m_audiosource;
    delete m_audioInput;
    delete m_audioInfo;
    delete m_audiosettings;
}

void Recorder::updateProgress(qint64 duration)
{
    if (m_capture->error() != QMediaRecorder::NoError || duration < 2000)
        return;

    m_root->setProperty("duration",duration);
    //    qDebug() << "duraction: "<< duration<< "  |  " <<duration/1000;
}

void Recorder::togglePause()
{
    if (m_capture->state() != QMediaRecorder::PausedState) {
        m_recording = false;
        m_capture->pause();
    } else {
        m_recording = true;
        m_capture->record();
    }
}

void Recorder::setOutputLocation()
{
    QString fileName = QFileDialog::getSaveFileName();
    m_capture->setOutputLocation(QUrl(fileName));
}

QUrl Recorder::generateAudioFilePath()
{
    QDateTime dateTime2;

    int year=dateTime2.currentDateTime().date().year();
    int month=dateTime2.currentDateTime().date().month();
    int day=dateTime2.currentDateTime().date().day();

    m_outputDir = QDir::homePath() + QString("/MyDocs/"+m_saveFolder);

    int lastImage = 0;
    int fileCount = 0;
    foreach(QString fileName, m_outputDir.entryList(QStringList() << "*")) {
        if (m_outputDir.exists(fileName)) {
            qDebug() << "$EXIST$ !!! : " << fileName;
            fileCount += 1;
            qDebug() << "fileCount: " << fileCount ;
        }
    }

    lastImage += fileCount;
    QUrl location(QDir::toNativeSeparators(
                      m_outputDir.canonicalPath() +
                      QString("/%1_%2_%3-%4%5").arg(year).arg(month).arg(day).arg(lastImage + 1, 4, 10, QLatin1Char('0')).arg(m_container)));

    bool exist = true;
    int inc = 1;
    while(exist) {
        if (m_outputDir.exists(location.toString())) {
            qDebug() << "!! - WARNING: this file is exist alredy!: " << location;

            m_note = QString("%1_%2_%3-%4").arg(year).arg(month).arg(day).arg(lastImage + 1 + inc, 4, 10, QLatin1Char('0'));
            QUrl location_tmp(QDir::toNativeSeparators(m_outputDir.canonicalPath() +"/"+m_note.toString()+m_container));

            location = location_tmp;
            inc += 1;
            qDebug() << "inc: " << inc ;
        } else exist = false;
    }

    qDebug() << "------------------FINISH_SELECT_FLE_NAME--------------------------------";
    qDebug() << "fileCount: " << fileCount ;
    qDebug() << "lastImage: " << lastImage ;
    qDebug() << location.toString();
    qDebug() << "------------------------------------------------------------------------";

    m_root->setProperty("note",m_note.toString());

    return location;
}

void Recorder::effectStateChanged()
{
    QFeedbackHapticsEffect *eff = static_cast<QFeedbackHapticsEffect*>(QObject::sender());
    if (eff->state() == QFeedbackEffect::Stopped) {
        qDebug() << "effect stopped";
        eff->deleteLater();
    }
}

void Recorder::vibrate()
{
    qDebug() << "most rezegni akarok";
    m_rumble->start();
}

void Recorder::recStart()
{
    qDebug() << "startRecording";

    switch(m_encoding){
    case 1:
        m_codec="audio/AAC";
        m_container=".aac";
        break;
    case 2:
        m_codec="audio/FLAC";
        m_container=".flac";
        break;
    case 3:
        m_codec="audio/PCM";
        m_container=".pcm";
        break;
    case 4:
        m_codec="audio/speex";
        m_container=".spx";
        break;
    case 5:
        m_codec="audio/AMR";
        m_container=".amr";
        break;
    case 6:
        m_codec="audio/AMR-WB";
        m_container=".awb";
        break;
    }

    if (m_capture->state() == QMediaRecorder::StoppedState) {
        QUrl recordFileUrl = generateAudioFilePath();
        m_recording = true;

        m_capture->setOutputLocation(recordFileUrl);

        m_audiosettings->setCodec(m_codec);
        m_audiosettings->setSampleRate(m_sampleRate);
        m_audiosettings->setBitRate(m_bitRate);
        m_audiosettings->setChannelCount(2);

        m_audiosettings->setEncodingMode(QtMultimediaKit::ConstantBitRateEncoding);
        m_capture->setEncodingSettings(*m_audiosettings);
        m_capture->record();

        m_root->setProperty("file_name",m_capture->outputLocation().toString());
        qDebug() << "recording to "<<m_capture->outputLocation().toString();
    }
}

void Recorder::recStop()
{
    qDebug() << "stopRecording";
    m_recording = false;
    m_root->setProperty("recordStatus","   Saved");
    m_capture->stop();
}

void Recorder::recPause()
{
    qDebug() << "pause";
    togglePause();
}

void Recorder::playStart()
{
    qDebug() << "play this file:  "<< m_capture->outputLocation().toString();
    m_root->setProperty("file_name",m_capture->outputLocation().toString());
}

void Recorder::removeFile(QString name)
{
    m_outputDir=QDir::homePath() + QString("/MyDocs/"+m_saveFolder);
    QFile del_file(m_outputDir.canonicalPath()+"/"+name);
    if(del_file.exists()) {
        del_file.remove();
        qDebug()<<"DELETED :" << del_file.fileName();
    }
}
void Recorder::renameFile(QString old_name, QString new_name)
{
    m_outputDir=QDir::homePath() + QString("/MyDocs/"+m_saveFolder);
    qDebug()<<"OLD NAME: "<<old_name;

    QFile rename_file(m_outputDir.canonicalPath()+"/"+old_name);
    QString renamed_file(m_outputDir.canonicalPath()+"/"+new_name);
    if(rename_file.exists()) {
        rename_file.rename(renamed_file);
        qDebug()<<"RENAMED :" << rename_file.fileName();
    }
}

void Recorder::powerSave(bool iSuspend)
{
    m_powerSave = iSuspend;

    if(m_powerSave) {
        qDebug() << "PowerSave-ON";
    } else {
        qDebug() << "PowerSave-OFF";
    }
}

void Recorder::changeQuality(int encoding,int sample_rate,int bitrate)
{
    qDebug() << "encoding: " << encoding << "sampleRate: " << sample_rate << "bitRate: " << bitrate;

    this->m_encoding = encoding;
    this->m_sampleRate = sample_rate;
    this->m_bitRate = bitrate;
}

void Recorder::changeSaveFolder(QString folder)
{
    qDebug() << "Save to " << folder;
    m_saveFolder = folder + "/";

    qDebug() << "Set the root direction > MyDocs/"+m_saveFolder ;
    QDir dir(QDir::homePath() + QString("/MyDocs/"+m_saveFolder) );
    if(!dir.exists()) {
        qDebug() << "Create MyDocs/" + m_saveFolder;
        dir.mkdir(QDir::homePath() + QString("/MyDocs/"+m_saveFolder));
    }
}

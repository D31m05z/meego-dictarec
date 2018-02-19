# Add more folders to ship with the application, here
folder_01.source = qml/DictaRec
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xEBC314A6

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

MOBILITY += multimedia feedback

# audiocapturesound
CONFIG += mobility

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

# share ui setup
CONFIG += shareuiinterface-maemo-meegotouch share-ui-plugin share-ui-common mdatauri

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES +=  \
    src/sharecommand.cpp \
    src/main.cpp \
    src/recorder.cpp

HEADERS += \
    src/sharecommand.h \
    src/mediakeysobserver.h \
    src/recorder.h

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qml/Storage.js \
    qml/SettingsPage.qml \
    qml/Powersave.qml \
    qml/Playlist.qml \
    qml/Player.qml \
    qml/Mainwindow.qml \
    qml/MainPage.qml \
    qml/main.qml \
    qml/ControlsPage.qml \
    qml/content/Vu.qml \
    qml/EditorPage.qml \
    qml/UseCasePage.qml \
    qml/QualityPage.qml \
    qml/AdvancedPage.qml

RESOURCES += \
    resource.qrc

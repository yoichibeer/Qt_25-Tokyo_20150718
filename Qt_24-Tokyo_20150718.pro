TEMPLATE = app

QT += qml quick widgets xml

SOURCES += main.cpp \
    squarebinding.cpp \
    domcomparetest.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    squarebinding.h \
    domcomparetest.h \
    defs.h

CONFIG += c++11

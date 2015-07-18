#include <QApplication>
#include <QQmlApplicationEngine>

#include <QtQml>

#include "squarebinding.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<SquareBinding>("Qt_24_Tokyo_20150718", 1, 0, "SquareBinding");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

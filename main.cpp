#include <QApplication>
#include <QQmlApplicationEngine>

#include <QtQml>

#include "squarebinding.h"
#include "domcomparetest.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // Dom比較テスト
    DomCompareTest domCompareTest;
    domCompareTest.test();

    // QMLで使えるようにクラス登録
    qmlRegisterType<SquareBinding>("Qt_25_Tokyo_20150718", 1, 0, "SquareBinding");

    // アプリ起動
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}

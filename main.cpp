#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "debug.hpp"
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SeekNEat", "Main");

    SNEconnection conn;
    conn.init();
    SNEdebug(1, conn.login("midair", "pwdpwdpwd"));
    SNEdebug(1, conn.signup("midair@midair.dev", "midair", "pwdpwdpwd"));

    conn.cleanup();

    return app.exec();
}

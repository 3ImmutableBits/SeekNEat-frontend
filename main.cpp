#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "debug.hpp"
#include "connection/connection.hpp"
#include "btnHandler.hpp"
#include "textHandler.hpp"
#include "textController.hpp"

SNEconnection conn;

int main(int argc, char *argv[])
{
    btnHandler Bhandler;
    textHandler Thandler;
    textController authController;
    textController editController;

    Bhandler.authCtl = &authController;
    Bhandler.editCtl = &editController;

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SeekNEat", "Main");

    conn.init();

    engine.rootContext()->setContextProperty("btnHandler", &Bhandler);
    engine.rootContext()->setContextProperty("textHandler", &Thandler);
    engine.rootContext()->setContextProperty("authController", &authController);
    engine.rootContext()->setContextProperty("editController", &editController);

    return app.exec();
}

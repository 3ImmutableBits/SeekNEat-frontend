#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "debug.hpp"
#include "connection/connection.hpp"

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
    //SNEdebug(1, conn.signup("midair@midair.dev", "midair", "pwdpwdpwd"));
    //SNEdebug(1, conn.createMeal("Bordura", "Bordura de pe DN1, gust placut de ciment", 10, 1.240260, 32.824854));
    //SNEdebug(1, conn.joinMeal(1));
    conn.deleteMeal(1);
    auto res = conn.fetchMeals("dn2");
    for(auto i : res)
    {
        SNEdebug(1, i.name);
    }

    //SNEdebug(1, conn.logout());

    conn.cleanup();

    return app.exec();
}

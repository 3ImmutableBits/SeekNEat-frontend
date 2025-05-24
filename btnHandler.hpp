#ifndef BTNHANDLER_HPP
#define BTNHANDLER_HPP

#include <QObject>
#include <QString>
#include "connection/connection.hpp"
#include "textHandler.hpp"
#include "textController.hpp"

class btnHandler : public QObject {
    Q_OBJECT

public:
    textController* authCtl;
    textController* editCtl;

public:
    explicit btnHandler(QObject *parent = nullptr);
    ~btnHandler();

public slots:
    void handleLoginBtn();
    void handleRegisterBtn();
    void handleLogoutBtn();
    void handleUserEditBtn();
    void handleSubmitMeal();
};

extern SNEconnection conn;

#endif
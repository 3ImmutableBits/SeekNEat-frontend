#include "btnHandler.hpp"
#include "textHandler.hpp"
#include <QString>

btnHandler::btnHandler(QObject *parent) : QObject(parent) {}

btnHandler::~btnHandler() {}

void btnHandler::handleLoginBtn() {
    std::string result = conn.login(textHandler::username, textHandler::pwd);

    if(result == "login successful") authCtl->setText("Successfully logged in");
    else if(result == "invalid response") authCtl->setText("Error: Invalid Server Response");
    else if(result == "token error") authCtl->setText("Error: Could not save session");
    else authCtl->setText(result.c_str());
}

void btnHandler::handleRegisterBtn() {
    std::string result = conn.signup(textHandler::email, textHandler::username, textHandler::pwd);

    if(result == "signup successful") authCtl->setText("Successfully signed up");
    else if(result == "invalid response") authCtl->setText("Error: Invalid Server Response");
    else authCtl->setText(result.c_str());
}

void btnHandler::handleLogoutBtn() {
    conn.logout();
}

void btnHandler::handleUserEditBtn(){
    std::string result = conn.changeUser(textHandler::newEmail, textHandler::newUsername, textHandler::newPwd);

    if(result == "successfully changed user") editCtl->setText("Successfully edited user");
    else if(result == "invalid response") editCtl->setText("Error: Invalid Server Response");
    else editCtl->setText(result.c_str());
}

void btnHandler::handleSubmitMeal()
{
    Meal m {
        .name = textHandler::mealName,
        .desc = textHandler::mealDesc,
        .price = textHandler::mealCost,
        .timestamp = std::stoll(textHandler::mealTime.c_str()),
        .availSpots = std::atoi(textHandler::mealSeats.c_str()),
        .latitude = std::stod(textHandler::mealLatitude.c_str()),
        .longitude = std::stod(textHandler::mealLongitude.c_str())
    };

    conn.createMeal(m);
}
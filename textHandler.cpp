#include "textHandler.hpp"

textHandler::textHandler(QObject *parent) : QObject(parent) {}

textHandler::~textHandler() {}

void textHandler::processUsername(const QString &input) { username = input.toStdString(); }
void textHandler::processEmail(const QString &input) { email = input.toStdString(); }
void textHandler::processPwd(const QString &input) { pwd = input.toStdString(); }

void textHandler::processNewUsername(const QString &input) { newUsername = input.toStdString(); }
void textHandler::processNewEmail(const QString &input) { newEmail = input.toStdString(); }
void textHandler::processNewPwd(const QString &input) { newPwd = input.toStdString(); }

void textHandler::processMealName(const QString &input) { mealName = input.toStdString(); }
void textHandler::processMealDesc(const QString &input) { mealDesc = input.toStdString(); }
void textHandler::processMealCost(const QString &input) { mealCost = input.toStdString(); }
void textHandler::processMealSeats(const QString &input) { mealSeats = input.toStdString(); }
void textHandler::processMealTime(const QString &input) { mealTime = input.toStdString(); }
void textHandler::processMealLatitude(const QString &input) { mealLatitude = input.toStdString(); }
void textHandler::processMealLongitude(const QString &input) { mealLongitude = input.toStdString(); }
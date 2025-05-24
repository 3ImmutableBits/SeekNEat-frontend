#include "textHandler.hpp"

textHandler::textHandler(QObject *parent) : QObject(parent) {}

textHandler::~textHandler() {}

void textHandler::processUsername(const QString &input) { username = input.toStdString(); }
void textHandler::processEmail(const QString &input) { email = input.toStdString(); }
void textHandler::processPwd(const QString &input) { pwd = input.toStdString(); }

void textHandler::processNewUsername(const QString &input) { newUsername = input.toStdString(); }
void textHandler::processNewEmail(const QString &input) { newEmail = input.toStdString(); }
void textHandler::processNewPwd(const QString &input) { newPwd = input.toStdString(); }
#include "textController.hpp"

textController::textController(QObject* parent) : QObject(parent), m_text("") {}

QString textController::text() const {
    return m_text;
}

void textController::setText(const QString& newText)
{
    if(m_text == newText) return;
    m_text = newText;
    emit textChanged();
}
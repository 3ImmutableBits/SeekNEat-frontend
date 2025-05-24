#ifndef TEXTCONTROLLER_HPP
#define TEXTCONTROLLER_HPP

#include <QString>
#include <QObject>

class textController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

    private:
        QString m_text;

    public:
        explicit textController(QObject* parent = nullptr);

        QString text() const;
        void setText(const QString& newText);
    
    signals:
        void textChanged();
};

#endif
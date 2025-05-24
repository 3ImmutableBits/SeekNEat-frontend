#ifndef TEXTHANDLER_HPP
#define TEXTHANDLER_HPP

#include <QObject>
#include <QString>

class textHandler : public QObject {
    Q_OBJECT

public:
    // auth
    static inline std::string username;
    static inline std::string pwd;
    static inline std::string email;

    // edit
    static inline std::string newUsername;
    static inline std::string newEmail;
    static inline std::string newPwd;

    // create meal
    static inline std::string mealName;
    static inline std::string mealDesc;
    static inline std::string mealCost;
    static inline std::string mealSeats;
    static inline std::string mealTime;
    static inline std::string mealLatitude;
    static inline std::string mealLongitude;

    static inline QString authResult;
    static inline QString editResult;

public:
    explicit textHandler(QObject *parent = nullptr);
    ~textHandler();

public slots:
    void processUsername(const QString &input);
    void processPwd(const QString &input);
    void processEmail(const QString &input);

    void processNewUsername(const QString &input);
    void processNewPwd(const QString &input);
    void processNewEmail(const QString &input);

    void processMealName(const QString &input);
    void processMealDesc(const QString &input);
    void processMealCost(const QString &input);
    void processMealSeats(const QString &input);
    void processMealTime(const QString &input);

    void processMealLatitude(const QString &input);
    void processMealLongitude(const QString &input);
};
#endif
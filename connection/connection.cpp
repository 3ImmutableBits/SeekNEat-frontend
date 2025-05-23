#include "connection.hpp"
#include "debug.hpp"

#include <curl/curl.h>
#include <QJsonObject>
#include <qt6keychain/keychain.h>

size_t WriteCallback(void *contents, size_t size, size_t nmemb, std::string *output) {
    size_t totalSize = size * nmemb;
    output->append((char*)contents, totalSize);
    return totalSize;
}

bool SNEconnection::init()
{
    // init curl
    curl = curl_easy_init();
    if(!curl) return 1;

    // retrieve saved token
    QKeychain::ReadPasswordJob* job = new QKeychain::ReadPasswordJob("SeekNEat");
    job->setKey("session_token");
    QObject::connect(job, &QKeychain::Job::finished, [job]() {
        if (job->error()) {
            SNEdebug(3, "Error retrieving token: " + job->errorString().toStdString());
        }
        else {
            QString token = job->textData();
            SNEdebug(1, "Retrieved token:" + token.toStdString());
        }
        job->deleteLater(); // Clean up
    });
    job->start();
    tkn = job->textData().toStdString();

    return 0;
}

void SNEconnection::cleanup()
{
    curl_easy_cleanup(curl);
}

std::string SNEconnection::login(std::string username, std::string pwd)
{
    std::string serverResponse;

    QJsonObject json;
    json.insert("username", QJsonValue::fromVariant(username.c_str()));
    json.insert("password", QJsonValue::fromVariant(pwd.c_str()));

    QJsonDocument doc(json);
    std::string jsonStr = doc.toJson(QJsonDocument::Compact).toStdString();

    curl_easy_setopt(curl, CURLOPT_URL, LOGIN_ENDPOINT);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, jsonStr.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &serverResponse);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) return curl_easy_strerror(res);
    else SNEdebug(1, serverResponse);

    // handle response
    QJsonDocument response = QJsonDocument::fromJson(serverResponse.c_str());
    if(!response.isObject()) return "invalid response";

    QJsonObject obj = response.object();

    std::string error = obj.value("error").toString().toStdString();
    bool success = obj.value("success").toBool();
    if(!success) return error;

    // save token
    tkn = obj.value("token").toString().toStdString();
    QKeychain::WritePasswordJob* tokenJob = new QKeychain::WritePasswordJob("SeekNEat");
    tokenJob->setKey("session_token");
    tokenJob->setTextData(QString::fromStdString(tkn));
    QObject::connect(tokenJob, &QKeychain::Job::finished, [tokenJob]() {
        if (tokenJob->error()) {
            SNEdebug(3, "Error Saving Token: " + tokenJob->errorString().toStdString());
        } else {
            SNEdebug(1, "Token stored successfully!");
        }
        tokenJob->deleteLater(); // Clean up
    });
    tokenJob->start();

    SNEdebug(1, tkn);

    return "login successful";
}

std::string SNEconnection::signup(std::string email, std::string username, std::string pwd)
{  
    std::string serverResponse;

    QJsonObject json;
    json.insert("email", QJsonValue::fromVariant(email.c_str()));
    json.insert("username", QJsonValue::fromVariant(username.c_str()));
    json.insert("password", QJsonValue::fromVariant(pwd.c_str()));

    QJsonDocument doc(json);
    std::string jsonStr = doc.toJson(QJsonDocument::Compact).toStdString();

    curl_easy_setopt(curl, CURLOPT_URL, SIGNUP_ENDPOINT);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, jsonStr.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &serverResponse);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) return curl_easy_strerror(res);
    else SNEdebug(1, serverResponse);

    // handle response
    QJsonDocument response = QJsonDocument::fromJson(serverResponse.c_str());
    if(!response.isObject()) return "invalid response";

    QJsonObject obj = response.object();

    std::string error = obj.value("error").toString().toStdString();
    bool success = obj.value("success").toBool();
    if(!success) return error;

    return "signup successful";
}
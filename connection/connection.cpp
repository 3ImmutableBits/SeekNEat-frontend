#include "connection.hpp"
#include "debug.hpp"

#include <curl/curl.h>
#include <QJsonObject>
#include <QJsonArray>
#include <qt6keychain/keychain.h>

#include <qeventloop.h>

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

    QEventLoop loop;
    QObject::connect(job, &QKeychain::Job::finished, &loop, &QEventLoop::quit);
    job->start();
    loop.exec();

    if (job->error()) {
        SNEdebug(3, "Error retrieving token: " + job->errorString().toStdString());
    } else {
        tkn = job->textData().toStdString();
        SNEdebug(1, "Retrieved token: " + tkn);
    }

    job->deleteLater();

    // TOKEN VALIDATION
    std::string serverResponse;

    struct curl_slist *hList = NULL;
    const std::string header = "Authorization: Bearer " + tkn;
    hList = curl_slist_append(hList, header.data());
    hList = curl_slist_append(hList, "Content-Type: application/json");

    curl_easy_setopt(curl, CURLOPT_URL, CHANGEUSER_ENDPOINT);
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, hList);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &serverResponse);

    res = curl_easy_perform(curl);
    curl_slist_free_all(hList);
    if(res != CURLE_OK) { SNEdebug(3, curl_easy_strerror(res)); return 1; }
    else SNEdebug(1, serverResponse);

    // handle response
    QJsonDocument response = QJsonDocument::fromJson(serverResponse.c_str());
    if(!response.isObject()) { SNEdebug(3, "invalid response"); return 1; }

    QJsonObject obj = response.object();

    std::string error = obj.value("error").toString().toStdString();
    bool success = obj.value("success").toBool();
    if(!success) { SNEdebug(3, error); return 1; }
    else loggedIn = true;

    return 0;
}

SNEconnection::~SNEconnection() { curl_easy_cleanup(curl); }

bool SNEconnection::isLogged() const { return loggedIn; }

std::string SNEconnection::login(std::string username, std::string pwd)
{
    std::string serverResponse;

    QJsonObject json;
    json.insert("username", QJsonValue::fromVariant(username.c_str()));
    json.insert("password", QJsonValue::fromVariant(pwd.c_str()));

    QJsonDocument doc(json);
    std::string jsonStr = doc.toJson(QJsonDocument::Compact).toStdString();

    // headers
    struct curl_slist *hList = NULL;
    hList = curl_slist_append(hList, "Content-Type: application/json");

    curl_easy_setopt(curl, CURLOPT_URL, LOGIN_ENDPOINT);
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, hList);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, jsonStr.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &serverResponse);

    res = curl_easy_perform(curl);
    curl_slist_free_all(hList);
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

    QEventLoop loop;
    QObject::connect(tokenJob, &QKeychain::Job::finished, &loop, &QEventLoop::quit);
    tokenJob->start();
    loop.exec();

    if (tokenJob->error()) {
        SNEdebug(3, "Error Saving Token: " + tokenJob->errorString().toStdString());
        return "token error";
    }
    else {
        SNEdebug(1, "Token stored successfully!");
    }
    tokenJob->deleteLater(); // cleanup

    loggedIn = true;

    SNEdebug(1, tkn);

    return "login successful";
}

std::string SNEconnection::logout()
{
    QKeychain::DeletePasswordJob* job = new QKeychain::DeletePasswordJob("SeekNEat");
    job->setKey("session_token");

    QEventLoop loop;
    QObject::connect(job, &QKeychain::DeletePasswordJob::finished, &loop, &QEventLoop::quit);
    job->start();
    loop.exec();

    if (job->error()) {
        SNEdebug(3, "Error deleting password: " + job->errorString().toStdString());
    }
    else {
        SNEdebug(1, "Password deleted successfully!");
    }

    job->deleteLater(); // cleanup

    loggedIn = false;
    

    return "successfully logged out";
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

    // headers
    struct curl_slist *hList = NULL;
    hList = curl_slist_append(hList, "Content-Type: application/json");

    curl_easy_setopt(curl, CURLOPT_URL, SIGNUP_ENDPOINT);
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, hList);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, jsonStr.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &serverResponse);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) return curl_easy_strerror(res);
    else SNEdebug(1, serverResponse);
    curl_slist_free_all(hList);

    // handle response
    QJsonDocument response = QJsonDocument::fromJson(serverResponse.c_str());
    if(!response.isObject()) return "invalid response";

    SNEdebug(1, serverResponse);

    QJsonObject obj = response.object();

    std::string error = obj.value("error").toString().toStdString();
    bool success = obj.value("success").toBool();
    if(!success) return error;

    return "signup successful";
}

std::string SNEconnection::changeUser(std::string email, std::string username, std::string pwd)
{
    std::string serverResponse;

    QJsonObject json;
    json.insert("email", QJsonValue::fromVariant(email.c_str()));
    json.insert("username", QJsonValue::fromVariant(username.c_str()));
    json.insert("password", QJsonValue::fromVariant(pwd.c_str()));

    QJsonDocument doc(json);
    std::string jsonStr = doc.toJson(QJsonDocument::Compact).toStdString();

    // headers
    SNEdebug(1, tkn);
    struct curl_slist *hList = NULL;
    const std::string header = "Authorization: Bearer " + tkn;
    hList = curl_slist_append(hList, header.data());
    hList = curl_slist_append(hList, "Content-Type: application/json");

    curl_easy_setopt(curl, CURLOPT_URL, CHANGEUSER_ENDPOINT);
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, hList);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, jsonStr.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &serverResponse);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) return curl_easy_strerror(res);
    else SNEdebug(1, serverResponse);
    curl_slist_free_all(hList);

    // handle response
    QJsonDocument response = QJsonDocument::fromJson(serverResponse.c_str());
    if(!response.isObject()) return "invalid response";

    SNEdebug(1, serverResponse);

    QJsonObject obj = response.object();

    std::string error = obj.value("error").toString().toStdString();
    bool success = obj.value("success").toBool();
    if(!success) return error;

    return "successfully changed user";
}

std::string SNEconnection::createMeal(Meal m)
{
    std::string serverResponse;

    QJsonObject json;
    json.insert("name", QJsonValue::fromVariant(m.name.c_str()));
    json.insert("description", QJsonValue::fromVariant(m.desc.c_str()));
    json.insert("price", QJsonValue::fromVariant(m.price.c_str()));
    json.insert("timestamp", QJsonValue::fromVariant(m.timestamp));
    json.insert("available_spots", QJsonValue::fromVariant(m.availSpots));
    json.insert("latitude", QJsonValue::fromVariant(m.latitude));
    json.insert("longitude", QJsonValue::fromVariant(m.longitude));

    QJsonDocument doc(json);
    std::string jsonStr = doc.toJson(QJsonDocument::Compact).toStdString();

    // headers
    SNEdebug(1, tkn);
    struct curl_slist *hList = NULL;
    const std::string header = "Authorization: Bearer " + tkn;
    hList = curl_slist_append(hList, header.data());
    hList = curl_slist_append(hList, "Content-Type: application/json");

    curl_easy_setopt(curl, CURLOPT_URL, NEWMEAL_ENDPOINT);
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, hList);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, jsonStr.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &serverResponse);

    res = curl_easy_perform(curl);
    curl_slist_free_all(hList);
    if(res != CURLE_OK) return curl_easy_strerror(res);
    else SNEdebug(1, serverResponse);

    // handle response
    QJsonDocument response = QJsonDocument::fromJson(serverResponse.c_str());
    if(!response.isObject()) return "invalid response";

    QJsonObject obj = response.object();

    std::string error = obj.value("error").toString().toStdString();
    bool success = obj.value("success").toBool();
    if(!success) return error;

    return "successfully created new meal";
}

std::string SNEconnection::deleteMeal(uint32_t id)
{
    std::string serverResponse;

    QJsonObject json;
    json.insert("meal_id", QJsonValue::fromVariant(id));
    
    QJsonDocument doc(json);
    std::string jsonStr = doc.toJson(QJsonDocument::Compact).toStdString();

    // headers
    SNEdebug(1, tkn);
    struct curl_slist *hList = NULL;
    const std::string header = "Authorization: Bearer " + tkn;
    hList = curl_slist_append(hList, header.data());
    hList = curl_slist_append(hList, "Content-Type: application/json");

    curl_easy_setopt(curl, CURLOPT_URL, DELETEMEAL_ENDPOINT);
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, hList);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, jsonStr.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &serverResponse);

    res = curl_easy_perform(curl);
    curl_slist_free_all(hList);
    if(res != CURLE_OK) return curl_easy_strerror(res);
    else SNEdebug(1, serverResponse);

    // handle response
    QJsonDocument response = QJsonDocument::fromJson(serverResponse.c_str());
    if(!response.isObject()) return "invalid response";

    QJsonObject obj = response.object();

    std::string error = obj.value("error").toString().toStdString();
    bool success = obj.value("success").toBool();
    if(!success) return error;

    return "successfully deleted meal";
}

std::string SNEconnection::joinMeal(uint32_t id)
{
    std::string serverResponse;

    QJsonObject json;
    json.insert("meal_id", QJsonValue::fromVariant(id));
    
    QJsonDocument doc(json);
    std::string jsonStr = doc.toJson(QJsonDocument::Compact).toStdString();

    // headers
    SNEdebug(1, tkn);
    struct curl_slist *hList = NULL;
    const std::string header = "Authorization: Bearer " + tkn;
    hList = curl_slist_append(hList, header.data());
    hList = curl_slist_append(hList, "Content-Type: application/json");

    curl_easy_setopt(curl, CURLOPT_URL, JOINMEAL_ENDPOINT);
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, hList);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, jsonStr.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &serverResponse);

    res = curl_easy_perform(curl);
    curl_slist_free_all(hList);
    if(res != CURLE_OK) return curl_easy_strerror(res);
    else SNEdebug(1, serverResponse);

    // handle response
    QJsonDocument response = QJsonDocument::fromJson(serverResponse.c_str());
    if(!response.isObject()) return "invalid response";

    QJsonObject obj = response.object();

    std::string error = obj.value("error").toString().toStdString();
    bool success = obj.value("success").toBool();
    if(!success) return error;

    return "successfully joined meal";
}

std::vector<Meal> SNEconnection::fetchMeals(std::string query)
{
    std::string serverResponse;

    QJsonObject json;
    json.insert("query", QJsonValue::fromVariant(query.c_str()));

    QJsonDocument doc(json);
    std::string jsonStr = doc.toJson(QJsonDocument::Compact).toStdString();

    // headers
    SNEdebug(1, tkn);
    struct curl_slist *hList = NULL;
    const std::string header = "Authorization: Bearer " + tkn;
    hList = curl_slist_append(hList, header.data());
    hList = curl_slist_append(hList, "Content-Type: application/json");

    curl_easy_setopt(curl, CURLOPT_URL, FETCHMEAL_ENDPOINT);
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, hList);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, jsonStr.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &serverResponse);

    res = curl_easy_perform(curl);
    curl_slist_free_all(hList);
    if(res != CURLE_OK) SNEdebug(3, curl_easy_strerror(res));
    else SNEdebug(1, serverResponse);

    // handle response
    QJsonDocument response = QJsonDocument::fromJson(serverResponse.c_str());
    if(!response.isObject()) SNEdebug(3, "invalid response");

    QJsonObject obj = response.object();
    std::string error = obj.value("error").toString().toStdString();
    bool success = obj.value("success").toBool();
    if(!success) SNEdebug(3, error);

    // meal array
    QJsonArray res = obj.value("result").toArray();
    std::vector<Meal> vec;
    for(const QJsonValue &value : res)
    {
        if(value.isObject()) {
            QJsonObject obj = value.toObject();
            Meal meal = {
                .hostID = obj.value("host_id").toInt(),
                .name = obj.value("name").toString().toStdString(),
                .desc = obj.value("description").toString().toStdString(),
                .price = obj.value("price").toString().toStdString(),
                .timestamp = obj.value("timestamp").toInteger(),
                .availSpots = obj.value("spots").toInt(),
                .occupiedSpots = obj.value("name").toInt()
            };
            vec.push_back(meal);
        }
    }

    return vec;
}
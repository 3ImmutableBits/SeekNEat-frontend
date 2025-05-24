#pragma once
#include <string>
#include <curl/curl.h>
#include <stdint.h>
#include <vector>

#define LOGIN_ENDPOINT "http://192.168.97.154:4000/api/login"
#define SIGNUP_ENDPOINT "http://192.168.97.154:4000/api/register"
#define CHANGEUSER_ENDPOINT "http://192.168.97.154:4000/api/change_user"
#define NEWMEAL_ENDPOINT "http://192.168.97.154:4000/api/new_meal"
#define DELETEMEAL_ENDPOINT "http://192.168.97.154:4000/api/delete_meal"
#define JOINMEAL_ENDPOINT "http://192.168.97.154:4000/api/join_meal"
#define FETCHMEAL_ENDPOINT "http://192.168.97.154:4000/api/fetch_meal"

struct Meal {
    int hostID;
    std::string name;
    std::string desc;
    std::string price;
    long long timestamp;
    int availSpots;
    int occupiedSpots;
    double latitude;
    double longitude;
};

class SNEconnection
{
    protected:
        CURL* curl;
        CURLcode res;
        std::string tkn;

    public:
        ~SNEconnection();
    
    public:
        // @brief Initializes the connection
        bool init();

        // @brief Sends account credentials to the server
        std::string login(std::string username, std::string pwd);

        // @brief Logs out the account and deletes the token keychain
        std::string logout();

        // @brief Sends credentials to the server and creates an account
        std::string signup(std::string email, std::string username, std::string pwd);

        // @brief Updates your credentials
        std::string changeUser(std::string email, std::string username, std::string pwd);

        // @brief Creates a new meal
        std::string createMeal(Meal m);

        // @brief Deletes a meal
        std::string deleteMeal(uint32_t id);

        // @brief Joins another user's meal
        std::string joinMeal(uint32_t id);

        // @brief Fetches all meals from the server
        std::vector<Meal> fetchMeals(std::string query);
    
}; // class SNEconnection

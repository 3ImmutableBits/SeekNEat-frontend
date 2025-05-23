#pragma once
#include <string>
#include <curl/curl.h>

#define LOGIN_ENDPOINT "http://192.168.97.154:4000/api/login"
#define SIGNUP_ENDPOINT "http://192.168.97.154:4000/api/register"

class SNEconnection
{
    protected:
        CURL* curl;
        CURLcode res;
        std::string tkn;
    
    public:
        // @brief Initializes the connection
        // @returns result
        bool init();

        // @brief Closes the connection, should be run upon app close
        void cleanup();

        // @brief Sends account credentials to the server
        // @returns JSON result data
        std::string login(std::string username, std::string pwd);

        // @brief Sends credentials to the server and creates an account
        // @returns JSON result data
        std::string signup(std::string email, std::string username, std::string pwd);
    
}; // class SNEconnection

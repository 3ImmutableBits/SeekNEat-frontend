#pragma once

#define DEBUG_MODE 1

#include <iostream>
#include <stdint.h>

// @brief 1 = information 2 = warning 3 = error
static void SNEdebug(uint8_t type, std::string s)
{
    if(!DEBUG_MODE) return;

    std::string res;
    switch (type)
    {
        case 1:
            res = "[INFO]: ";
            break;
        
        case 2:
            res = "[WARN]: ";
            break;

        case 3:
            res = "[ERR]: ";
            break;
        
        default:
            res = "[DEBUG]: ";
            break;
    }
    res += s; std::cout << res << '\n';
    return;
}
// Simple hex utilities for safe SQL literal construction of binary data
#ifndef LLOEGRYS_DBUTILS_H
#define LLOEGRYS_DBUTILS_H

#include <string>

inline std::string binToHex(const unsigned char* data, size_t len)
{
    static const char hexDigits[] = "0123456789ABCDEF";
    std::string out;
    out.reserve(len * 2);
    for (size_t i = 0; i < len; ++i) {
        unsigned char c = data[i];
        out.push_back(hexDigits[c >> 4]);
        out.push_back(hexDigits[c & 0x0F]);
    }
    return out;
}

#endif // LLOEGRYS_DBUTILS_H


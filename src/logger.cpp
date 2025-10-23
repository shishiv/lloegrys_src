#include "otpch.h"

#include "logger.h"

#include <cstdio>
#include <ctime>
#include <thread>
#include <sstream>
#include <fstream>
#include <sys/stat.h>

#ifdef _WIN32
#include <direct.h>
#endif

Logger& Logger::get() {
    static Logger instance;
    return instance;
}

void Logger::init(const std::string& filePath, bool alsoConsole) {
    std::lock_guard<std::mutex> lock(mtx_);
    filePath_ = filePath;
    console_ = alsoConsole;
    ensureLogDir(filePath_);
    initialized_ = true;
    info(std::string("Logger initialized. file=") + filePath_);
}

void Logger::setLevel(LogLevel lvl) {
    std::lock_guard<std::mutex> lock(mtx_);
    level_ = lvl;
}

LogLevel Logger::level() const { return level_; }

void Logger::debug(const std::string& msg) { log(LogLevel::Debug, msg); }
void Logger::info(const std::string& msg)  { log(LogLevel::Info, msg); }
void Logger::warn(const std::string& msg)  { log(LogLevel::Warn, msg); }
void Logger::error(const std::string& msg) { log(LogLevel::Error, msg); }

void Logger::log(LogLevel lvl, const std::string& msg) {
    if (static_cast<int>(lvl) < static_cast<int>(level_)) {
        return;
    }
    const auto ts = timestampNow();
    const auto tid = threadIdString();
    const auto lvlStr = levelToString(lvl);
    const std::string line = ts + " [" + tid + "] " + lvlStr + ": " + msg + "\n";

    {
        std::lock_guard<std::mutex> lock(mtx_);
        // ring buffer
        ring_.push_back({std::chrono::system_clock::now(), lvl, tid, msg});
        if (ring_.size() > ringMax_) {
            ring_.pop_front();
        }

        // console sink
        if (console_) {
            if (lvl == LogLevel::Error || lvl == LogLevel::Warn) {
                fputs(line.c_str(), stderr);
            } else {
                fputs(line.c_str(), stdout);
            }
        }

        // file sink
        if (initialized_ && !filePath_.empty()) {
            std::ofstream ofs(filePath_, std::ios::app | std::ios::out);
            if (ofs.is_open()) {
                ofs << line;
            }
        }
    }
}

void Logger::dumpRecent(size_t maxCount) {
    std::lock_guard<std::mutex> lock(mtx_);
    size_t count = ring_.size();
    if (maxCount > 0 && count > maxCount) {
        count = maxCount;
    }
    const size_t start = ring_.size() - count;
    std::ofstream ofs(filePath_, std::ios::app | std::ios::out);
    if (ofs.is_open()) {
        ofs << timestampNow() << " [" << threadIdString() << "] INFO: Dumping last " << count << " log records:" << '\n';
        for (size_t i = start; i < ring_.size(); ++i) {
            const auto& rec = ring_[i];
            ofs << timestampNow() << " [" << rec.thread << "] " << levelToString(rec.level) << ": " << rec.msg << '\n';
        }
    }
}

std::string Logger::levelToString(LogLevel lvl) const {
    switch (lvl) {
        case LogLevel::Debug: return "DEBUG";
        case LogLevel::Info:  return "INFO";
        case LogLevel::Warn:  return "WARN";
        case LogLevel::Error: return "ERROR";
    }
    return "INFO";
}

std::string Logger::timestampNow() const {
    using namespace std::chrono;
    const auto now = system_clock::now();
    const auto t = system_clock::to_time_t(now);
    std::tm tm{};
#ifdef _WIN32
    localtime_s(&tm, &t);
#else
    localtime_r(&t, &tm);
#endif
<<<<<<< HEAD
    char buf[32] = {0};
    if (std::strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", &tm) == 0) {
        return "0000-00-00 00:00:00";
    }
    return std::string(buf);
=======
    char buf[32];
    std::snprintf(buf, sizeof(buf), "%04d-%02d-%02d %02d:%02d:%02d",
                  tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
                  tm.tm_hour, tm.tm_min, tm.tm_sec);
    return buf;
>>>>>>> d76db372a036ed363197c86a9b9aa1b41f554373
}

std::string Logger::threadIdString() const {
    std::ostringstream oss;
    oss << std::this_thread::get_id();
    return oss.str();
}

void Logger::ensureLogDir(const std::string& path) {
    // crude: ensure parent directory exists if path contains '/'
    const auto pos = path.find_last_of("/\\");
    if (pos == std::string::npos) return;
    const std::string dir = path.substr(0, pos);
    if (dir.empty()) return;

#ifdef _WIN32
    _mkdir(dir.c_str());
#else
    mkdir(dir.c_str(), 0755);
#endif
}


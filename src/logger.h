// Minimal thread-safe logger with file + console sinks and ring buffer
#pragma once

#include <string>
#include <mutex>
#include <deque>
#include <chrono>

enum class LogLevel { Debug = 0, Info, Warn, Error };

struct LogRecord {
    std::chrono::system_clock::time_point ts;
    LogLevel level;
    std::string thread;
    std::string msg;
};

class Logger {
public:
    static Logger& get();

    void init(const std::string& filePath, bool alsoConsole = true);
    void setLevel(LogLevel lvl);
    LogLevel level() const;

    void debug(const std::string& msg);
    void info(const std::string& msg);
    void warn(const std::string& msg);
    void error(const std::string& msg);

    // Dumps recent buffered records to current sinks (useful on crash)
    void dumpRecent(size_t maxCount = 0);

private:
    void log(LogLevel lvl, const std::string& msg);
    std::string levelToString(LogLevel lvl) const;
    std::string timestampNow() const;
    std::string threadIdString() const;
    void ensureLogDir(const std::string& path);

    std::mutex mtx_;
    std::string filePath_;
    bool console_ = true;
    LogLevel level_ = LogLevel::Info;
    std::deque<LogRecord> ring_;
    size_t ringMax_ = 1000;
    bool initialized_ = false;
};

// Convenience macros (compiled out for Debug below threshold)
#define LOG_DEBUG(msg) Logger::get().debug(msg)
#define LOG_INFO(msg)  Logger::get().info(msg)
#define LOG_WARN(msg)  Logger::get().warn(msg)
#define LOG_ERROR(msg) Logger::get().error(msg)


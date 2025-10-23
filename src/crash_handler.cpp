#include "otpch.h"

#include "crash_handler.h"
#include "logger.h"

#include <csignal>
#include <cstdlib>
#include <exception>

#ifndef _WIN32
#include <execinfo.h>
#endif

namespace {
    void logStacktrace() {
#ifndef _WIN32
        void* buffer[64];
        int nptrs = backtrace(buffer, 64);
        char** strings = backtrace_symbols(buffer, nptrs);
        if (strings) {
            LOG_ERROR("=== Stacktrace (most recent call first) ===");
            for (int i = 0; i < nptrs; ++i) {
                LOG_ERROR(strings[i]);
            }
        } else {
            LOG_ERROR("Stacktrace unavailable (backtrace_symbols returned null)");
        }
#else
        LOG_ERROR("Stacktrace not implemented on Windows build");
#endif
        Logger::get().dumpRecent(200);
    }

    void signalHandler(int sig) {
        LOG_ERROR(std::string("Fatal signal received: ") + std::to_string(sig));
        logStacktrace();
        std::_Exit(EXIT_FAILURE);
    }

    void terminateHandler() {
        if (auto exc = std::current_exception()) {
            try {
                std::rethrow_exception(exc);
            } catch (const std::exception& e) {
                LOG_ERROR(std::string("Unhandled exception: ") + e.what());
            } catch (...) {
                LOG_ERROR("Unhandled unknown exception");
            }
        } else {
            LOG_ERROR("std::terminate called without active exception");
        }
        logStacktrace();
        std::_Exit(EXIT_FAILURE);
    }
}

void CrashHandler::install() {
    std::set_terminate(terminateHandler);
#ifndef _WIN32
    signal(SIGSEGV, signalHandler);
    signal(SIGABRT, signalHandler);
    signal(SIGFPE,  signalHandler);
    signal(SIGILL,  signalHandler);
    signal(SIGBUS,  signalHandler);
#endif
    LOG_INFO("CrashHandler installed");
}


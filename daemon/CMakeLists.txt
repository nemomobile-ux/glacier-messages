set(SRC main.cpp
    messageshandler.cpp)

set(HEADERS messageshandler.h)

add_executable(messagesd ${SRC} ${HEADERS})

target_link_libraries(messagesd
        Qt6::Core
        Qt6::DBus
        PkgConfig::QOFONO
        PkgConfig::NEMONOTIFICATIONS
        PkgConfig::COMMHISTORY)

install(TARGETS messagesd RUNTIME
        DESTINATION ${CMAKE_INSTALL_BINDIR})

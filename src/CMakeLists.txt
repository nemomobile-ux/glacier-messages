set(SRC 
    main.cpp
)

qt_add_resources(RESOURCES qml/glacier-messages.qrc)

add_executable(glacier-messages ${SRC} ${RESOURCES})

target_link_libraries(glacier-messages
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::DBus
	Glacier::App)

install(TARGETS glacier-messages RUNTIME
	DESTINATION ${CMAKE_INSTALL_BINDIR})

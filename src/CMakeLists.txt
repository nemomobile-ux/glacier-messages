set(SRC 
    main.cpp
)

add_executable(glacier-messages ${SRC})

target_link_libraries(glacier-messages
	Qt5::Gui
	Qt5::Qml
	Qt5::Quick
	Qt5::DBus
	Glacier::App)

install(TARGETS glacier-messages RUNTIME
	DESTINATION ${CMAKE_INSTALL_BINDIR})

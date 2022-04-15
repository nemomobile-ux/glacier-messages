set(SRC 
    main.cpp
)

qtquick_compiler_add_resources(RESOURCES qml/glacier-messages.qrc)

add_executable(glacier-messages ${SRC} ${RESOURCES})

target_link_libraries(glacier-messages
	Qt5::Gui
	Qt5::Qml
	Qt5::Quick
	Qt5::DBus
	Glacier::App)

install(TARGETS glacier-messages RUNTIME
	DESTINATION ${CMAKE_INSTALL_BINDIR})

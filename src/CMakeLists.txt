set(SRC 
    main.cpp
)

if(!QML_DEBUG)
qt_add_resources(RESOURCES qml/glacier-messages.qrc)
endif()

add_executable(glacier-messages ${SRC} ${RESOURCES})

target_link_libraries(glacier-messages
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::DBus
	Glacier::App)

install(TARGETS glacier-messages RUNTIME
	DESTINATION ${CMAKE_INSTALL_BINDIR})

if(QML_DEBUG)
install(DIRECTORY qml
        DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-messages)
endif()

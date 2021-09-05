cmake_minimum_required(VERSION 3.6.0)

project(glacier-messages
	VERSION 0.1.2
	DESCRIPTION "The Glacier messages")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

include(FeatureSummary)
include(GNUInstallDirs)

set(QT_MIN_VERSION "5.6.0")
find_package(Qt5 COMPONENTS Gui Qml Quick DBus LinguistTools REQUIRED)
find_package(Glacier COMPONENTS App REQUIRED)

add_subdirectory(src)

# Translations
file(GLOB TS_FILES translations/*.ts)
qt5_add_translation(QM_FILES ${TS_FILES})
add_custom_target(translations DEPENDS ${QM_FILES})
add_dependencies(glacier-messages translations)

install(FILES ${QM_FILES}
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-messages/translations)

install(FILES data/glacier-messages.desktop
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications)

install(FILES res/glacier-messages.png
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-messages)


file(GLOB SVG_FILES res/*.svg)
install(FILES ${SVG_FILES}
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-messages/images)

install(DIRECTORY qml
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-messages)

install(FILES
	data/org.freedesktop.Telepathy.Client.qmlmessages.service
	data/org.nemomobile.qmlmessages.service
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/dbus-1/services)

install(FILES
	data/glacier-messages.client
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/telepathy/clients)


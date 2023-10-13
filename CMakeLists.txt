cmake_minimum_required(VERSION 3.6.0)

project(glacier-messages
        VERSION 0.3
	DESCRIPTION "The Glacier messages")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_INSTALL_PREFIX /usr)

include(FeatureSummary)
include(GNUInstallDirs)

option(QML_DEBUG "Don't pack QML into binary for debug and develop" OFF)

set(QT_MIN_VERSION "6.0.0")
find_package(Qt6 COMPONENTS Gui Qml Quick DBus LinguistTools REQUIRED)
find_package(Glacier 1.0 COMPONENTS App REQUIRED)

add_subdirectory(src)

# Translations
file(GLOB TS_FILES translations/*.ts)
qt6_add_translation(QM_FILES ${TS_FILES})
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

install(FILES
	data/org.nemomobile.qmlmessages.service
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/dbus-1/services)

install(FILES
	data/glacier-messages.service
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/systemd/user/)

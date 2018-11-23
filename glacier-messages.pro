PROJECT_NAME = glacier-messages
QT += dbus quick

target.path = $$INSTALL_ROOT/usr/bin
INSTALLS += target

SOURCES += src/main.cpp

TEMPLATE = app
TARGET = $$PROJECT_NAME

CONFIG += link_pkgconfig
PKGCONFIG += glacierapp

LIBS += -lglacierapp

DISTFILES += \
    rpm/glacier-messages.spec \
    qml/common/CommHistoryService.qml \
    qml/common/MessagesService.qml \
    qml/ChatTextInput.qml \
    qml/ConversationListDelegate.qml \
    qml/ConversationListPage.qml \
    qml/ConversationListWidget.qml \
    qml/ConversationPage.qml \
    qml/MessagesView.qml \
    qml/PageHeader.qml \
    qml/TargetEditBox.qml \
    data/glacier-messages.desktop \
    data/org.nemomobile.qmlmessages.service \
    data/org.freedesktop.Telepathy.Client.qmlmessages.service \
    data/glacier-messages.client \
    qml/glacier-messages.qml \
    res/outgoing.svg \
    res/meegotouch-speechbubble.svg \
    res/incoming.svg \
    res/glacier-messages.png

icon.files = res/glacier-messages.png
icon.path = /usr/share/$${PROJECT_NAME}
INSTALLS += icon

images.path = /usr/share/$${PROJECT_NAME}/images
images.files = res/*.svg

desktop.path = $${INSTALL_ROOT}/usr/share/applications
desktop.files = data/glacier-messages.desktop

client.path = $${INSTALL_ROOT}/usr/share/telepathy/clients
client.files = data/glacier-messages.client

service.path = $${INSTALL_ROOT}/usr/share/dbus-1/services
service.files = data/org.freedesktop.Telepathy.Client.qmlmessages.service \
                data/org.nemomobile.qmlmessages.service

INSTALLS += desktop client service images

qml.files = qml/*.qml
qml.path = /usr/share/$${PROJECT_NAME}/qml

qml_common.files = qml/common/*.qml
qml_common.path = /usr/share/$${PROJECT_NAME}/qml/common

INSTALLS += qml qml_common

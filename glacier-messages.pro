TARGET = glacier-messages
QT += dbus quick

SOURCES += src/main.cpp

CONFIG += link_pkgconfig
PKGCONFIG += glacierapp
LIBS += -lglacierapp

target.path = /usr/bin

icon.files = res/glacier-messages.png
icon.path = /usr/share/$$TARGET

images.path = /usr/share/$$TARGET/images
images.files = res/*.svg

desktop.path = /usr/share/applications
desktop.files = data/glacier-messages.desktop

client.path = /usr/share/telepathy/clients
client.files = data/glacier-messages.client

service.path = /usr/share/dbus-1/services
service.files = data/org.freedesktop.Telepathy.Client.qmlmessages.service \
                data/org.nemomobile.qmlmessages.service



qml.files = qml/
qml.path = /usr/share/$$TARGET/

INSTALLS += desktop client service images qml icon target


DISTFILES += \
    rpm/glacier-messages.spec \
    qml/components/CommHistoryService.qml \
    qml/components/MessagesService.qml \
    qml/components/ChatTextInput.qml \
    qml/components/ConversationListDelegate.qml \
    qml/pages/ConversationListPage.qml \
    qml/components/ConversationListWidget.qml \
    qml/pages/ConversationPage.qml \
    qml/components/MessagesView.qml \
    qml/components/PageHeader.qml \
    qml/components/TargetEditBox.qml \
    data/glacier-messages.desktop \
    data/org.nemomobile.qmlmessages.service \
    data/org.freedesktop.Telepathy.Client.qmlmessages.service \
    data/glacier-messages.client \
    qml/glacier-messages.qml \
    res/outgoing.svg \
    res/meegotouch-speechbubble.svg \
    res/incoming.svg \
    res/glacier-messages.png

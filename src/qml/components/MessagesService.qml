import QtQuick 2.6
import Nemo.DBus 2.0

Item {
    id: rootObject
    signal startConversation(string localUid, string remoteUid, bool show)

    DBusAdaptor {
        service: "org.nemomobile.qmlmessages"
        path: "/"
        iface: "org.nemomobile.qmlmessages"

        xml: '  <interface name="org.nemomobile.qmlmessages">\n' +
             '    <method name="startConversation" />\n' +
             '        <arg name="localUid" type="s" direction="in"/>\n' +
             '        <arg name="remoteUid" type="s" direction="in"/>\n' +
             '        <arg name="show" type="b" direction="in"/>\n' +
             '    </method>\n' +
             '  </interface>\n'

        function startConversation(localUid, remoteUid, show) {
            console.log("DEBUG " + localUid + " " + remoteUid + " " + show)
            rootObject.startConversation(localUid, remoteUid, show)
        }
    }
}


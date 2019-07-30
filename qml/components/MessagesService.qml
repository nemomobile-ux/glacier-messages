import QtQuick 2.6
import org.nemomobile.dbus 2.0

Item {
    id: rootObject
    signal startConversation(string localUid,  string remoteUid)

    DBusAdaptor {
        service: "org.nemomobile.qmlmessages"
        path: "/"
        iface: "org.nemomobile.qmlmessages"

        xml: '  <interface name="org.nemomobile.qmlmessages">\n' +
             '    <method name="startConversation" />\n' +
             '        <arg name="localUid" type="s" direction="in"/>\n' +
             '        <arg name="remoteUid" type="s" direction="in"/>\n' +
             '    </method>\n' +
             '  </interface>\n'

        function startConversation(localUid, remoteUid) {
            rootObject.startConversation(localUid, remoteUid)
        }
    }
}


Name:       glacier-messages

Summary:    Messaging application for nemo
Version:    0.2.0
Release:    1
Group:      Applications/System
License:    BSD
URL:        https://github.com/nemomobile-ux/glacier-messages
Source0:    %{name}-%{version}.tar.bz2

Requires:   qt-components-qt5
Requires:   nemo-qml-plugin-messages-internal-qt5
Requires:   libcommhistory-qt5-declarative
Requires:   commhistory-daemon
Requires:   qt5-qtsvg-plugin-imageformat-svg
Requires:   nemo-qml-plugin-contacts-qt5
Requires:   nemo-qml-plugin-dbus-qt5
Requires:   glacier-contacts
Requires:   voicecall-qt5
BuildRequires:  pkgconfig(Qt5Gui)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Contacts)
BuildRequires:  pkgconfig(Qt5DBus)
BuildRequires:  pkgconfig(qdeclarative5-boostable)
BuildRequires:  desktop-file-utils
Provides:   meego-handset-sms > 0.1.2
Provides:   meego-handset-sms-branding-upstream > 0.1.2
Provides:   peregrine-components-bridge-common = 1.1.7
Provides:   peregrine-components-layout = 1.1.7
Provides:   peregrine-libs = 1.1.7
Provides:   peregrine-qml-starter = 1.1.7
Provides:   peregrine-tablet-common = 1.1.7
Obsoletes:   meego-handset-sms <= 0.1.2
Obsoletes:   meego-handset-sms-branding-upstream <= 0.1.2
Obsoletes:   peregrine-components-bridge-common < 1.1.7
Obsoletes:   peregrine-components-layout < 1.1.7
Obsoletes:   peregrine-libs < 1.1.7
Obsoletes:   peregrine-qml-starter < 1.1.7
Obsoletes:   peregrine-tablet-common < 1.1.7

%description
Messaging application using Qt Quick for Nemo Mobile.

%prep
%setup -q -n %{name}-%{version}

%build
%qmake5 

make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%qmake5_install

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/glacier-messages
%{_datadir}/glacier-messages/
%{_datadir}/applications/glacier-messages.desktop
%{_datadir}/telepathy/clients/glacier-messages.client
%{_datadir}/dbus-1/services/org.freedesktop.Telepathy.Client.qmlmessages.service
%{_datadir}/dbus-1/services/org.nemomobile.qmlmessages.service

/* Copyright (C) 2018-2023 Chupligin Sergey <neochapay@gmail.com>
 * Copyright (C) 2012 John Brooks <john.brooks@dereferenced.net>
 * Copyright (C) 2011 Robin Burchell <robin+mer@viroteck.net>
 *
 * You may use this file under the terms of the BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *   * Neither the name of Nemo Mobile nor the names of its contributors
 *     may be used to endorse or promote products derived from this
 *     software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <QGuiApplication>
#include <QQuickView>
#include <QtQml>

#include <glacierapp.h>

#include "dbusadaptor.h"

Q_DECL_EXPORT int main(int argc, char** argv)
{
    QGuiApplication* app = GlacierApp::app(argc, argv);
    app->setOrganizationName("NemoMobile");

    QQuickWindow* window = GlacierApp::showWindow();
    window->setTitle(QObject::tr("Messages"));
    window->setIcon(QIcon("/usr/share/glacier-messages/glacier-messages.png"));

    DBusAdaptor* adaptor = new DBusAdaptor(window);
    return app->exec();
}

# Anki addon for SRS Collector
# Author: Eric Kidd <http://kiddsoftware.com/>
#
# This is free and unencumbered software released into the public domain.
# This program comes with ABSOLUTELY NO WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# For more information, please refer to <http://unlicense.org/>

from config import SERVER
from preferences import Preferences

import urllib
import urllib2
import json

from aqt.qt import *
from aqt import mw
from aqt.utils import showInfo

class SignInDialog(QDialog):
    """A dialog prompting for SRS Collector login credentials."""

    def __init__(self, parent=None):
        super(SignInDialog, self).__init__(parent)
        self.apiKey = None

        layout = QBoxLayout(QBoxLayout.TopToBottom, self)
        layout.addWidget(QLabel("<b>Please sign into SRS Collector</b>"))

        form = QFormLayout()
        self.email = QLineEdit()
        self.email.setMinimumWidth(250)
        form.addRow("&Email", self.email)
        self.password = QLineEdit()
        self.password.setEchoMode(QLineEdit.Password)
        form.addRow("&Password", self.password)
        link = QLabel("<a href='http://www.srscollector.com/sign_up'>Need to create a new account?</a>")
        link.setOpenExternalLinks(True)
        form.addRow("", link)
        layout.addLayout(form)

        buttonFlags = QDialogButtonBox.Ok|QDialogButtonBox.Cancel
        buttons = QDialogButtonBox(buttonFlags, Qt.Horizontal)
        buttons.accepted.connect(self.tryToSignIn)
        buttons.rejected.connect(self.reject)
        layout.addWidget(buttons)

    def tryToSignIn(self):
        """Attempt to sign in using credentials from the dialog."""
        credentials = {
            'user[email]': self.email.text(),
            'user[password]': self.password.text()
        }
        data = urllib.urlencode(credentials)
        url = "{0}api/v1/users/api_key.json".format(SERVER)
        req = urllib2.Request(url, data)
        try:
            resp = urllib2.urlopen(req)
            self.apiKey = json.load(resp)["user"]["api_key"]
            resp.close()
            self.accept()
        except urllib2.HTTPError as e:
            if e.code == 401:
                showInfo("Please check your email and password.")
            else:
                showInfo("Unknown network error.")
        except urllib2.URLError as e:
            # Generally a DNS error.
            showInfo("Network error. Are you online?")

    @staticmethod
    def signInIfNecessary(parent=None):
        """Sign into SRS Collector, and return the API key."""
        apiKey = Preferences.apiKey()
        if not apiKey:
            dialog = SignInDialog()
            dialog.exec_()
            apiKey = dialog.apiKey
            if apiKey:
                Preferences.setApiKey(apiKey)
        return apiKey

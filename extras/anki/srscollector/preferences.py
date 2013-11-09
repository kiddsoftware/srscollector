# Anki addon for SRS Collector
# Author: Eric Kidd <http://kiddsoftware.com/>
#
# This is free and unencumbered software released into the public domain.
# This program comes with ABSOLUTELY NO WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# For more information, please refer to <http://unlicense.org/>

from aqt.qt import *
from aqt import mw
from aqt.utils import showInfo
import aqt.preferences
from anki.hooks import wrap

class Preferences:
    """SRS Collector plugin preferences.  When instantiated, attaches itself
    to Anki's regular preferences window and install its own tab.  The
    static methods of this class may be used to manipulate preferences."""

    def __init__(self, window):
        self.window = window
        self.setUpTab()

    def setUpTab(self):
        """Add our tab to the preferences window."""
        tab = QWidget()
        layout = QBoxLayout(QBoxLayout.TopToBottom)

        button = QPushButton("Sign Out of SRS Collector")
        layout.addWidget(button)

        layout.addStretch()
        tab.setLayout(layout)
        self.window.form.tabWidget.addTab(tab, "SRS Collector")

        button.connect(button, SIGNAL("clicked()"), self.signOut)

    def signOut(self):
        """Sign the user out of SRS Collector."""
        Preferences.setApiKey(None)
        showInfo("Signed out.")

    @staticmethod
    def apiKey():
        """Return the SRS Collector api_key, or None if none is available."""
        return mw.col.conf['srsCollectorApiKey']

    @staticmethod
    def setApiKey(value):
        """Set the SRS Collector api_api, or pass None to clear it."""
        mw.col.conf['srsCollectorApiKey'] = value
        mw.col.setMod()

    @staticmethod
    def setupPreferencesUI(window):
        """Hook ourselves into window."""
        # Keep around our preferences object so its handlers stay connected.
        Preferences.instance = Preferences(window)

# Hook up our preferences code.
aqt.preferences.Preferences.setupNetwork = wrap(aqt.preferences.Preferences.setupNetwork, Preferences.setupPreferencesUI)

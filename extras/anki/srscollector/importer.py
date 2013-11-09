# Anki addon for SRS Collector
# Author: Eric Kidd <http://kiddsoftware.com/>
#
# This is free and unencumbered software released into the public domain.
# This program comes with ABSOLUTELY NO WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# For more information, please refer to <http://unlicense.org/>

from config import SERVER
from signin import SignInDialog
from cardmodel import CardModel

import anki
from aqt.qt import *
from aqt import mw
from aqt.utils import showInfo
from aqt.progress import ProgressManager

import urllib
import json
import tempfile
import shutil
from os import path

class Importer:
    """Downloads card information from SRS Collector."""

    FIELD_KEY_DICT = {
        "Front": "front",
        "Back": "back",
        "Source": "source_html"
    }

    def run(self, apiKey):
        """Import all available cards."""
        mw.checkpoint("Import from SRS Collector")
        self._apiKey = apiKey
        data = self._downloadCardData()
        self._ensureCardModels(data["card_models"])
        self._importCardsWithTempDir(data["cards"])
        mw.col.autosave()
        mw.reset()

    def _downloadCardData(self):
        url = "{0}api/v1/cards.json?state=reviewed&sort=age&serializer=export&api_key={1}".format(SERVER, self._apiKey)
        progress = ProgressManager(mw)
        try:
            progress.start(label="Downloading new cards...", immediate=True)
            progress.update()
            stream = urllib.urlopen(url)
            try:
                progress.update()
                return json.load(stream)
            finally:
                stream.close()
        finally:
            progress.finish()

    def _ensureCardModels(self, cardModels):
        self._cardModels = {}
        for json in cardModels:
            self._cardModels[json["id"]] = CardModel(json)

    def _importCardsWithTempDir(self, cards):
        self._temp =  tempfile.mkdtemp()
        try:
            self._importCards(cards)
        finally:
            shutil.rmtree(self._temp)

    def _importCards(self, cards):
        """Import a group of cards."""
        progress = ProgressManager(mw)
        try:
            progress.start(max=len(cards), label="Importing cards...")
            for i, card in enumerate(cards):
                self._importCard(card)
                progress.update(value=i)
        finally:
            progress.finish()
        showInfo("{0} cards imported.".format(len(cards)))

    def _importCard(self, card):
        """Import a card and its associated media files."""
        for mediaFile in card["media_files"]:
            self._importMediaFile(mediaFile)
        cardModel =  self._cardModels[card["card_model_id"]]
        note = anki.notes.Note(mw.col, cardModel.model)
        did = mw.col.decks.id(card["anki_deck"])
        note.model()['did'] = did
        #note.tags = tags
        for field in cardModel.fields:
            note[field] = card[cardModel.fieldCardAttrs[field]] or ""
        mw.col.addNote(note)

    def _importMediaFile(self, mediaFile):
        """Import a single media file into our collection."""
        local = path.join(self._temp, mediaFile['export_filename'])
        urllib.urlretrieve(mediaFile['download_url'], local)
        mw.col.media.addFile(local)

    @staticmethod
    def importCards():
        """Import cards from the server."""
        apiKey = SignInDialog.signInIfNecessary()
        if apiKey:
            Importer().run(apiKey)

# Install our menu item.
action = QAction("Import from SRS Collector...", mw)
mw.form.actionImportFromSrsCollector = action
mw.connect(action, SIGNAL("triggered()"), Importer.importCards)
mw.form.menuCol.insertAction(mw.form.actionExport, action)

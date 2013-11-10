# Anki addon for SRS Collector
# Author: Eric Kidd <http://kiddsoftware.com/>
#
# This is free and unencumbered software released into the public domain.
# This program comes with ABSOLUTELY NO WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# For more information, please refer to <http://unlicense.org/>

from aqt import mw

class CardModel:
    """Information from the server describing a model."""

    def __init__(self, json):
        self.id = json["id"]
        self.shortName = json["short_name"]
        self.name = json["name"]
        self.css = json["anki_css"]
        self.fields = []
        self.fieldCardAttrs = {}
        for field in json["card_model_fields"]:
            self.fields.append(field["name"])
            self.fieldCardAttrs[field["name"]] = field["card_attr"]
        self.templates = json["card_model_templates"]
        self.ensureModelExists()

    def ensureModelExists(self):
        """If the model doesn't exist yet, create it."""
        mm = mw.col.models
        self.model = mm.byName(self.name)
        if self.model is None:
            self.model = mm.new(self.name)
            self.model["css"] = self.css
            for f in self.fields:
                mm.addField(self.model, mm.newField(f))
            for template in self.templates:
                t = mm.newTemplate(template["name"])
                t['qfmt'] = template["anki_front_template"]
                t['afmt'] = template["anki_back_template"]
                mm.addTemplate(self.model, t)
            mm.add(self.model)

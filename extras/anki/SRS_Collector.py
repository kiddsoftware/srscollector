# Anki addon for SRS Collector
# Author: Eric Kidd <http://kiddsoftware.com/>
#
# This is free and unencumbered software released into the public domain.
# For more information, please refer to <http://unlicense.org/>

# TODO:
#   Server
#     Enforce unique card fronts
#   Client
#     Log in once and store API key as configuration data
#     Create deck if does not exist
#     Create model if does not exist
#     Handle empty/dup fronts
#     Mark cards as exported
#     Make sure we can handle cloze models

# Load our default configuration.
import srscollector.config

# Customize any configuration options you wish.
srscollector.config.SERVER = "http://0.0.0.0:5000/"

# Load various modules which hook into Anki's UI.
import srscollector.importer
import srscollector.preferences

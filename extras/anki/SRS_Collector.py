# Anki addon for SRS Collector
# Author: Eric Kidd <http://kiddsoftware.com/>
#
# This is free and unencumbered software released into the public domain.
# This program comes with ABSOLUTELY NO WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# For more information, please refer to <http://unlicense.org/>

# Load our default configuration.
import srscollector.config

# Customize any configuration options you wish.
#
# For example, to connect to local dev version of the site, use:
#srscollector.config.SERVER = "http://0.0.0.0:5000/"

# Load various modules which hook into Anki's UI.
import srscollector.importer
import srscollector.preferences

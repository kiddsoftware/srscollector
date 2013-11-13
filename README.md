## SRS Collector

This is a web-based application for people who do a [lot of reading in
foreign languages][extensive], and who use [Anki][] to efficiently review
snippets of text containing unknown vocabulary.  Features include:

* A plugin for Google Chrome which can be used to import snippets of text as
  you're reading.
* Support for bulk import of text snippets highlight using ebook readers.
* A web-based UI for looking up words in both bilingual and monolingual
  dictionaries.
* An Anki addon for easy export.

To try out SRS Collector, visit [http://www.srscollector.com/][srsc].

### Developer notes

To get started, you'll need Ruby 2.0, which you can install using [rvm][].
You will also need a `.env` file containing valid values for the following
credentials:

    S3_BUCKET_NAME=...
    AWS_ACCESS_KEY_ID=...
    AWS_SECRET_ACCESS_KEY=...
    GOOGLE_API_KEY=...

Once this is in place, run:

    bundle install
    rake db:migrate
    rake db:seed
    rake # Run tests to make sure everything's working.
    foreman start

The Chrome and Anki plugins are in the `extras` directory.

If you want to deploy the application to Heroku, please get in touch--there
are a number of database-related parameters which are necessary to get
reasonable performance.

### Contributing

Patches are welcome!

All pull requests should include unit tests for new Ruby code and feature
specs for new CoffeeScript code (see `spec/features`), and all tests must
pass.  Please ask if you need help with this!

Also, all contributions must be accompanied by a public domain dedication:

    I dedicate any and all copyright interest in this software to the
    public domain. I make this dedication for the benefit of the public at
    large and to the detriment of my heirs and successors. I intend this
    dedication to be an overt act of relinquishment in perpetuity of all
    present and future rights to this software under copyright law.

[extensive]: http://en.wikipedia.org/wiki/Extensive_reading
[Anki]: http://ankisrs.net/
[srsc]: http://www.srscollector.com/
[rvm]: https://rvm.io/

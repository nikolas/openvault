[![Build Status](https://travis-ci.org/afred/openvault.png)](https://travis-ci.org/afred/openvault)

# Openvault

[Openvault](http://openvault.wgbh.org) is Rails/Hydra application which makes available to the public
most of the metadata for WGBH media assets, and a small selection of our media.

## Related projects

**Boston TV News Digital Library**: 
([site](http://bostonlocaltv.org) [github](https://github.com/WGBH/bostonlocaltv))
Footage from WGBH's *Ten O'Clock News* is here, along with footage from other area broadcasters.
(It's probably more difficult than it ought to be for people on Openvault to discover the News site.)

**Stock Sales**:
([site](http://www.wgbhstocksales.org/) [github](https://github.com/WGBH/stock_sales))
If folks want to purchase footage, they should be directed to Stock Sales.
More connections between the two site might promote more sales.

**PBCore**: ([docs](http://pbcore.org/)) An XML standard for public broadcasting metadata.
This is what we store in Fedora. You shouldn't need to worry about the details: access is 
provided through `PbcoreDescDoc` which extends `ActiveFedora::OmDatastream`.

**Blog**:
([site](http://blog.openvault.wgbh.org/) [config github](https://github.com/WGBH/openvault-blog))
In the earlier version of the site, all of wordpress was checked in to this codebase.
Now it's its own site, with just the configuration tweaks to the default installation checked in.
The downside is that nothing is keeping the style in sync between these two sites.

**Media server**:
You shouldn't need to worry about the media server, except to note that it blocks requests from
hosts it hasn't white-listed. For development, if you actually want to see media, add
"`127.0.0.1  localhost.wgbh.org`" to your `/etc/hosts`

**Digital Commonwealth**:
([site](https://www.digitalcommonwealth.org/))
They (hopefully) harvest our content via OAI-PMH. They are interested only is media, and not in
our "Program" or "Series" records.

## Operations

### Deploy

Merge latest changes into master and redeploy
```
$ git checkout master
$ git pull
$ bundle exec cap --verbose staging deploy
  # There are incompatibilities between major versions of capistrano:
  # 'bundle exec' makes sure you're using the one specified in Gemfile.
```

(You will need to supply a password.)
When complete, check http://openvault-staging.wgbh.org/; if it looks good:
```
$ bundle exec cap --verbose production deploy
```

(Password, again.) Check http://openvault.wgbh.org/ to confirm that the deployment worked.

### Ingest

#### Metadata

For managing the source metadata, we have a git repo at http://atlas.wgbh.org/stash with all the pbcore xml,
and we have a checkout of this repo on the production server. To reingest:
```
$ ssh openvault@lsopenvault01.wgbh.org
$ cd /wgbh/http/openvault/current
$ RAILS_ENV=production bundle exec rake openvault:ingest \
   file=/wgbh/http/openvault/openvault_ingest_data/pbcore_xml_from_artesia/all_assets/FOR-EXAMPLE.xml
```

You can also set a mode to determine how conflicts are handled.

#### Transcripts

If a transcript is missing, there are two steps to fix it:
- Load metadata to create Transcript object
- Load the actual text of the transcript

The first step is the same as any metadata load. The second is messier because we haven't made a rake task yet.
```
$ RAILS_ENV=production bundle exec rails c
> video = Video.find(slug: 'put-the-url-slug-here').first
> require 'openvault'
> require 'openvault/transcript_ingester'
> Openvault::TranscriptIngester.ingest_tei_xml_specified_by_pbcore!(
    video.transcripts.first, 
    '/wgbh/http/openvault/openvault_ingest_data/transcripts_tei_xml/all_transcripts/')
    # Second argument is directory where the file can be found.
```

### Debug

On the server:

- Consult the logs.
- Look at the PBCore for a record: append `.pbcore` to any URL.
- Look at the Solr result for a record: append `.solr` to any URL.
- As a *last* resort, the files can be tweaked live, but it's under Passenger, to recompile isn't automatic.

Locally:

- rspec
- byebug

## Internals

### `routes.rb`

- There are a lot of adhoc redirects so that old references we found with webmaster tools don't break.
- Any URL which isn't matched by anything more specific falls through to the `OverrideController`

### `controllers/`

At the heart of a Blacklight application is the `CatalogController`.
The most important tweak in ours is `#lookup_and_set_fields` which allows items to be found by a slug we've assigned.

### `models/`

The most important are the subclasses of `OpenvaultAsset`:
- A `Series` has multiple ...
- `Program`s which in turn have
- `Video`,
- `Audio`,
- `Image`, and
- `Transcript`

Instances are linked in Fedora, and these links are exposed in the UI.

### `views/`

*TODO*

 

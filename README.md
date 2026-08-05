# robinjanssens.net
My personal website

## Building

```sh
bundle install
bundle exec jekyll serve   # preview on http://localhost:4000
bundle exec jekyll build   # output in _site/
```

### Vendored front-end dependencies

All front-end dependencies are **self-hosted at pinned versions**. The site makes no third-party
requests at all — nothing is fetched from a CDN at page load.

| File | Version | Source |
|---|---|---|
| `assets/css/bootstrap.min.css` | 5.3.8 | `https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css` |
| `assets/js/bootstrap.min.js` | 5.3.8 | `https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js` |
| `assets/js/feather.min.js` | 4.22.0 | `https://cdn.jsdelivr.net/npm/feather-icons@4.22.0/dist/feather.min.js` |

To bump a version, download the file, verify it, and update the table above:

```sh
V=5.3.8
curl -sfL "https://cdn.jsdelivr.net/npm/bootstrap@$V/dist/css/bootstrap.min.css" -o assets/css/bootstrap.min.css
curl -sfL "https://cdn.jsdelivr.net/npm/bootstrap@$V/dist/js/bootstrap.min.js"   -o assets/js/bootstrap.min.js
# cross-check the bytes against a second CDN before committing
curl -sfL "https://unpkg.com/bootstrap@$V/dist/css/bootstrap.min.css" | shasum -a 384
shasum -a 384 assets/css/bootstrap.min.css
```

### ImageMagick and exiftool

Images are served as AVIF, WebP and JPEG. `_plugins/thumbnails.rb` generates all three at build
time from the originals in `_originals/images/`, which needs **ImageMagick 7** with the AVIF
(`libheif`) and WebP delegates. It also uses **exiftool** to strip metadata from the originals
themselves, so GPS coordinates in a phone photo never reach the git history.

Both are only needed to add or change images — the generated files are committed, so the site
builds without either. Missing ImageMagick prints a warning and skips generation; missing exiftool
prints a warning and leaves the originals untouched, but published images are stripped regardless.

**macOS (Homebrew)**

```sh
brew install imagemagick libheif webp exiftool
```

**Debian / Ubuntu**

```sh
sudo apt install imagemagick libmagickcore-7.q16-10-extra libimage-exiftool-perl
```

Debian 13 (Trixie) is the first release to ship ImageMagick 7 (`7.1.1`). Debian 12 (Bookworm) and
earlier ship ImageMagick 6, which has no `magick` command and no AVIF support.

Verify the delegates are present on either platform — this is the check that actually matters,
since AVIF support depends on how the package was compiled:

```sh
magick -list format | grep -iE 'avif|webp'
```

## References
- [Jekyll](https://jekyllrb.com/) static site generator under [MIT License](https://github.com/jekyll/jekyll/blob/master/LICENSE)
- [Bootstrap](http://getbootstrap.com/) responsive library under [MIT License](https://github.com/twbs/bootstrap/blob/master/LICENSE)
- Icons by [Feather Icons](https://feathericons.com/) under the [MIT License](https://github.com/colebemis/feather/blob/master/LICENSE)
- Brand Logo Icons by [Simple Icons](https://simpleicons.org/) under the [CC0 License](https://github.com/simple-icons/simple-icons-website/blob/master/LICENSE.md)
- [Allerta](https://fonts.google.com/specimen/Allerta) typeface by [Matt McInerney](http://matt.cc) under [Open Font License](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL_web)
- [Allerta Stencil](https://fonts.google.com/specimen/Allerta+Stencil) typeface by [Matt McInerney](http://matt.cc) under [Open Font License](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL_web)
- [Noto Sans](https://fonts.google.com/noto/specimen/Noto+Sans) typeface by [The Noto Project](https://github.com/notofonts) under [Open Font License](http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL_web)

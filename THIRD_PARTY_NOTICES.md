# Third-Party Notices

STEMcoding bundles or depends on the third-party components below. Each is the
property of its respective authors and is licensed under its own terms, which
govern that component regardless of the license covering STEMcoding itself.

## Bundled in this repository

### p5.js
- Files: `app/assets/javascripts/p5.min.js` (v1.4.0), `app/assets/javascripts/p5_sound.min.js` (v1.0.1)
- License: **GNU LGPL-2.1**
- Copyright: The Processing Foundation and the p5.js contributors
- Homepage: https://p5js.org
- `app/assets/javascripts/p5_norandom.min.js` is a **locally modified copy** of
  p5.js. As a derivative of LGPL-licensed code, it remains under the LGPL-2.1;
  its modifications are limited to the random-number behavior. The original
  source is available at https://github.com/processing/p5.js

### cocoon.js
- File: `app/javascript/vendor/cocoon.js`
- License: **MIT**
- Copyright: Nathan Van der Auwera and cocoon contributors
- Homepage: https://github.com/nathanvda/cocoon

### TinyMCE
- Integrated via the `tinymce-rails` gem (`config/tinymce.yml`)
- License: **MIT** (TinyMCE 6+; earlier versions were LGPL-2.1). Review the
  version pinned in `Gemfile.lock` and its bundled `LICENSE` before
  redistributing.
- Homepage: https://www.tiny.cloud

## Trademarks / brand assets

- `STEMcoding_v*.png/jpg` and other STEMcoding brand assets are the property of
  Chris Orban

## Ruby gems and JavaScript packages

All other dependencies are installed from public registries (RubyGems, npm) via
`Gemfile` / `package.json`. See `Gemfile.lock` and `yarn.lock` for exact
versions; each dependency retains its own license.

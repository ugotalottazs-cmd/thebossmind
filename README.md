# The Boss Mind

A Jekyll-based site hosting WordPress content migrated from XML exports.

## Setup

1. **Extract WordPress Exports**
   ```bash
   unzip Doload.zip
   unzip Dow.zip
   unzip Down.zip
   ```

2. **Convert WordPress to Jekyll**
   ```bash
   ruby scripts/wordpress_to_jekyll.rb path/to/wordpress-export.xml
   ```

3. **Build and Preview Locally**
   ```bash
   bundle install
   bundle exec jekyll serve
   ```
   Visit `http://localhost:4000/thebossmind`

4. **Deploy**
   Push to main branch - GitHub Actions will automatically build and deploy to GitHub Pages.

## Structure

- `_posts/` - Jekyll post files (auto-generated from WordPress XML)
- `_layouts/` - HTML templates
- `scripts/` - Conversion utilities
- `.github/workflows/` - GitHub Actions automation

## Posts Organization

Posts are organized by category hierarchy in the URL structure:
- `/posts/{category}/{post-title}/`

Posts are also browsable by:
- Category index: `/categories/`
- Tag index: `/tags/`
- Date archives: `/archive/`

## Site

Visit: https://ugotalottazs-cmd.github.io/thebossmind

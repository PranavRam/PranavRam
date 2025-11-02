# AGENTS.md - Tableau Static Site Generator Project Guide

This guide covers everything you need to work with this Tableau static site generator built with Elixir.

## Project Overview

**Framework**: [Tableau](https://github.com/elixir-tools/tableau) - Static site generator for Elixir  
**Markdown**: [MDEx](https://github.com/leandrocp/mdex) - Fast Rust-based Markdown processor  
**Styling**: Tailwind CSS with @tailwindcss/typography plugin  
**Template Engine**: HEEx (Phoenix HTML components)  

## Quick Reference

### Common Commands

```bash
# Install dependencies
mix deps.get
npm install

# Build CSS (run this after editing Tailwind classes)
npx tailwindcss -i ./assets/css/site.css -o ./extra/css/site.css

# Build static site
mix tableau.build

# Start development server with live reload (http://localhost:4999)
mix tableau.server

# Production build
MIX_ENV=prod mix tableau.build

# Create new post
mix post "My New Post Title"
```

### File Structure

```
pr_website/
├── _posts/              # Blog posts (markdown with YAML frontmatter)
├── _pages/              # Static pages (markdown with YAML frontmatter)
├── _drafts/             # Draft posts (dev only, not in production)
├── _wip/                # WIP pages (dev only)
├── _data/               # Data files (YAML or .exs scripts)
├── extra/               # Static assets (auto-copied to _site/)
│   ├── css/             # CSS files (site.css compiled from Tailwind)
│   ├── images/          # Images
│   └── js/              # JavaScript files
├── assets/              # Source assets (not published)
│   └── css/             # Tailwind source files
├── lib/
│   ├── pr_website.ex    # Defines ~H sigil for HEEx templates
│   ├── layouts/         # Layout modules
│   │   ├── root_layout.ex     # Base layout (header, footer, HTML structure)
│   │   └── post_layout.ex     # Post-specific layout
│   ├── pages/           # Page modules (Elixir-defined pages)
│   │   └── home_page.ex       # Homepage
│   └── mix/tasks/       # Custom Mix tasks
│       └── post.ex            # mix post task
├── config/              # Configuration files
│   ├── config.exs       # Global config (Tableau, extensions, markdown)
│   ├── dev.exs          # Development config (future posts, draft dirs)
│   └── prod.exs         # Production config
├── _site/               # Build output (gitignored)
├── tailwind.config.js   # Tailwind CSS configuration
├── package.json         # Node dependencies (Tailwind)
└── mix.exs              # Elixir dependencies
```

---

## Working with Posts

### Creating Posts

**Filename format**: `YYYY-MM-DD-title-slug.md` (e.g., `2025-11-02-my-first-post.md`)

**Using mix task**:
```bash
mix post "My Amazing Post"
# Creates: _posts/2025-11-02-my-amazing-post.md
```

**Frontmatter template**:
```markdown
---
layout: PrWebsite.PostLayout
title: "My Post Title"
date: 2025-11-02 10:00:00 -04:00
permalink: /:title/
tags: ["elixir", "web"]
summary: "A brief description for the homepage"
---

Your markdown content here...
```

### Frontmatter Fields

| Field | Required | Description | Example |
|-------|----------|-------------|---------|
| `layout` | Yes | Layout module | `PrWebsite.PostLayout` |
| `title` | Yes | Post title | `"Hello World"` |
| `date` | Yes | Publication date/time | `2025-11-02 10:00:00 -04:00` |
| `permalink` | No | URL pattern | `/:title/` or `/blog/:year/:month/:title/` |
| `tags` | No | Array of tags | `["elixir", "tutorial"]` |
| `summary` | No | Short description | `"Learn about Elixir"` |
| Custom | No | Any custom field | Accessible via `@page.field_name` |

### Permalink Variables

- `:title` - Slugified post title
- `:year` - 4-digit year (e.g., `2025`)
- `:month` - 2-digit month (e.g., `11`)
- `:day` - 2-digit day (e.g., `02`)
- Any frontmatter field (e.g., `:category`, `:author`)

**Examples**:
- `/:title/` → `/my-first-post/`
- `/blog/:year/:month/:day/:title/` → `/blog/2025/11/02/my-first-post/`
- `/:category/:title.html` → `/tutorials/my-first-post.html`

### Accessing Posts in Templates

Posts are available via `@posts` assign (automatically sorted by date, newest first):

```elixir
~H"""
<h1>Recent Posts</h1>
<ul>
  <li :for={post <- Enum.take(@posts, 5)}>
    <a href={post.permalink}><%= post.title %></a>
    <time><%= Calendar.strftime(post.date, "%B %d, %Y") %></time>
  </li>
</ul>
"""
```

**Post attributes**:
- `post.title` - Post title
- `post.date` - DateTime struct
- `post.permalink` - Generated URL
- `post.body` - Rendered HTML content
- `post.tags` - Array of tags
- `post.summary` - Custom summary (or excerpt from body)
- `post.file` - Source file path
- Any custom frontmatter field

---

## Working with Layouts

Layouts wrap page content and can be nested. Two main layouts in this project:

### RootLayout (lib/layouts/root_layout.ex)

Base layout with:
- HTML structure (`<html>`, `<head>`, `<body>`)
- Header with navigation
- Footer with social icons
- Dark mode detection
- Live reload script (dev only)

**Available assigns**:
- `@site` - Site configuration
- `@page` - Current page/post data
- `@inner_content` - Content to render (from nested layouts or pages)

### PostLayout (lib/layouts/post_layout.ex)

Wraps blog posts with:
- Article header (title, date)
- Nested inside RootLayout

**Usage**:
```markdown
---
layout: PrWebsite.PostLayout
---
```

### Creating Custom Layouts

```elixir
defmodule PrWebsite.CustomLayout do
  use Tableau.Layout, layout: PrWebsite.RootLayout
  import PrWebsite

  def template(assigns) do
    ~H"""
    <div class="custom-wrapper">
      <h1><%= @page[:title] %></h1>
      <%= render @inner_content %>
    </div>
    """
  end
end
```

---

## Working with Pages

Pages can be defined as Elixir modules or markdown files with frontmatter.

### Module-Based Pages (Elixir)

**Example**: `lib/pages/about_page.ex`
```elixir
defmodule PrWebsite.AboutPage do
  use Tableau.Page,
    layout: PrWebsite.RootLayout,
    permalink: "/about/",
    title: "About"

  import PrWebsite

  def template(assigns) do
    ~H"""
    <h1>About This Site</h1>
    <p>Built with Elixir and Tableau!</p>
    """
  end
end
```

### File-Based Pages (Markdown)

**Example**: `_pages/contact.md`
```markdown
---
layout: PrWebsite.RootLayout
title: "Contact"
permalink: "/contact/"
---

## Get in Touch

Email: hello@example.com
```

### Homepage (lib/pages/home_page.ex)

The homepage displays:
- Avatar and name
- Description
- 4 most recent posts in 2-column grid
- Link to older posts

**Key features**:
- Uses `@posts` assign (automatically available)
- 2-column responsive grid with alternating margins
- Animated underline hover effects

---

## Styling with Tailwind CSS

### Configuration

**Tailwind config**: `tailwind.config.js`
- **Content paths**: Scans `lib/**/*.ex`, `_posts/**/*.md`, `_pages/**/*.md`
- **Dark mode**: Class-based (`dark:` prefix)
- **Typography plugin**: `@tailwindcss/typography` for prose styling

### Workflow

1. **Edit Tailwind classes** in templates
2. **Rebuild CSS**:
   ```bash
   npx tailwindcss -i ./assets/css/site.css -o ./extra/css/site.css
   ```
3. **Or use watch mode** (auto-rebuilds):
   ```bash
   mix tableau.server  # Runs Tailwind watcher automatically
   ```

### Key Tailwind Classes Used

**Typography**:
- `prose` / `dark:prose-invert` - Typography plugin base
- `lg:prose-xl` - Larger prose on big screens
- `not-prose` - Opt out of prose styles for specific elements

**Layout**:
- `px-4 md:px-0` - Responsive padding
- `md:max-w-2xl lg:max-w-3xl xl:max-w-5xl` - Responsive max widths
- `mx-auto` - Center container
- `sm:w-1/2` - 2-column grid on small screens and up

**Dark Mode**:
- `dark:bg-slate-900` - Dark background
- `dark:text-white` - Dark text color
- `dark:invert` - Invert images (for icons)

**Custom Classes**:
- Animated underlines (using `before:` pseudo-element)
- Custom prose spacing overrides

### Adding New Styles

```css
/* assets/css/site.css */
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Custom styles */
.my-custom-class {
  /* ... */
}
```

---

## Markdown Features (MDEx)

### Enabled Extensions

Current configuration in `config/config.exs`:

```elixir
extension: [
  table: true,               # Tables
  header_ids: "",            # Auto-generate heading IDs
  tasklist: true,            # Task lists - [x]
  strikethrough: true,       # ~~strikethrough~~
  autolink: true,            # Auto-detect URLs
  alerts: true,              # GitHub-style alerts
  footnotes: true            # Footnote references
]
```

### Syntax Highlighting

**Current setup**:
```elixir
syntax_highlight: [
  formatter: {:html_inline, theme: "neovim_dark"}
]
```

**Available themes**: `onedark`, `github_dark`, `github_light`, `catppuccin_latte`, `nord`, `dracula`, etc.

**Changing theme**:
```elixir
syntax_highlight: [formatter: {:html_inline, theme: "github_light"}]
```

### Code Blocks

**Basic**:
````markdown
```elixir
def hello(name) do
  "Hello, #{name}!"
end
```
````

**With line highlighting** (requires decorators):
````markdown
```elixir highlight_lines="2-3"
def greet do
  name = "World"     # highlighted
  "Hello, #{name}!"  # highlighted
end
```
````

### Additional Markdown Extensions

To enable more features, add to `extension:` config:

| Extension | Syntax | Enabled |
|-----------|--------|---------|
| **Superscript** | `^text^` | ❌ |
| **Subscript** | `~text~` | ❌ |
| **Underline** | `__text__` | ❌ |
| **Math** | `$...$` or `$$...$$` | ❌ |
| **Emoji shortcodes** | `:smile:` | ❌ |
| **Wikilinks** | `[[page]]` | ❌ |
| **Description lists** | `term\n: definition` | ❌ |

**Example enabling math**:
```elixir
extension: [
  # ... existing extensions
  math_dollars: true
]
```

### Mermaid Diagrams

**Not currently configured**. To add mermaid support:

1. **Add dependency**:
   ```elixir
   # mix.exs
   {:mdex_mermaid, "~> 0.1"}
   ```

2. **Configure in markdown processing** or use plugin system:
   ```elixir
   MDEx.new(markdown: content)
   |> MDExMermaid.attach(mermaid_version: "11")
   |> MDEx.to_html!()
   ```

3. **Use in posts**:
   ````markdown
   ```mermaid
   graph TD
       A[Start] --> B[Process]
       B --> C[End]
   ```
   ````

### Tables

Enabled by default. Syntax:

```markdown
| Header 1 | Header 2 |
|----------|----------|
| Cell 1   | Cell 2   |
```

### Task Lists

Enabled by default. Syntax:

```markdown
- [ ] Unchecked task
- [x] Checked task
```

### Alerts

Enabled by default. Syntax:

```markdown
> [!NOTE]
> Important information

> [!WARNING]
> Caution required

> [!TIP]
> Helpful hint
```

### Footnotes

Enabled by default. Syntax:

```markdown
Here's a sentence with a footnote[^1].

[^1]: This is the footnote content.
```

---

## Configuration Reference

### Global Config (config/config.exs)

**Tableau core**:
```elixir
config :tableau, :config,
  url: "http://localhost:4999"    # Base URL for site
```

**Live reload**:
```elixir
config :tableau, :reloader,
  patterns: [
    ~r"^lib/.*.ex",              # Watch Elixir files
    ~r"^(_posts|_pages)/.*.md",  # Watch markdown files
    ~r"^extra/.*\.(css|js)"      # Watch static assets
  ]
```

**Assets (Tailwind watcher)**:
```elixir
config :tableau, :assets,
  tailwind: {System, :cmd, [
    "npx",
    ["tailwindcss", "-i", "./assets/css/site.css", "-o", "./extra/css/site.css", "--watch"],
    [env: [{"PATH", System.get_env("PATH")}]]
  ]}
```

**Markdown (MDEx)**:
```elixir
config :tableau, :config,
  markdown: [
    mdex: [
      extension: [...],           # Markdown extensions
      render: [unsafe: true],     # Allow raw HTML
      syntax_highlight: [...]     # Code highlighting
    ]
  ]
```

**Extensions**:
```elixir
config :tableau, Tableau.PageExtension, enabled: true
config :tableau, Tableau.PostExtension, enabled: true
config :tableau, Tableau.DataExtension, enabled: true
config :tableau, Tableau.SitemapExtension, enabled: true
config :tableau, Tableau.RSSExtension,
  enabled: true,
  title: "pr_website",
  description: "My beautiful website"
```

### Development Config (config/dev.exs)

```elixir
config :tableau, Tableau.PageExtension, dir: ["_pages", "_wip"]
config :tableau, Tableau.PostExtension, future: true, dir: ["_posts", "_drafts"]
```

**What this does**:
- **`future: true`** - Show posts with future dates in development
- **`dir: ["_posts", "_drafts"]`** - Include draft posts in dev
- **`dir: ["_pages", "_wip"]`** - Include WIP pages in dev

### Production Config (config/prod.exs)

```elixir
config :tableau, Tableau.PostExtension, future: false, dir: ["_posts"]
```

**What this does**:
- **`future: false`** - Hide future-dated posts
- **`dir: ["_posts"]`** - Only include published posts

---

## Development Workflow

### Starting Development Server

```bash
mix tableau.server
```

**What happens**:
1. Compiles Elixir code
2. Starts Bandit web server on `http://localhost:4999`
3. Starts Tailwind CSS watcher
4. Watches files for changes and triggers:
   - Page rebuilds
   - Browser auto-reload (via WebSocket)

**Access at**: http://localhost:4999

### Making Changes

**Edit templates/layouts**:
1. Modify files in `lib/layouts/` or `lib/pages/`
2. Server auto-recompiles and reloads browser

**Edit posts/pages**:
1. Modify markdown files in `_posts/` or `_pages/`
2. Server rebuilds affected pages and reloads browser

**Edit styles**:
1. Modify Tailwind classes in templates
2. Tailwind watcher rebuilds CSS automatically
3. Browser reloads with new styles

### Common Issues

**Issue**: Tailwind classes not applying
- **Solution**: Rebuild CSS with `npx tailwindcss -i ./assets/css/site.css -o ./extra/css/site.css`

**Issue**: Server won't start (watcher errors)
- **Solution**: Check that `npx` is in PATH, or use full path in config

**Issue**: Posts not showing up
- **Solution**: Check frontmatter is valid YAML, check date format, ensure `layout` is correct

**Issue**: Changes not reloading
- **Solution**: Check `:reloader` patterns include your file type

---

## Dark Mode

### How It Works

1. **Detection**: JavaScript in `<head>` checks `prefers-color-scheme`
2. **Application**: Adds/removes `dark` class on `<html>` element
3. **Styling**: Tailwind's `dark:` variants apply dark styles

**Detection script** (in RootLayout):
```javascript
if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
  document.documentElement.classList.add('dark');
}
```

### Using Dark Mode in Templates

**Text colors**:
```heex
<p class="text-black dark:text-white">Auto-switches with theme</p>
<span class="text-gray-600 dark:text-gray-400">Muted text</span>
```

**Backgrounds**:
```heex
<div class="bg-white dark:bg-slate-900">Content</div>
```

**Images** (icons):
```heex
<img src="/images/icon.svg" class="dark:invert" />
```

### Color Palette Reference

| Element | Light Mode | Dark Mode |
|---------|------------|-----------|
| Background | `white` | `dark:bg-slate-900` |
| Text Primary | `text-black` | `dark:text-white` |
| Text Secondary | `text-gray-800` | `dark:text-gray-200` |
| Text Muted | `text-gray-600` | `dark:text-gray-400` |
| Text Light | `text-gray-500` | `dark:text-gray-400` |
| Accent | `text-blue-700` | `dark:text-emerald-400` |
| Border | `border-gray-400` | `dark:border-gray-400` |

---

## Assets & Images

### Adding Images

**Location**: Place images in `extra/images/`

**Usage in templates**:
```heex
<img src="/images/avatar.jpg" alt="Profile" />
```

**Usage in markdown**:
```markdown
![Alt text](/images/photo.jpg)
```

**Current images**:
- `avatar.jpg` - Profile photo (590KB, 3280×3480)
- `github.webp` - GitHub icon (688 bytes, 64×64)
- `twitter.webp` - Twitter icon (634 bytes, 64×64)
- `linkedin.webp` - LinkedIn icon (414 bytes, 64×64)

### Adding CSS/JS

**CSS**: Place in `extra/css/`
**JavaScript**: Place in `extra/js/`

**Auto-copied to `_site/`** during build.

---

## Deployment

### Building for Production

```bash
MIX_ENV=prod mix tableau.build
```

**Output**: `_site/` directory contains complete static site

### GitHub Pages

1. **Add workflow** (`.github/workflows/deploy.yml`):
```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Elixir
        uses: erlef/setup-beam@v1
        with:
          elixir-version: '1.19'
          otp-version: '28'
      
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      
      - name: Install dependencies
        run: |
          mix deps.get
          npm install
      
      - name: Build CSS
        run: npx tailwindcss -i ./assets/css/site.css -o ./extra/css/site.css --minify
      
      - name: Build site
        run: MIX_ENV=prod mix tableau.build
      
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v4
        with:
          path: _site
      
      - name: Deploy to GitHub Pages
        uses: actions/deploy-pages@v4
```

2. **Update config** (`config/prod.exs`):
```elixir
config :tableau, :config,
  url: "https://username.github.io/repo"
```

---

## Tips & Best Practices

### Content Organization

- **Posts**: Time-based content (blog posts, news, updates)
- **Pages**: Evergreen content (about, contact, documentation)
- **Drafts**: Use `_drafts/` in development, exclude in production
- **WIP**: Use `_wip/` for work-in-progress pages (dev only)

### Permalinks

- **Always end with `/`** for clean URLs (e.g., `/about/`)
- **Or use `.html`** for specific files (e.g., `404.html`)
- **Avoid spaces** - Use dashes in slugs

### Performance

- **Optimize images** before adding to `extra/images/`
- **Use WebP** for smaller file sizes (icons are already WebP)
- **Minify CSS** in production (Tailwind does this with `--minify`)

### SEO

- **Use descriptive titles** in frontmatter
- **Add summaries** to posts for preview text
- **Enable sitemap** (already enabled)
- **Use RSS feed** for blog subscribers (already configured)

### Accessibility

- **Use semantic HTML** (`<article>`, `<nav>`, `<header>`, `<footer>`)
- **Add alt text** to all images
- **Ensure color contrast** (check with browser DevTools)
- **Test keyboard navigation**

---

## Troubleshooting

### Build Errors

**Error**: `module PrWebsite is not loaded`
- **Cause**: Missing `lib/pr_website.ex`
- **Fix**: Ensure file exists with `sigil_H` macro definition

**Error**: `cannot compile module`
- **Cause**: Syntax error in template
- **Fix**: Check HEEx syntax, ensure all tags are closed

**Error**: `undefined function Tableau.posts`
- **Cause**: Incorrect API usage
- **Fix**: Use `@posts` assign, not `Tableau.posts/1`

### Runtime Errors

**Error**: `Failed to find layout path`
- **Cause**: Layout module doesn't exist
- **Fix**: Create layout module or fix `layout:` in frontmatter

**Error**: `404 Not Found` on dev server
- **Cause**: Incorrect permalink
- **Fix**: Check `permalink:` in page options, ensure starts with `/`

### Styling Issues

**Classes not applying**:
- Rebuild Tailwind CSS
- Check `tailwind.config.js` includes file path
- Verify class names are correct (typos)

**Dark mode not working**:
- Check `dark:` prefix on classes
- Verify script is in `<head>`
- Test system dark mode preference

---

## External Resources

- **Tableau Docs**: https://hexdocs.pm/tableau
- **Tableau GitHub**: https://github.com/elixir-tools/tableau
- **MDEx Docs**: https://hexdocs.pm/mdex
- **MDEx GitHub**: https://github.com/leandrocp/mdex
- **Tailwind CSS Docs**: https://tailwindcss.com/docs
- **Tailwind Typography**: https://tailwindcss.com/docs/typography-plugin
- **HEEx Guide**: https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html

---

## Project-Specific Notes

### Custom Mix Task: `mix post`

Creates new blog post with template:
```bash
mix post "My Post Title"
```

**Implementation**: `lib/mix/tasks/post.ex`

### Site URL & Contact

Update in templates:
- **Social links**: `lib/layouts/root_layout.ex` (footer)
- **Site URL**: `config/prod.exs`

### Adding Navigation Links

Edit `lib/layouts/root_layout.ex` in header `<nav>` section.

---

**Last Updated**: November 2025

# Solopreneur Tools - Eleventy Theme

A beautiful, production-ready Eleventy blog theme for reviewing tools and resources for solopreneurs.

## Quick Start

```bash
# Install dependencies
npm install

# Build CSS
npm run build:css

# Start development server
npm run dev
```

The site will be available at `http://localhost:8080`

## Project Structure

```
├── src/
│   ├── _includes/          # Reusable components (header, footer, newsletter)
│   ├── _layouts/           # Page layouts (base.njk, article.njk)
│   ├── _data/              # Global data files (categories, authors, site)
│   ├── content/
│   │   └── articles/       # Markdown blog posts
│   ├── assets/
│   │   └── css/            # Compiled CSS
│   ├── styles/
│   │   └── globals.css     # Tailwind CSS source
│   ├── articles/           # Articles listing page
│   ├── categories/         # Category dynamic pages
│   └── tags.njk            # Tag dynamic pages
├── public/
│   └── favicon.svg
├── _site/                  # Built output
├── eleventy.config.js      # Eleventy configuration
├── tailwind.config.js      # Tailwind configuration
└── package.json
```

## Writing Articles

Create a new `.md` file in `src/content/articles/`:

```markdown
---
title: "Your Article Title"
description: "A description between 30-200 characters"
pubDate: 2024-01-15
author: "admin"
image:
  url: "https://images.pexels.com/..."
  alt: "Image description"
category: "productivity"
tags: ["tag1", "tag2", "tag3"]
featured: false
draft: false
rating: 4.5
readingTime: 8
difficulty: "beginner"
keywords: ["seo", "keywords"]
tools:
  - name: "Tool Name"
    url: "https://example.com"
    pricing: "freemium"
faq:
  - question: "Question?"
    answer: "Answer."
pros:
  - "Pro 1"
  - "Pro 2"
cons:
  - "Con 1"
layout: article.njk
permalink: /articles/your-slug/index.html
---

Your article content here...

## Heading 2

### Heading 3

- Bullet point
- Another point

**Bold text** and *italic text*.

| Column 1 | Column 2 |
|----------|----------|
| Data     | Data     |
```

## Categories

Categories are defined in `src/_data/categories.json`. Available categories:

- productivity
- ai-tools
- automation
- design
- finance
- marketing
- writing

## Commands

| Command | Description |
|---------|-------------|
| `npm run dev` | Start dev server with hot reload |
| `npm run build` | Build for production |
| `npm run build:css` | Compile Tailwind CSS |
| `npm run clean` | Delete build output |

## Deployment

The built `_site` folder can be deployed to:

- **Vercel**: Push to GitHub, connect repo, done
- **Netlify**: Push to GitHub, connect repo, done
- **GitHub Pages**: Push `_site` contents to `gh-pages` branch
- **Any static host**: Upload `_site` folder

## Customization

### Site Info
Edit `src/_data/site.json` for site name, URL, description.

### Colors
Edit CSS variables in `src/styles/globals.css`:

```css
:root {
  --primary: 199 89% 48%;  /* Main brand color */
  --background: 0 0% 100%;
  --foreground: 222 47% 11%;
}
```

### Typography
The theme uses Tailwind's prose classes for article content. Styles are in `globals.css`.

## Running in VS Code

1. Open the project folder in VS Code
2. Open terminal: `Ctrl+` (backtick)
3. Run `npm install`
4. Run `npm run dev`
5. Click the localhost link in terminal to open in browser

## License

Free to use for personal and commercial projects.

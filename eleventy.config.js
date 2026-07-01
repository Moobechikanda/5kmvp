import eleventyPluginSyntaxHighlight from '@11ty/eleventy-plugin-syntaxhighlight';
import markdownIt from 'markdown-it';

export default function(eleventyConfig) {
  // Add plugins
  eleventyConfig.addPlugin(eleventyPluginSyntaxHighlight);

  // Passthrough copy for static assets
  eleventyConfig.addPassthroughCopy('src/assets');
  eleventyConfig.addPassthroughCopy({ 'public': '.' });

  // Custom Markdown parsing
  let markdownItOptions = { html: true, breaks: true, linkify: true };
  eleventyConfig.setLibrary('md', markdownIt(markdownItOptions));

  // Collections (aggregate posts from the unified content tree)
  const getPostDate = (item) => item?.data?.date || item?.data?.pubDate;

  eleventyConfig.addCollection('articles', function(collectionApi) {
    return collectionApi.getFilteredByGlob('src/content/posts/*.md')
      .filter(item => !item.data.draft)
      .sort((a, b) => new Date(getPostDate(b)) - new Date(getPostDate(a)));
  });

  eleventyConfig.addCollection('featuredArticles', function(collectionApi) {
    return collectionApi.getFilteredByGlob('src/content/posts/*.md')
      .filter(item => item.data.featured && !item.data.draft)
      .sort((a, b) => new Date(getPostDate(b)) - new Date(getPostDate(a)));
  });

  eleventyConfig.addCollection('allTags', function(collectionApi) {
    const articles = collectionApi.getFilteredByGlob('src/content/posts/*.md')
      .filter(item => !item.data.draft);
    const tags = new Set();
    articles.forEach(article => {
      if (article.data.tags) {
        article.data.tags.forEach(tag => tags.add(tag));
      }
    });
    return Array.from(tags).sort();
  });

  // Filters
  eleventyConfig.addFilter('limit', function(array, limit) {
    if (!Array.isArray(array)) return [];
    return array.slice(0, limit);
  });

  eleventyConfig.addFilter('slice', function(array, start, end) {
    if (!Array.isArray(array)) return [];
    return array.slice(start, end);
  });

  eleventyConfig.addFilter('filterByCategory', function(array, category) {
    if (!Array.isArray(array)) return [];
    return array.filter(item => item.data.category === category);
  });

  eleventyConfig.addFilter('filterByTag', function(array, tag) {
    if (!Array.isArray(array)) return [];
    return array.filter(item => item.data.tags && item.data.tags.includes(tag));
  });

  eleventyConfig.addFilter('getAllTags', function(articles) {
    const tags = new Set();
    articles.forEach(article => {
      if (article.data.tags) {
        article.data.tags.forEach(tag => tags.add(tag));
      }
    });
    return Array.from(tags).sort();
  });

  eleventyConfig.addFilter('findAuthor', function(authors, slug) {
    if (!Array.isArray(authors)) return null;
    return authors.find(a => a.slug === slug);
  });

  eleventyConfig.addFilter('findCategory', function(categories, slug) {
    if (!Array.isArray(categories)) return null;
    return categories.find(c => c.slug === slug);
  });

  eleventyConfig.addFilter('readingTime', function(content) {
    if (!content) return 0;
    const wordsPerMinute = 200;
    const words = content.split(/\s+/).length;
    return Math.ceil(words / wordsPerMinute);
  });

  eleventyConfig.addFilter('excerpt', function(content, length = 160) {
    if (!content) return '';
    const stripped = content.replace(/[#*`_>\-]/g, '').trim();
    if (stripped.length <= length) return stripped;
    return stripped.slice(0, length).trim() + '...';
  });

  eleventyConfig.addFilter('slugify', function(str) {
    if (!str) return '';
    return str.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
  });

  eleventyConfig.addFilter('capitalize', function(str) {
    if (!str) return '';
    return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
  });

  eleventyConfig.addFilter('dateFormat', function(date, format = 'long') {
    if (typeof date === 'string') {
      date = new Date(date);
    }
    if (!(date instanceof Date) || isNaN(date)) {
      return '';
    }
    if (format === 'long') {
      return date.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });
    }
    if (format === 'iso') {
      return date.toISOString().split('T')[0];
    }
    return date.toLocaleDateString('en-US');
  });

  // Shortcodes
  eleventyConfig.addShortcode('year', function() {
    return new Date().getFullYear();
  });

  return {
    dir: {
      input: 'src',
      output: '_site',
      includes: '_includes',
      layouts: '_layouts',
      data: '_data'
    },
    templateFormats: ['md', 'njk', 'html', '11ty.js'],
    markdownTemplateEngine: 'njk',
    htmlTemplateEngine: 'njk',
    dataTemplateEngine: 'json'
  };
}

function slugify(value) {
  return String(value || '')
    .toLowerCase()
    .trim()
    .normalize('NFKD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '');
}

export default {
  eleventyComputed: {
    permalink(data) {
      if (data.type) {
        const typeMap = {
          Guide: 'guides',
          Review: 'reviews',
          Comparison: 'comparisons',
          News: 'blog'
        };

        const basePath = typeMap[data.type] || 'posts';
        const slug = data.slug || data.page?.fileSlug || slugify(data.title) || 'post';
        return `/${basePath}/${slug}/`;
      }

      return data.permalink;
    }
  }
};

-- Categories table
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  image TEXT,
  color TEXT DEFAULT '#3b82f6',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Authors table
CREATE TABLE authors (
  id SERIAL PRIMARY KEY,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  bio TEXT NOT NULL,
  avatar TEXT NOT NULL,
  twitter TEXT,
  linkedin TEXT,
  website TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Articles table
CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  slug TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  content TEXT NOT NULL,
  category_id INTEGER REFERENCES categories(id) NOT NULL,
  author_id INTEGER REFERENCES authors(id) DEFAULT 1,
  image_url TEXT,
  image_alt TEXT,
  image_caption TEXT,
  tags TEXT[] DEFAULT '{}',
  featured BOOLEAN DEFAULT FALSE,
  draft BOOLEAN DEFAULT FALSE,
  rating DECIMAL(2,1) CHECK (rating >= 1 AND rating <= 5),
  difficulty TEXT CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')) DEFAULT 'beginner',
  reading_time INTEGER,
  pros TEXT[] DEFAULT '{}',
  cons TEXT[] DEFAULT '{}',
  keywords TEXT[] DEFAULT '{}',
  canonical TEXT,
  og_image TEXT,
  twitter_image TEXT,
  table_of_contents BOOLEAN DEFAULT TRUE,
  pub_date TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Article tools (tools reviewed in articles)
CREATE TABLE article_tools (
  id SERIAL PRIMARY KEY,
  article_id INTEGER REFERENCES articles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  url TEXT,
  pricing TEXT CHECK (pricing IN ('free', 'freemium', 'paid'))
);

-- Article FAQs
CREATE TABLE article_faqs (
  id SERIAL PRIMARY KEY,
  article_id INTEGER REFERENCES articles(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0
);

-- Enable RLS
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE authors ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE article_tools ENABLE ROW LEVEL SECURITY;
ALTER TABLE article_faqs ENABLE ROW LEVEL SECURITY;

-- Public read policies (for the frontend)
CREATE POLICY "select_categories" ON categories FOR SELECT TO authenticated, anon USING (true);
CREATE POLICY "select_authors" ON authors FOR SELECT TO authenticated, anon USING (true);
CREATE POLICY "select_articles" ON articles FOR SELECT TO authenticated, anon USING (draft = false OR auth.role() = 'service_role');
CREATE POLICY "select_article_tools" ON article_tools FOR SELECT TO authenticated, anon USING (true);
CREATE POLICY "select_article_faqs" ON article_faqs FOR SELECT TO authenticated, anon USING (true);

-- Authenticated write policies (for admin)
CREATE POLICY "insert_categories" ON categories FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "update_categories" ON categories FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "delete_categories" ON categories FOR DELETE TO authenticated USING (true);

CREATE POLICY "insert_authors" ON authors FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "update_authors" ON authors FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "delete_authors" ON authors FOR DELETE TO authenticated USING (true);

CREATE POLICY "insert_articles" ON articles FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "update_articles" ON articles FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "delete_articles" ON articles FOR DELETE TO authenticated USING (true);

CREATE POLICY "insert_article_tools" ON article_tools FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "update_article_tools" ON article_tools FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "delete_article_tools" ON article_tools FOR DELETE TO authenticated USING (true);

CREATE POLICY "insert_article_faqs" ON article_faqs FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "update_article_faqs" ON article_faqs FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "delete_article_faqs" ON article_faqs FOR DELETE TO authenticated USING (true);

-- Create indexes for performance
CREATE INDEX idx_articles_category ON articles(category_id);
CREATE INDEX idx_articles_author ON articles(author_id);
CREATE INDEX idx_articles_featured ON articles(featured) WHERE featured = true;
CREATE INDEX idx_articles_pub_date ON articles(pub_date DESC);
CREATE INDEX idx_articles_tags ON articles USING GIN(tags);
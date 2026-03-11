-- ========================================
-- NURTURE HER - SUPABASE DATABASE SETUP
-- ========================================
-- Run this SQL in your Supabase SQL Editor
-- Dashboard → SQL Editor → New Query → Paste & Run
-- ========================================

-- 1. Create Users Table
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('patient', 'doctor', 'psychiatrist', 'super_admin')),
  category TEXT,
  depression_level TEXT,
  last_assessment_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create Assessments Table
CREATE TABLE IF NOT EXISTS assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  user_email TEXT NOT NULL,
  category TEXT NOT NULL,
  answers JSONB NOT NULL,
  additional_notes TEXT,
  depression_level TEXT NOT NULL,
  review_status TEXT DEFAULT 'pending' CHECK (review_status IN ('pending', 'reviewed', 'approved')),
  review_notes TEXT,
  reviewed_by TEXT,
  reviewed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Create Mood Entries Table
CREATE TABLE IF NOT EXISTS mood_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  mood TEXT NOT NULL,
  emoji TEXT NOT NULL,
  note TEXT,
  activities TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Create Journal Entries Table
CREATE TABLE IF NOT EXISTS journal_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  mood TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Create Community Posts Table
CREATE TABLE IF NOT EXISTS community_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  content TEXT NOT NULL,
  anonymous BOOLEAN DEFAULT false,
  likes INTEGER DEFAULT 0,
  liked_by TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ========================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE mood_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE journal_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE community_posts ENABLE ROW LEVEL SECURITY;

-- ========================================
-- USERS TABLE POLICIES
-- ========================================

-- Allow users to read their own data
CREATE POLICY "Users can read own data" 
ON users FOR SELECT 
USING (auth.uid()::text = id::text);

-- Allow users to update their own data
CREATE POLICY "Users can update own data" 
ON users FOR UPDATE 
USING (auth.uid()::text = id::text);

-- Allow admins to read all users
CREATE POLICY "Admins can read all users" 
ON users FOR SELECT 
USING (
  EXISTS (
    SELECT 1 FROM users 
    WHERE id::text = auth.uid()::text 
    AND role IN ('super_admin', 'doctor', 'psychiatrist')
  )
);

-- Allow anyone to insert (for signup)
CREATE POLICY "Anyone can insert users" 
ON users FOR INSERT 
WITH CHECK (true);

-- ========================================
-- ASSESSMENTS TABLE POLICIES
-- ========================================

-- Users can read their own assessments
CREATE POLICY "Users can read own assessments" 
ON assessments FOR SELECT 
USING (auth.uid()::text = user_id::text);

-- Users can insert their own assessments
CREATE POLICY "Users can insert own assessments" 
ON assessments FOR INSERT 
WITH CHECK (auth.uid()::text = user_id::text);

-- Doctors/Admins can read all assessments
CREATE POLICY "Doctors can read all assessments" 
ON assessments FOR SELECT 
USING (
  EXISTS (
    SELECT 1 FROM users 
    WHERE id::text = auth.uid()::text 
    AND role IN ('super_admin', 'doctor', 'psychiatrist')
  )
);

-- Doctors/Admins can update assessments (for reviews)
CREATE POLICY "Doctors can update assessments" 
ON assessments FOR UPDATE 
USING (
  EXISTS (
    SELECT 1 FROM users 
    WHERE id::text = auth.uid()::text 
    AND role IN ('super_admin', 'doctor', 'psychiatrist')
  )
);

-- ========================================
-- MOOD ENTRIES TABLE POLICIES
-- ========================================

-- Users can manage their own moods
CREATE POLICY "Users can manage own moods" 
ON mood_entries FOR ALL 
USING (auth.uid()::text = user_id::text);

-- ========================================
-- JOURNAL ENTRIES TABLE POLICIES
-- ========================================

-- Users can manage their own journals
CREATE POLICY "Users can manage own journals" 
ON journal_entries FOR ALL 
USING (auth.uid()::text = user_id::text);

-- ========================================
-- COMMUNITY POSTS TABLE POLICIES
-- ========================================

-- Everyone can read community posts
CREATE POLICY "Everyone can read posts" 
ON community_posts FOR SELECT 
USING (true);

-- Users can insert their own posts
CREATE POLICY "Users can insert posts" 
ON community_posts FOR INSERT 
WITH CHECK (auth.uid()::text = user_id::text);

-- Users can update their own posts
CREATE POLICY "Users can update own posts" 
ON community_posts FOR UPDATE 
USING (auth.uid()::text = user_id::text);

-- Users can delete their own posts
CREATE POLICY "Users can delete own posts" 
ON community_posts FOR DELETE 
USING (auth.uid()::text = user_id::text);

-- ========================================
-- CREATE INDEXES FOR PERFORMANCE
-- ========================================

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_assessments_user_id ON assessments(user_id);
CREATE INDEX IF NOT EXISTS idx_assessments_created_at ON assessments(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_mood_entries_user_id ON mood_entries(user_id);
CREATE INDEX IF NOT EXISTS idx_mood_entries_created_at ON mood_entries(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_journal_entries_user_id ON journal_entries(user_id);
CREATE INDEX IF NOT EXISTS idx_journal_entries_created_at ON journal_entries(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_community_posts_created_at ON community_posts(created_at DESC);

-- ========================================
-- INSERT DEMO DATA (OPTIONAL)
-- ========================================

-- Demo Patient User
INSERT INTO users (id, email, name, role, created_at)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'patient@demo.com',
  'Demo Patient',
  'patient',
  NOW()
) ON CONFLICT (email) DO NOTHING;

-- Demo Doctor User
INSERT INTO users (id, email, name, role, created_at)
VALUES (
  '00000000-0000-0000-0000-000000000002',
  'doctor@demo.com',
  'Dr. Sarah Johnson',
  'doctor',
  NOW()
) ON CONFLICT (email) DO NOTHING;

-- Demo Admin User
INSERT INTO users (id, email, name, role, created_at)
VALUES (
  '00000000-0000-0000-0000-000000000003',
  'admin@demo.com',
  'Admin User',
  'super_admin',
  NOW()
) ON CONFLICT (email) DO NOTHING;

-- ========================================
-- SUCCESS MESSAGE
-- ========================================

DO $$
BEGIN
  RAISE NOTICE '✅ Database setup complete!';
  RAISE NOTICE '📊 Tables created: users, assessments, mood_entries, journal_entries, community_posts';
  RAISE NOTICE '🔒 Row Level Security enabled';
  RAISE NOTICE '👥 Demo users created';
  RAISE NOTICE '🚀 Ready to use!';
END $$;

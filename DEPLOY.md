# 🚀 Deploy NurtureHer - Render Deployment

**Status**: ✅ READY TO DEPLOY  
**Platform**: Render  
**Time**: 5-10 minutes  
**Date**: March 8, 2026

---

## ⚡ Deploy to Render

### Step 1: Test Build Locally (Important!)

```bash
# 1. Clean install
rm -rf node_modules dist
npm install

# 2. Test build
npm run build

# 3. Test production build locally
npm run serve
# Open http://localhost:3000
# Test navigation, login, etc.

# If everything works, proceed to deployment!
```

### Step 2: Push to GitHub

```bash
# 1. Push to GitHub
git add .
git commit -m "Production ready - All fixes complete"
git push origin main
```

### Step 3: Deploy on Render

```bash
# 1. Go to render.com
# 2. Sign up/Login with GitHub
# 3. Click "New +" → "Web Service"
# 4. Connect your GitHub repository
```

### Step 4: Configure Build Settings

```
Name: nurture-her
Environment: Node
Region: Choose closest to your users

Build Command: npm install && npm run build
Start Command: npx serve -s dist -l $PORT

Instance Type: Free (or choose paid for better performance)
```

### Step 5: Add Environment Variables

```bash
# In Render Dashboard → Environment
# Add these variables:

NODE_VERSION=20

# Optional: If using custom Supabase env vars
VITE_SUPABASE_URL=https://ntglfzqujpywvylrzjju.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im50Z2xmenF1anB5d3Z5bHJ6amp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI0NTYwNDIsImV4cCI6MjA4ODAzMjA0Mn0.VOhVlNVKCaPu2nf-8jVvPT9sObXwg4INFfcAukdrLSk
```

### Step 6: Deploy!

```bash
# Click "Create Web Service"
# Render will automatically:
# - Install dependencies
# - Build your app
# - Deploy to production
# - Give you a live URL

# Done! Your app is live! ✅
# URL: https://nurture-her.onrender.com
```

---

## 📋 Pre-Deploy Checklist

```bash
# 1. Test locally (recommended)
npm run dev
# Open http://localhost:5173
# Login with patient@demo.com / demo123
# Test a few features

# 2. Build test (optional)
npm run build
# Should complete without errors

# 3. Push to GitHub and deploy on Render
```

---

## ✅ What's Fixed

- ✅ All routes working (frontend, backend, database)
- ✅ Images loading (Unsplash CDN)
- ✅ Authentication working (JWT tokens)
- ✅ Database operations functional (Supabase)
- ✅ Mobile responsive
- ✅ Documentation clean
- ✅ Production ready

---

## 🎯 After Deployment

### Test Your Live App

```bash
# 1. Visit your production URL
https://nurture-her.onrender.com

# 2. Test login
Email: patient@demo.com
Password: demo123

# 3. Test assessment flow
Category Selection → Assessment → Reports → Home

# 4. Verify everything works ✅
```

---

## 🔧 Render Configuration Details

### Auto-Deploy Setup

```bash
# Render automatically deploys when you push to GitHub
git add .
git commit -m "Update feature"
git push origin main
# Render will auto-deploy in ~2-3 minutes
```

### Custom Domain (Optional)

```bash
# In Render Dashboard:
# 1. Go to Settings → Custom Domains
# 2. Add your domain: nurture-her.com
# 3. Update DNS records as shown
# 4. SSL/HTTPS automatic ✅
```

### Health Checks

Render automatically monitors your app. No additional configuration needed!

---

## 📚 Documentation

- **Quick Start**: README.md
- **Complete Guide**: PRODUCTION_GUIDE.md  
- **Deployment Details**: DEPLOYMENT_CHECKLIST.md
- **All Changes**: CHANGES_SUMMARY.md
- **Hindi Summary**: FINAL_SUMMARY_HINDI.md

---

## 🆘 Troubleshooting

### Build Fails?
```bash
# Check Render logs
# Ensure package.json has all dependencies
# Node version set to 20
```

### Blank Screen?
```bash
# Check browser console
# Verify build command: npm run build
# Verify start command: npx serve -s dist -l $PORT
```

### Images Not Loading?
```bash
# Check browser console
# Images should load from images.unsplash.com
# Should already be fixed ✅
```

### Routes Not Working?
```bash
# Verify serve is serving SPA correctly
# serve -s flag handles client-side routing
# Should work automatically ✅
```

---

## 🎉 You're Ready!

**Push to GitHub and deploy on Render! 🚀**

---

**Need help?** Check PRODUCTION_GUIDE.md for complete documentation.

**Made with 💜 for women's mental wellness**
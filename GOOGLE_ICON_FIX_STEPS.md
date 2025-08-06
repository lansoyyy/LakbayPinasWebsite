# Steps to Force Google to Update Your Website Icon

## After replacing your icons:

### 1. Clear and Test Locally
```powershell
# Clear Flutter build cache
flutter clean
flutter pub get

# Build for web
flutter build web

# Test locally
flutter run -d chrome
```

### 2. Deploy to Production
- Upload your updated `web/` folder to your hosting provider
- Make sure the new icons are accessible at:
  - https://discover-philippines.com/favicon.png
  - https://discover-philippines.com/icons/Icon-192.png
  - https://discover-philippines.com/icons/Icon-512.png

### 3. Force Google to Re-crawl
1. **Google Search Console**: 
   - Go to https://search.google.com/search-console
   - Add your website if not already added
   - Use "URL Inspection" tool
   - Enter your homepage URL
   - Click "Request Indexing"

2. **Clear Cache**:
   - Clear your browser cache
   - Test in incognito mode
   - Use different browsers to verify

### 4. Additional SEO Steps
- Update your sitemap lastmod date
- Submit sitemap to Google Search Console
- Share your updated website on social media (forces re-crawl)

### 5. Timeline
- Local changes: Immediate
- Google search results: 1-7 days typically
- Social media previews: 1-24 hours

## Verification
Check if your new icon appears:
1. Open https://discover-philippines.com in incognito mode
2. Look at browser tab icon
3. Check Google search results after a few days
4. Test social media sharing (Facebook, Twitter)

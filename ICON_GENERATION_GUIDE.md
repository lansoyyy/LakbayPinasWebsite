# Alternative: Manual Icon Generation Guide

## If you don't want to install ImageMagick, you can use online tools:

### Option 1: Use Favicon.io (Recommended)
1. Go to https://favicon.io/favicon-converter/
2. Upload your `assets/images/icon.png` file
3. Download the generated package
4. Extract and copy these files to your web folder:
   - Copy `favicon.ico` to `web/favicon.ico` (optional)
   - Copy `favicon-32x32.png` to `web/favicon.png`
   - Copy `android-chrome-192x192.png` to `web/icons/Icon-192.png`
   - Copy `android-chrome-512x512.png` to `web/icons/Icon-512.png`

### Option 2: Use PWA Asset Generator
1. Go to https://www.pwabuilder.com/imageGenerator
2. Upload your icon
3. Download the generated assets
4. Replace the files in `web/icons/` folder

### Required Icon Sizes:
- favicon.png: 32x32 pixels
- Icon-192.png: 192x192 pixels  
- Icon-512.png: 512x512 pixels
- Icon-maskable-192.png: 192x192 pixels (with padding for safe area)
- Icon-maskable-512.png: 512x512 pixels (with padding for safe area)

### After replacing icons:
1. Clear browser cache
2. Test locally: flutter build web && flutter run -d chrome
3. Deploy to production
4. Request Google to re-crawl via Search Console

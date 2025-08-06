# PowerShell script to generate web icons from your custom icon
# Make sure you have ImageMagick installed: https://imagemagick.org/script/download.php#windows

Write-Host "Generating web icons from your custom icon..." -ForegroundColor Green

# Check if ImageMagick is installed
$magickPath = Get-Command "magick" -ErrorAction SilentlyContinue
if (-not $magickPath) {
    Write-Host "ImageMagick not found! Please install ImageMagick from https://imagemagick.org/script/download.php#windows" -ForegroundColor Red
    Write-Host "After installation, restart PowerShell and run this script again." -ForegroundColor Yellow
    exit 1
}

# Source icon path
$sourceIcon = "assets\images\icon.png"
$webIconsDir = "web\icons"

# Check if source icon exists
if (-not (Test-Path $sourceIcon)) {
    Write-Host "Source icon not found at: $sourceIcon" -ForegroundColor Red
    exit 1
}

# Create icons directory if it doesn't exist
if (-not (Test-Path $webIconsDir)) {
    New-Item -ItemType Directory -Path $webIconsDir -Force
}

Write-Host "Generating favicon.png (32x32)..." -ForegroundColor Cyan
magick "$sourceIcon" -resize 32x32 "web\favicon.png"

Write-Host "Generating Icon-192.png..." -ForegroundColor Cyan
magick "$sourceIcon" -resize 192x192 "$webIconsDir\Icon-192.png"

Write-Host "Generating Icon-512.png..." -ForegroundColor Cyan
magick "$sourceIcon" -resize 512x512 "$webIconsDir\Icon-512.png"

Write-Host "Generating maskable icons..." -ForegroundColor Cyan
# For maskable icons, we need to add padding to ensure the icon looks good when masked
magick "$sourceIcon" -resize 154x154 -gravity center -extent 192x192 -background transparent "$webIconsDir\Icon-maskable-192.png"
magick "$sourceIcon" -resize 410x410 -gravity center -extent 512x512 -background transparent "$webIconsDir\Icon-maskable-512.png"

Write-Host "Icons generated successfully!" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Test your website locally" -ForegroundColor White
Write-Host "2. Deploy to your hosting provider" -ForegroundColor White
Write-Host "3. Use Google Search Console to request re-indexing" -ForegroundColor White
Write-Host "4. Clear browser cache and test" -ForegroundColor White

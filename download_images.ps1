# Download Images Script for Flutter Shop App
Add-Type -AssemblyName System.Drawing

# Function to create placeholder image
function Create-PlaceholderImage {
    param(
        [string]$FilePath,
        [string]$Text,
        [System.Drawing.Color]$BackgroundColor,
        [System.Drawing.Color]$TextColor,
        [int]$Width = 300,
        [int]$Height = 300
    )
    
    Write-Host "Creating image: $Text" -ForegroundColor Green
    
    $bitmap = New-Object System.Drawing.Bitmap($Width, $Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    
    # Set high quality rendering
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    
    # Fill background
    $graphics.Clear($BackgroundColor)
    
    # Create font and brush
    $font = New-Object System.Drawing.Font('Arial', 18, [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush($TextColor)
    
    # Measure text to center it
    $textSize = $graphics.MeasureString($Text, $font)
    $x = ($Width - $textSize.Width) / 2
    $y = ($Height - $textSize.Height) / 2
    
    # Draw text
    $graphics.DrawString($Text, $font, $brush, $x, $y)
    
    # Save image
    $bitmap.Save($FilePath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    # Cleanup
    $graphics.Dispose()
    $bitmap.Dispose()
    $font.Dispose()
    $brush.Dispose()
    
    Write-Host "✓ Created: $FilePath" -ForegroundColor Cyan
}

# Create directories if they don't exist
$directories = @(
    "assets\images\products",
    "assets\images\placeholders",
    "assets\images\banners",
    "assets\images\icons", 
    "assets\images\logos"
)

foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        Write-Host "Created directory: $dir" -ForegroundColor Yellow
    }
}

Write-Host "`nGenerating product images..." -ForegroundColor Magenta

# Product images
Create-PlaceholderImage -FilePath "assets\images\products\samsung_galaxy.png" -Text "Samsung Galaxy" -BackgroundColor ([System.Drawing.Color]::FromArgb(66, 133, 244)) -TextColor ([System.Drawing.Color]::White)

Create-PlaceholderImage -FilePath "assets\images\products\macbook_air.png" -Text "MacBook Air" -BackgroundColor ([System.Drawing.Color]::FromArgb(128, 128, 128)) -TextColor ([System.Drawing.Color]::White)

Create-PlaceholderImage -FilePath "assets\images\products\airpods.png" -Text "AirPods" -BackgroundColor ([System.Drawing.Color]::White) -TextColor ([System.Drawing.Color]::Black)

Create-PlaceholderImage -FilePath "assets\images\products\apple_watch.png" -Text "Apple Watch" -BackgroundColor ([System.Drawing.Color]::Black) -TextColor ([System.Drawing.Color]::White)

Create-PlaceholderImage -FilePath "assets\images\products\ipad_pro.png" -Text "iPad Pro" -BackgroundColor ([System.Drawing.Color]::FromArgb(192, 192, 192)) -TextColor ([System.Drawing.Color]::Black)

Create-PlaceholderImage -FilePath "assets\images\products\canon_dslr.png" -Text "Canon DSLR" -BackgroundColor ([System.Drawing.Color]::FromArgb(64, 64, 64)) -TextColor ([System.Drawing.Color]::White)

# Additional product images found in reviews page
Create-PlaceholderImage -FilePath "assets\images\products\samsung_s23.jpg" -Text "Samsung S23" -BackgroundColor ([System.Drawing.Color]::FromArgb(34, 139, 34)) -TextColor ([System.Drawing.Color]::White)

Create-PlaceholderImage -FilePath "assets\images\products\lenovo_thinkpad.jpg" -Text "Lenovo ThinkPad" -BackgroundColor ([System.Drawing.Color]::FromArgb(220, 20, 60)) -TextColor ([System.Drawing.Color]::White)

Create-PlaceholderImage -FilePath "assets\images\products\airpods.jpg" -Text "AirPods" -BackgroundColor ([System.Drawing.Color]::FromArgb(255, 165, 0)) -TextColor ([System.Drawing.Color]::Black)

Create-PlaceholderImage -FilePath "assets\images\products\mi_watch.jpg" -Text "Mi Watch" -BackgroundColor ([System.Drawing.Color]::FromArgb(75, 0, 130)) -TextColor ([System.Drawing.Color]::White)

Create-PlaceholderImage -FilePath "assets\images\products\ipad_air.jpg" -Text "iPad Air" -BackgroundColor ([System.Drawing.Color]::FromArgb(30, 144, 255)) -TextColor ([System.Drawing.Color]::White)

Write-Host "`nGenerating placeholder images..." -ForegroundColor Magenta

# User avatar placeholder
Create-PlaceholderImage -FilePath "assets\images\placeholders\user_avatar.png" -Text "USER" -BackgroundColor ([System.Drawing.Color]::FromArgb(240, 240, 240)) -TextColor ([System.Drawing.Color]::FromArgb(120, 120, 120))

Write-Host "`n✅ All images created successfully!" -ForegroundColor Green
Write-Host "📁 Total images created: 12" -ForegroundColor Green

# List created files
Write-Host "`nCreated files:" -ForegroundColor Yellow
Get-ChildItem -Path "assets\images" -Recurse -File | ForEach-Object {
    $relativePath = $_.FullName.Replace((Get-Location).Path + "\", "")
    Write-Host "  - $relativePath" -ForegroundColor Cyan
}

Write-Host "`n🚀 Ready to run Flutter app!" -ForegroundColor Green

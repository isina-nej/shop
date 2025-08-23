# Simple Image Generator Script
Add-Type -AssemblyName System.Drawing

Write-Host "Creating placeholder images for Flutter shop app..." -ForegroundColor Green

# Create directories
$dirs = @("assets\images\products", "assets\images\placeholders", "assets\images\banners", "assets\images\icons", "assets\images\logos")
foreach ($dir in $dirs) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        Write-Host "Created directory: $dir" -ForegroundColor Yellow
    }
}

# Function to create image
function New-PlaceholderImage($path, $text, $bgColor, $textColor) {
    $bitmap = New-Object System.Drawing.Bitmap(300, 300)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.Clear($bgColor)
    $font = New-Object System.Drawing.Font("Arial", 18, [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush($textColor)
    $textSize = $graphics.MeasureString($text, $font)
    $x = (300 - $textSize.Width) / 2
    $y = (300 - $textSize.Height) / 2
    $graphics.DrawString($text, $font, $brush, $x, $y)
    $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
    $font.Dispose()
    $brush.Dispose()
    Write-Host "Created: $path" -ForegroundColor Cyan
}

# Create all images
Write-Host "Generating images..." -ForegroundColor Magenta

New-PlaceholderImage "assets\images\products\samsung_galaxy.png" "Samsung Galaxy" ([System.Drawing.Color]::FromArgb(66,133,244)) ([System.Drawing.Color]::White)
New-PlaceholderImage "assets\images\products\macbook_air.png" "MacBook Air" ([System.Drawing.Color]::Gray) ([System.Drawing.Color]::White)
New-PlaceholderImage "assets\images\products\airpods.png" "AirPods" ([System.Drawing.Color]::White) ([System.Drawing.Color]::Black)
New-PlaceholderImage "assets\images\products\apple_watch.png" "Apple Watch" ([System.Drawing.Color]::Black) ([System.Drawing.Color]::White)
New-PlaceholderImage "assets\images\products\ipad_pro.png" "iPad Pro" ([System.Drawing.Color]::Silver) ([System.Drawing.Color]::Black)
New-PlaceholderImage "assets\images\products\canon_dslr.png" "Canon DSLR" ([System.Drawing.Color]::FromArgb(64,64,64)) ([System.Drawing.Color]::White)
New-PlaceholderImage "assets\images\products\samsung_s23.jpg" "Samsung S23" ([System.Drawing.Color]::Green) ([System.Drawing.Color]::White)
New-PlaceholderImage "assets\images\products\lenovo_thinkpad.jpg" "Lenovo ThinkPad" ([System.Drawing.Color]::Red) ([System.Drawing.Color]::White)
New-PlaceholderImage "assets\images\products\airpods.jpg" "AirPods" ([System.Drawing.Color]::Orange) ([System.Drawing.Color]::Black)
New-PlaceholderImage "assets\images\products\mi_watch.jpg" "Mi Watch" ([System.Drawing.Color]::Purple) ([System.Drawing.Color]::White)
New-PlaceholderImage "assets\images\products\ipad_air.jpg" "iPad Air" ([System.Drawing.Color]::Blue) ([System.Drawing.Color]::White)
New-PlaceholderImage "assets\images\placeholders\user_avatar.png" "USER" ([System.Drawing.Color]::LightGray) ([System.Drawing.Color]::DarkGray)

Write-Host "All images created successfully!" -ForegroundColor Green

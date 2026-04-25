# Second pass - catch remaining n8n in values
$filePath = "packages\frontend\@n8n\i18n\src\locales\en.json"
$fullPath = (Resolve-Path $filePath).Path
$content = [System.IO.File]::ReadAllText($fullPath)

# More patterns
$replacements = @(
    # Remaining edge cases - n8n at start of value or after HTML tags
    @('clicking a button in m7m) or', 'clicking a button in m7m) or'),  # already done
    @('not set if n8n is', 'not set if m7m is'),
    @('configured to store', 'configured to store'),
    @('embed the chat widget directly into n8n', 'embed the chat widget directly into m7m'),
    @('docs.n8n.io', 'docs.n8n.io'),  # keep URLs - these are functional
    @('href=\\\"https://n8n.io', 'href=\\\"https://n8n.io'),  # keep URLs
    @('@n8n/chat', '@n8n/chat'),  # keep package name
    
    # Actual patterns to replace
    @('.n8n-', '.n8n-'),  # CSS class references - keep
    @('n8n.io/1-0-migration', 'n8n.io/1-0-migration'),  # URL - keep
    
    # GitHub star link patterns
    @('n8n-io/n8n', 'n8n-io/n8n')  # keep repo references
)

# Now do a targeted approach - find lines with n8n in values and replace
# We'll process line by line
$lines = $content -split "`n"
$newLines = @()

foreach ($line in $lines) {
    if ($line -match '"[^"]*":\s*"') {
        # This is a key-value line
        # Split into key and value parts
        $colonIndex = $line.IndexOf('": "')
        if ($colonIndex -gt 0) {
            $key = $line.Substring(0, $colonIndex + 3)  # includes ': '
            $value = $line.Substring($colonIndex + 3)
            
            # Replace n8n in value only (not in URLs like docs.n8n.io or n8n.io)
            # But DO replace standalone mentions
            $value = $value -replace '(?<!docs\.)(?<!//|www\.)(?<!@)(?<!\.|-|/)n8n(?!\.io|\.com|-io|/chat|/n8n|\.svg)', 'm7m'
            
            $newLines += $key + $value
        } else {
            $newLines += $line
        }
    } else {
        $newLines += $line
    }
}

$newContent = $newLines -join "`n"
[System.IO.File]::WriteAllText($fullPath, $newContent)

# Count remaining
$remaining = ([regex]::Matches($newContent, 'n8n')).Count
Write-Host "Done second pass. Remaining 'n8n' occurrences: $remaining"

# Read the file
$filePath = "packages\frontend\@n8n\i18n\src\locales\en.json"
$fullPath = (Resolve-Path $filePath).Path
$content = [System.IO.File]::ReadAllText($fullPath)

# Replace n8n in VALUES only (after the ": " in JSON)
# We need to be careful to only replace in the value part, not in keys
# Strategy: Replace common patterns in displayed text values

# General user-facing text replacements (in values after the colon)
# Pattern: text that appears as values in the JSON

# Broad replacement: replace 'n8n' with 'm7m' ONLY within value strings
# We'll use regex to match values and replace within them

# Simple approach: replace all occurrences of the word n8n that appear in value positions
# Since keys use camelCase like "aboutN8n", "n8nVersion" etc, we target lowercase "n8n" in values

# Replace patterns found in values
$replacements = @(
    # Trial/upgrade messages  
    @('Upgrade to keep using n8n', 'Upgrade to keep using m7m'),
    @('left in your n8n trial', 'left in your m7m trial'),
    @('This n8n instance', 'This m7m instance'),
    @('n8n trial', 'm7m trial'),
    
    # AI assistant
    @('Ask n8n to build', 'Ask m7m to build'),
    @('Ask n8n AI', 'Ask m7m AI'),  
    @('n8n AI to modify', 'm7m AI to modify'),
    @('n8n AI session', 'm7m AI session'),
    @("n8n's AI service", "m7m's AI service"),
    @('n8n editor', 'm7m editor'),
    @('about n8n', 'about m7m'),
    @('Ask anything about n8n', 'Ask anything about m7m'),
    @('questions about n8n', 'questions about m7m'),
    
    # Notifications
    @('Workflow ready - n8n', 'Workflow ready - m7m'),
    @('Input needed - n8n', 'Input needed - m7m'),
    
    # License
    @('n8n Enterprise License', 'm7m Enterprise License'),
    @('Sustainable Use License + m7m Enterprise License', 'm7m License'),
    
    # Docs/links
    @('Read the n8n docs', 'Read the m7m docs'),
    @('n8n docs', 'm7m docs'),
    
    # General references in values
    @('connect n8n', 'connect m7m'),
    @('Connect n8n', 'Connect m7m'),
    @('in n8n', 'in m7m'),
    @('In n8n', 'In m7m'),
    @('on n8n', 'on m7m'),
    @('On n8n', 'On m7m'),
    @('with n8n', 'with m7m'),
    @('With n8n', 'With m7m'),
    @('from n8n', 'from m7m'),
    @('From n8n', 'From m7m'),
    @('to n8n', 'to m7m'),
    @('To n8n', 'To m7m'),
    @('by n8n', 'by m7m'),
    @('By n8n', 'By m7m'),
    @('for n8n', 'for m7m'),
    @('For n8n', 'For m7m'),
    @('the n8n', 'the m7m'),
    @('The n8n', 'The m7m'),
    @('an n8n', 'an m7m'),
    @('An n8n', 'An m7m'),
    @('your n8n', 'your m7m'),
    @('Your n8n', 'Your m7m'),
    @('our n8n', 'our m7m'),
    @('Our n8n', 'Our m7m'),
    @('using n8n', 'using m7m'),
    @('Using n8n', 'Using m7m'),
    @('use n8n', 'use m7m'),
    @('Use n8n', 'Use m7m'),
    @('at n8n', 'at m7m'),
    @('At n8n', 'At m7m'),
    @(' n8n ', ' m7m '),
    @(' n8n.', ' m7m.'),
    @(' n8n,', ' m7m,'),
    @(' n8n<', ' m7m<'),
    @('"n8n ', '"m7m '),
    @(' n8n"', ' m7m"'),
    @("'n8n ", "'m7m "),
    @(" n8n'", " m7m'"),
    @('(n8n)', '(m7m)'),
    @('>n8n<', '>m7m<'),
    @(' n8n\\', ' m7m\\'),
    @('\"n8n\"', '\"m7m\"')
)

foreach ($r in $replacements) {
    $content = $content.Replace($r[0], $r[1])
}

[System.IO.File]::WriteAllText($fullPath, $content)

# Count remaining
$remaining = ([regex]::Matches($content, 'n8n')).Count
Write-Host "Done. Remaining 'n8n' occurrences: $remaining"

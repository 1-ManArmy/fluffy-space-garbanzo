import os
import re
from pathlib import Path

def fix_section_file(file_path):
    """Convert full HTML document to section component"""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Skip if already processed (doesn't start with DOCTYPE)
    if not content.strip().startswith('<!DOCTYPE'):
        print(f"Already processed: {file_path.name}")
        return False
    
    # Extract content between <body> and </body>
    body_match = re.search(r'<body[^>]*>(.*?)</body>', content, re.DOTALL)
    if not body_match:
        print(f"No body tag found in {file_path.name}")
        return False
    
    section_content = body_match.group(1).strip()
    
    # Get section name from filename
    section_name = file_path.stem.replace('_', '-')
    
    # Create proper section component
    new_content = f"""<!-- {section_name.title()} Component -->
<section class="{section_name}">
{section_content}
</section>
<!-- End {section_name.title()} -->"""
    
    # Write back to file
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f"Fixed: {file_path.name}")
    return True

# Fix all section files
sections_dir = Path("api/templates/home/sections")
if sections_dir.exists():
    for html_file in sections_dir.glob("*.html"):
        if html_file.name not in ['hero_section.html', 'call_to_action_section.html']:  # Already fixed
            fix_section_file(html_file)
else:
    print("Sections directory not found")

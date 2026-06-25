import os, re

base = r'C:\Users\thekh\OneDrive\Documents\EXERCICE WEB\BENJI COIFFURE\barber_pro\lib\ui'
files = []
for root, dirs, filenames in os.walk(base):
    for f in filenames:
        if f.endswith('.dart'):
            files.append(os.path.join(root, f))

annuler_style = """style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.hovered)) return Colors.red;
                return Colors.white;
              }),
              overlayColor: WidgetStateProperty.all(Colors.red.withOpacity(0.08)),
            ),"""

for filepath in files:
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    modified = False

    # Pattern 1: one-liner TextButton Annuler
    old1 = "TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),"
    new1 = """TextButton(
            onPressed: () => Navigator.pop(context),
            %s
            child: const Text('Annuler'),
          ),""" % annuler_style
    if old1 in content:
        content = content.replace(old1, new1)
        modified = True

    # Pattern 2: multi-line TextButton with child: const Text('Annuler')
    # Find TextButton blocks where child is 'Annuler'
    # We look for TextButton( ... child: const Text('Annuler'), ) and insert style
    def add_style_to_annuler(m):
        block = m.group(0)
        if 'foregroundColor' in block:
            return block  # already done
        # Insert style before child:
        return block.replace(
            "child: const Text('Annuler'),",
            annuler_style + "\n            child: const Text('Annuler'),"
        )

    # Multi-line replacement
    new_content = re.sub(
        r'TextButton\(\s*\n\s*onPressed:[^\n]+\n\s*child:\s*const\s*Text\(\'Annuler\'\),\s*\n\s*\)',
        add_style_to_annuler,
        content
    )
    if new_content != content:
        content = new_content
        modified = True

    # Pattern 3: TextButton with onPressed inline and child on next lines
    # Match: TextButton(\n  onPressed: ...\n  child: const Text('Annuler'),\n),
    def add_style_multiline(m):
        block = m.group(0)
        if 'foregroundColor' in block:
            return block
        return block.replace(
            "child: const Text('Annuler'),",
            annuler_style + "\n            child: const Text('Annuler'),"
        )

    new_content2 = re.sub(
        r'TextButton\(\s*\n[^\)]*?child:\s*const\s*Text\(\'Annuler\'\),\s*\n\s*\)',
        add_style_multiline,
        content,
        flags=re.DOTALL
    )
    if new_content2 != content:
        content = new_content2
        modified = True

    # Pattern 4: TextButton without const (like in settings)
    def add_style_no_const(m):
        block = m.group(0)
        if 'foregroundColor' in block:
            return block
        return block.replace(
            "child: Text('Annuler'),",
            annuler_style + "\n                              child: Text('Annuler'),"
        )

    new_content3 = re.sub(
        r'TextButton\(\s*\n[^\)]*?child:\s*Text\(\'Annuler\'\),\s*\n\s*\)',
        add_style_no_const,
        content,
        flags=re.DOTALL
    )
    if new_content3 != content:
        content = new_content3
        modified = True

    if modified:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'Updated: {os.path.basename(filepath)}')

print('All done!')

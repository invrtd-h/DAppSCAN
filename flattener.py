import os
import re
import sys

class SolidityFlattener:
    def __init__(self):
        # prevent duplicated imports
        self.processed_files = set()
        
        self.import_pattern = re.compile(r'import.*["\']([^"\']+)["\'];')
        self.pragma_pattern = re.compile(r'^\s*pragma\s+solidity')
        self.license_pattern = re.compile(r'^\s*//\s*SPDX-License-Identifier:')

    def flatten(self, input_file_path):
        abs_path = os.path.abspath(input_file_path)
        if not os.path.exists(abs_path):
            raise FileNotFoundError(f"File not found: {input_file_path}")

        return self._process_file(abs_path, is_root=True)

    def _process_file(self, file_path, is_root=False):
        if file_path in self.processed_files:
            return ""

        self.processed_files.add(file_path)
        
        content = []
        base_dir = os.path.dirname(file_path)

        with open(file_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()

        content.append(f"// --- START: {os.path.basename(file_path)} ---\n")

        for line in lines:
            import_match = self.import_pattern.search(line)
            if import_match:
                rel_path = import_match.group(1)
                imported_file_path = os.path.abspath(os.path.join(base_dir, rel_path))
                flattened_import = self._process_file(imported_file_path, is_root=False)
                content.append(flattened_import)
                continue
            if not is_root:
                if self.pragma_pattern.match(line) or self.license_pattern.match(line):
                    continue
            content.append(line)

        content.append(f"// --- END: {os.path.basename(file_path)} ---\n")
        return "".join(content)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Example: uv run flattener.py ./contracts/MyToken.sol ./flattened/MyToken_flat.sol")
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2]

    flattener = SolidityFlattener()
    flattened_code = flattener.flatten(input_path)

    output_dir = os.path.dirname(os.path.abspath(output_path))
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir)

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(flattened_code)
    
    print(f"Succeed, file generated: {output_path}")
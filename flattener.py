import os
import re
import sys


def get_version(source_code) -> str | None:
    pattern = re.compile(r'^\s*pragma\s+solidity\s+([^;]+)\s*;', re.MULTILINE)
    
    match = pattern.search(source_code)
    
    if match:
        ret: str = match.group(1).strip()
        ret = ret.replace("^", "").replace("=", "").replace(">", "").replace("<", "")
        return ret
    return None


class SolidityFlattener:
    def __init__(self):
        # prevent duplicated imports
        self.processed_files = set()
        
        self.import_pattern = re.compile(r'import.*["\']([^"\']+)["\'];')
        self.pragma_pattern = re.compile(r'^\s*pragma\s+solidity')
        self.license_pattern = re.compile(r'^\s*//\s*SPDX-License-Identifier:')

    def flatten(self, input_file_path):
        with open(input_file_path, 'r', encoding='utf-8') as f:
            source_code = f.read()
        version = get_version(source_code)
        abs_path = os.path.abspath(input_file_path)
        if not os.path.exists(abs_path):
            raise FileNotFoundError(f"File not found: {input_file_path}")

        return self._process_file(abs_path, version, is_root=True)

    def _process_file(self, file_path, version, is_root=False):
        if "@openzeppelin" in file_path:
            if version >= "0.8.10":
                file_path = os.path.abspath("./openzeppelin-contracts") + file_path.split("@openzeppelin")[1]
            elif version >= "0.6.0" and version <= "0.7.6":
                file_path = os.path.abspath("./openzeppelin-contracts-3.4.0") + file_path.split("@openzeppelin")[1]
        
        if file_path in self.processed_files:
            return ""

        self.processed_files.add(file_path)
        
        content = []
        base_dir = os.path.dirname(file_path)

        if "@openzeppelin" in file_path:
            raise FileNotFoundError("@openzeppelin")
        else:
            with open(file_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()

        content.append(f"\n// --- START: {os.path.basename(file_path)} ---\n")

        for line in lines:
            import_match = self.import_pattern.search(line)
            if import_match:
                rel_path = import_match.group(1)
                imported_file_path = os.path.abspath(os.path.join(base_dir, rel_path))
                flattened_import = self._process_file(imported_file_path, version, is_root=False)
                content.append(flattened_import)
                continue
            if not is_root:
                if self.pragma_pattern.match(line) or self.license_pattern.match(line):
                    continue
            content.append(line)

        content.append(f"\n// --- END: {os.path.basename(file_path)} ---\n")
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
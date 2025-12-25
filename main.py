import json
import os


def find_json_files(root_dir):
    json_files = []
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith('.json'):
                full_path = os.path.join(root, file)
                json_files.append(full_path)
                
    return json_files


def main():
    ls = sorted(os.listdir("DAppSCAN-source/SWCsource"))
    for dir in ls:
        reent_found = False
        ls2 = sorted(os.listdir(f"DAppSCAN-source/SWCsource/{dir}"))
        for dir2 in ls2:
            jsons = find_json_files(f"DAppSCAN-source/SWCsource/{dir}/{dir2}")
            for json_filename in jsons:
                with open(json_filename, "r") as fp:
                    j = json.load(fp)
                swc_list = j["SWCs"]
                for swc in swc_list:
                    vuln = swc["category"]
                    if vuln == 'SWC-107-Reentrancy':
                        reent_found = True
            assert len(jsons) >= 1
        if reent_found:
            print(dir)
            


if __name__ == "__main__":
    main()

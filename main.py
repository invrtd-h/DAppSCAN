import json
import os
import numpy as np
import pandas as pd


def find_json_files(root_dir):
    json_files = []
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith('.json'):
                full_path = os.path.join(root, file)
                json_files.append(full_path)
                
    return json_files


def get_reentrant_contracts():
    print("id,loc")
    ls = sorted(os.listdir("DAppSCAN-source/SWCsource"))
    cnt = 0
    for dir in ls:
        reent_found = False
        ls2 = sorted(os.listdir(f"DAppSCAN-source/SWCsource/{dir}"))
        for dir2 in ls2:
            jsons = find_json_files(f"DAppSCAN-source/SWCsource/{dir}/{dir2}")
            for json_filename in jsons:
                with open(json_filename, "r") as fp:
                    j = json.load(fp)
                filename = j["filePath"]
                swc_list = j["SWCs"]
                reent_found2 = False
                for swc in swc_list:
                    vuln = swc["category"]
                    if vuln == 'SWC-107-Reentrancy':
                        reent_found = True
                        reent_found2 = True
                if reent_found2:
                    cnt += 1
                    print(str(cnt).zfill(3), filename, sep=',')
            assert len(jsons) >= 1
        # if reent_found:
        #     print(dir)
        
        
def flatten():
    df = pd.read_csv('reentrant-contract.csv', dtype=np.object_)
    for i in df.index:
        flattened_filename = str(df.loc[i, "id"]) + ".sol"
        code = os.system(f'''uv run ./flattener.py "{df.loc[i, "loc"]}" "./flattened/{flattened_filename}"''')
        if code != 0:
            exit(code)
            

def main():
    flatten()


if __name__ == "__main__":
    main()

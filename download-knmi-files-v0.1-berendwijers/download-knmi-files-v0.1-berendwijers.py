from pathlib import Path
import requests

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--dataset_files', action='store', type=str, required='True', dest='dataset_files')

arg_parser.add_argument('--param_api_key', action='store', type=str, required='True', dest='param_api_key')
arg_parser.add_argument('--param_radar', action='store', type=str, required='True', dest='param_radar')

args = arg_parser.parse_args()
print(args)

id = args.id

import json
dataset_files = json.loads(args.dataset_files.replace('\'','').replace('[','["').replace(']','"]'))

param_api_key = args.param_api_key
param_radar = args.param_radar

conf_api_url = api_urls.get(param_radar)   

conf_api_url = api_urls.get(param_radar)   

radar_codes = {'herwijnen' : 'NL/HRW',
               'denhelder' : 'NL/DHL'}
radar_code = radar_codes.get(param_radar)
conf_download_dir = f'./data/PVOL/{radar_code}'
for dataset_file in dataset_files:
    filename = dataset_file.get("filename")
    endpoint = f"{conf_api_url}/{filename}/url"
    get_file_response = requests.get(endpoint, headers={"Authorization": param_api_key})
    download_url = get_file_response.json().get("temporaryDownloadUrl")
    dataset_file_response = requests.get(download_url)
    fname_parts = filename.split('_')
    fname_date_part = fname_parts[-1].split('.')[0]
    year = fname_date_part[0:4]
    month = fname_date_part[4:6]
    day = fname_date_part[6:8]
    p = Path(f"{conf_download_dir}/{year}/{month}/{day}/{filename}")
    p.parent.mkdir(parents=True,exist_ok=True)
    p.write_bytes(dataset_file_response.content)


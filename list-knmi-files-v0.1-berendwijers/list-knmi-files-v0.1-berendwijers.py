import requests
import pandas as pd

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id






radar_filename_convention = {"denhelder" : "NL61",
                             "herwijnen" : "NL62"}
daily_measurement_count_hrw = 288
daily_measurement_count_dhl = 288

daily_measurement_count = {'herwijnen' : daily_measurement_count_hrw,
                           'denhelder' : daily_measurement_count_dhl}

api_url_denhelder = 'https://api.dataplatform.knmi.nl/open-data/v1/datasets/radar_volume_denhelder/versions/2.0/files'
api_url_herwijnen = 'https://api.dataplatform.knmi.nl/open-data/v1/datasets/radar_volume_full_herwijnen/versions/1.0/files'
api_urls = {'denhelder' : api_url_denhelder,
            'herwijnen' : api_url_herwijnen}

max_keys = daily_measurement_count.get(param_radar)

conf_api_url = api_urls.get(param_radar)   

current_date_timestamp = pd.datetime.now() 
yesterday_date_timestamp = current_date_timestamp - pd.Timedelta(1,"d") # remove 1 day
yesterday_date_timestamp = yesterday_date_timestamp.replace(hour=23) # change to 23:00
yesterday_date_timestamp = yesterday_date_timestamp.replace(minute=59) # changed to 23:59 

radar_code = radar_filename_convention.get(param_radar)
timestamp = yesterday_date_timestamp.strftime("%Y%m%d%H%M")
start_after_filename_prefix = f"RAD_{radar_code}_VOL_NA_{timestamp}.h5"
list_files_response = requests.get(
                        f"{conf_api_url}",
                        headers={"Authorization": param_api_key},
                        params={"maxKeys": max_keys, "startAfterFilename": start_after_filename_prefix},
                    )

list_files = list_files_response.json()

dataset_files = list_files.get("files")

print(dataset_files)

import json
filename = "/tmp/dataset_files_" + id + ".json"
file_dataset_files = open(filename, "w")
file_dataset_files.write(json.dumps(dataset_files))
file_dataset_files.close()

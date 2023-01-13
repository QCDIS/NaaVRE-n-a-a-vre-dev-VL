from pathlib import Path
import pandas as pd

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_end_date_utc', action='store', type=str, required='True', dest='param_end_date_utc')
arg_parser.add_argument('--param_radar', action='store', type=str, required='True', dest='param_radar')
arg_parser.add_argument('--param_start_date_utc', action='store', type=str, required='True', dest='param_start_date_utc')

args = arg_parser.parse_args()
print(args)

id = args.id


param_end_date_utc = args.param_end_date_utc
param_radar = args.param_radar
param_start_date_utc = args.param_start_date_utc


conf_root_dir = Path('./data/PVOL/ODIM/')
radar_translation = {'Herwijnen' : 'NL/HRW',
                    'Den Helder' : 'NL/DHL'}
radar = radar_translation.get(param_radar)
radar_pvol_dir = conf_root_dir.joinpath(radar)

print(pd.to_datetime(param_start_date_utc))
print(pd.to_datetime(param_end_date_utc))

    
pvol_paths = radar_pvol_dir.glob("**/*.h5")
df = pd.DataFrame(data=pvol_paths,columns = ['pvol_path'])
df['fname_parts'] = [row['pvol_path'].name.split('_') for idx, row in df.iterrows()]
df[['date_str','time_str']] = [row['fname_parts'][2].split('T') for idx, row in df.iterrows()]
df['date_time'] = [pd.to_datetime(row['date_str'] + row['time_str']) for idx, row in df.iterrows()]
sub_df = df[(df['date_time'] >= pd.to_datetime(param_start_date_utc)) & (df['date_time'] <= pd.to_datetime(param_end_date_utc))]

pvol_paths = sub_df['pvol_path'].to_list()
print(pvol_paths)

import json
filename = "/tmp/pvol_paths_" + id + ".json"
file_pvol_paths = open(filename, "w")
file_pvol_paths.write(json.dumps(pvol_paths))
file_pvol_paths.close()

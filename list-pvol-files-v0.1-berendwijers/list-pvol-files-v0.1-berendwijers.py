from Pathlib import Path

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_radar', action='store', type=str, required='True', dest='param_radar')


args = arg_parser.parse_args()
print(args)

id = args.id

param_radar = args.param_radar



conf_root_dir = Path('./data/PVOL/')
radar_translation = {'Herwijnen' : 'hrw',
                    'Den helder' : 'dhl'}
radar = radar_translation.get(param_radar)
radar_pvol_dir = conf_root_dir.joinpath(radar)

pvol_paths = radar_pvol_dir.glob("**/*.h5")

import json
filename = "/tmp/pvol_paths_" + id + ".json"
file_pvol_paths = open(filename, "w")
file_pvol_paths.write(json.dumps(pvol_paths))
file_pvol_paths.close()

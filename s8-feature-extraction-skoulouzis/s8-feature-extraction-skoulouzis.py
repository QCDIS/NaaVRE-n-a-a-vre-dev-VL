import pathlib

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_username', action='store', type=str, required='True', dest='param_username')

args = arg_parser.parse_args()
print(args)

id = args.id


param_username = args.param_username

conf_n_tiles_side = '512'
conf_tile_mesh_size = '10'
conf_min_y = '214783.87'
conf_remote_path_targets = pathlib.Path( '/webdav/vl-laserfarm' + '/targets_'+param_username)
conf_max_x = '398892.19'
conf_max_y = '726783.87'
conf_min_x = '-113107.81'

conf_n_tiles_side = '512'
conf_tile_mesh_size = '10'
conf_min_y = '214783.87'
conf_remote_path_targets = pathlib.Path( '/webdav/vl-laserfarm' + '/targets_'+param_username)
conf_max_x = '398892.19'
conf_max_y = '726783.87'
conf_min_x = '-113107.81'

remote_path_targets = str(conf_remote_path_targets)

features = ["perc_95_normalized_height"]

tile_mesh_size = float(conf_tile_mesh_size)

grid_feature = {
    'min_x': float(conf_min_x),
    'max_x': float(conf_max_x),
    'min_y': float(conf_min_y),
    'max_y': float(conf_max_y),
    'n_tiles_side': int(conf_n_tiles_side)
}



import json
filename = "/tmp/remote_path_targets_" + id + ".json"
file_remote_path_targets = open(filename, "w")
file_remote_path_targets.write(json.dumps(remote_path_targets))
file_remote_path_targets.close()

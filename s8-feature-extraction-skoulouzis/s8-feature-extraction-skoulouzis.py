from laserfarm import DataProcessing
import pathlib

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--tiles', action='store', type=str, required='True', dest='tiles')

arg_parser.add_argument('--param_hostname', action='store', type=str, required='True', dest='param_hostname')
arg_parser.add_argument('--param_login', action='store', type=str, required='True', dest='param_login')
arg_parser.add_argument('--param_password', action='store', type=str, required='True', dest='param_password')
arg_parser.add_argument('--param_username', action='store', type=str, required='True', dest='param_username')

args = arg_parser.parse_args()
print(args)

id = args.id

import json
tiles = json.loads(args.tiles.replace('\'','').replace('[','["').replace(']','"]'))

param_hostname = args.param_hostname
param_login = args.param_login
param_password = args.param_password
param_username = args.param_username

conf_n_tiles_side = '512'
conf_tile_mesh_size = '10'
conf_min_y = '214783.87'
conf_remote_path_targets = pathlib.Path( '/webdav/vl-laserfarm' + '/targets_'+param_username)
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}
conf_max_x = '398892.19'
conf_max_y = '726783.87'
conf_min_x = '-113107.81'

conf_n_tiles_side = '512'
conf_tile_mesh_size = '10'
conf_min_y = '214783.87'
conf_remote_path_targets = pathlib.Path( '/webdav/vl-laserfarm' + '/targets_'+param_username)
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}
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

feature_extraction_input = {
}

for t in tiles:    
    idx = (t.split('.')[0].split('_')[1:])
    processing = DataProcessing(t, tile_index=idx,label=t).config(feature_extraction_input).setup_webdav_client(conf_wd_opts)
    processing.run()

remote_path_targets

import json
filename = "/tmp/remote_path_targets_" + id + ".json"
file_remote_path_targets = open(filename, "w")
file_remote_path_targets.write(json.dumps(remote_path_targets))
file_remote_path_targets.close()

from laserfarm import DataProcessing
import copy
import pathlib
import json

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

conf_local_tmp = pathlib.Path('/tmp')
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}
conf_remote_path_retiled = pathlib.Path( '/webdav/vl-laserfarm' + '/retiled_'+param_username)
conf_remote_path_norm = pathlib.Path( '/webdav/vl-laserfarm' + '/norm_'+param_username)

conf_local_tmp = pathlib.Path('/tmp')
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}
conf_remote_path_retiled = pathlib.Path( '/webdav/vl-laserfarm' + '/retiled_'+param_username)
conf_remote_path_norm = pathlib.Path( '/webdav/vl-laserfarm' + '/norm_'+param_username)


tiles

remote_path_norm = str(conf_remote_path_norm)

normalization_input = {
    'setup_local_fs': {'tmp_folder': conf_local_tmp.as_posix()},
    'pullremote': conf_remote_path_retiled.as_posix(),
    'load': {'attributes': 'all'},
    # Filter out artifically high points - give overflow error when writing
    'apply_filter': {'filter_type':'select_below',
                     'attribute': 'z',
                     'threshold': 10000.},  # remove non-physically heigh points
    'normalize': 1,
    'clear_cache' : {},
    'pushremote': conf_remote_path_norm.as_posix(),
}

with open('normalize.json', 'w') as f:
    json.dump(normalization_input, f)
    


for tile in tiles:
    normalization_input_ = copy.deepcopy(normalization_input)
    normalization_input_['export_point_cloud'] = {'filename': '{}.laz'.format(tile),'overwrite': True}
    dp = DataProcessing(tile, label=tile).config(normalization_input_).setup_webdav_client(conf_wd_opts)
    dp.run()

remote_path_norm

import json
filename = "/tmp/remote_path_norm_" + id + ".json"
file_remote_path_norm = open(filename, "w")
file_remote_path_norm.write(json.dumps(remote_path_norm))
file_remote_path_norm.close()

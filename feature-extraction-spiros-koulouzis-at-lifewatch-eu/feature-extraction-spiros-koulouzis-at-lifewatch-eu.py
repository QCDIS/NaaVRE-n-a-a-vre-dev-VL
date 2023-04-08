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
conf_min_y = '214783.87'
conf_filter_type= 'select_equal'
conf_attribute = 'raw_classification'
conf_tile_mesh_size = '10.'
conf_validate_precision = '0.001'
conf_remote_path_retiled = pathlib.Path( '/webdav/LAZ' + '/retiled_'+param_username)
conf_min_x = '-113107.81'
conf_local_tmp = pathlib.Path('/tmp')
conf_remote_path_targets = pathlib.Path( '/webdav/LAZ' + '/targets_'+param_username)
conf_max_y = '726783.87'
conf_apply_filter_value = '1'
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}
conf_max_x = '398892.19'
conf_feature_name = 'perc_95_normalized_height'

conf_n_tiles_side = '512'
conf_min_y = '214783.87'
conf_filter_type= 'select_equal'
conf_attribute = 'raw_classification'
conf_tile_mesh_size = '10.'
conf_validate_precision = '0.001'
conf_remote_path_retiled = pathlib.Path( '/webdav/LAZ' + '/retiled_'+param_username)
conf_min_x = '-113107.81'
conf_local_tmp = pathlib.Path('/tmp')
conf_remote_path_targets = pathlib.Path( '/webdav/LAZ' + '/targets_'+param_username)
conf_max_y = '726783.87'
conf_apply_filter_value = '1'
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}
conf_max_x = '398892.19'
conf_feature_name = 'perc_95_normalized_height'
    
for t in tiles:
    features = [conf_feature_name]

    tile_mesh_size = float(conf_tile_mesh_size)

    grid_feature = {
        'min_x': float(conf_min_x),
        'max_x': float(conf_max_x),
        'min_y': float(conf_min_y),
        'max_y': float(conf_max_y),
        'n_tiles_side': int(conf_n_tiles_side)
    }

    feature_extraction_input = {
        'setup_local_fs': {'tmp_folder': conf_local_tmp.as_posix()},
        'pullremote': conf_remote_path_retiled.as_posix(),
        'load': {'attributes': [conf_attribute]},
        'normalize': 1,
        'apply_filter': {
            'filter_type': conf_filter_type, 
            'attribute': conf_attribute,
            'value': [int(conf_apply_filter_value)]#ground surface (2), water (9), buildings (6), artificial objects (26), vegetation (?), and unclassified (1)
        },
        'generate_targets': {
            'tile_mesh_size' : tile_mesh_size,
            'validate' : True,
            'validate_precision': float(conf_validate_precision),
            **grid_feature
        },
        'extract_features': {
            'feature_names': features,
            'volume_type': 'cell',
            'volume_size': tile_mesh_size
        },
        'export_targets': {
            'attributes': features,
            'multi_band_files': False
        },
        'pushremote': conf_remote_path_targets.as_posix(),
    #     'cleanlocalfs': {}
    }
    idx = (t.split('_')[1:])

    processing = DataProcessing(t, tile_index=idx,label=t).config(feature_extraction_input).setup_webdav_client(conf_wd_opts)
    processing.run()
    
remote_path_targets = conf_remote_path_targets.as_posix()

print(type(remote_path_targets))

import json
filename = "/tmp/remote_path_targets_" + id + ".json"
file_remote_path_targets = open(filename, "w")
file_remote_path_targets.write(json.dumps(remote_path_targets))
file_remote_path_targets.close()

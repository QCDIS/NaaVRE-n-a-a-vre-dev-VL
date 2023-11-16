import pathlib

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_username', action='store', type=str, required='True', dest='param_username')

args = arg_parser.parse_args()
print(args)

id = args.id


param_username = args.param_username

conf_remote_path_norm = pathlib.Path( '/webdav/vl-laserfarm' + '/norm_'+param_username)
conf_local_tmp = pathlib.Path('/tmp')
conf_attribute = 'raw_classification'
conf_filter_type = 'select_equal'

conf_remote_path_norm = pathlib.Path( '/webdav/vl-laserfarm' + '/norm_'+param_username)
conf_local_tmp = pathlib.Path('/tmp')
conf_attribute = 'raw_classification'
conf_filter_type = 'select_equal'


feature_extraction_input = {
    'setup_local_fs': {
        'input_folder': (conf_local_tmp / 'tile_input').as_posix(),
        'output_folder': (conf_local_tmp / 'tile_output').as_posix(),
    },
    'pullremote': conf_remote_path_norm.as_posix(),
    'load': {'attributes': [conf_attribute]},
    'normalize': 1,
    
    'apply_filter': { 
        'filter_type': conf_filter_type, 'attribute': conf_attribute
        # 'value': [int(conf_apply_filter_value)]#ground surface (2), water (9), buildings (6), artificial objects (26), vegetation (?), and unclassified (1)
    }
    
}


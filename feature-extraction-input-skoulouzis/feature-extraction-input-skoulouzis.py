
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--conf_attribute', action='store', type=str, required='True', dest='conf_attribute')

arg_parser.add_argument('--conf_filter_type', action='store', type=str, required='True', dest='conf_filter_type')

arg_parser.add_argument('--conf_local_tmp', action='store', type=str, required='True', dest='conf_local_tmp')

arg_parser.add_argument('--conf_remote_path_norm', action='store', type=str, required='True', dest='conf_remote_path_norm')


args = arg_parser.parse_args()
print(args)

id = args.id

conf_attribute = args.conf_attribute
conf_filter_type = args.conf_filter_type
conf_local_tmp = args.conf_local_tmp
conf_remote_path_norm = args.conf_remote_path_norm





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


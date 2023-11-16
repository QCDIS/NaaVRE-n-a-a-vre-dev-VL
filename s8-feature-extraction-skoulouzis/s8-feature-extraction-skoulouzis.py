import pathlib

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_username', action='store', type=str, required='True', dest='param_username')

args = arg_parser.parse_args()
print(args)

id = args.id


param_username = args.param_username

conf_remote_path_targets = pathlib.Path( '/webdav/vl-laserfarm' + '/targets_'+param_username)

conf_remote_path_targets = pathlib.Path( '/webdav/vl-laserfarm' + '/targets_'+param_username)

remote_path_targets = str(conf_remote_path_targets)

features = ["perc_95_normalized_height"]






import json
filename = "/tmp/remote_path_targets_" + id + ".json"
file_remote_path_targets = open(filename, "w")
file_remote_path_targets.write(json.dumps(remote_path_targets))
file_remote_path_targets.close()

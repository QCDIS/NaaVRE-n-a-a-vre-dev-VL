import pathlib

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--split_laz_files', action='store', type=str, required='True', dest='split_laz_files')


args = arg_parser.parse_args()
print(args)

id = args.id

import json
split_laz_files = json.loads(args.split_laz_files.replace('\'','').replace('[','["').replace(']','"]'))


conf_min_x = '-113107.81'
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}
conf_min_y = '214783.87'
conf_max_y = '726783.87'
conf_max_x = '398892.19'
conf_remote_path_retiled = pathlib.Path( '/webdav/LAZ' + '/retiled_'+param_username)
conf_n_tiles_side = '512'
conf_remote_path_split = pathlib.Path( '/webdav/LAZ' + '/split_'+param_username)
conf_local_tmp = pathlib.Path('/tmp')

split_laz_files
remote_path_retiled = str(conf_remote_path_retiled)

for file in split_laz_files:
    print(file)

import json
filename = "/tmp/retiler_output_" + id + ".json"
file_retiler_output = open(filename, "w")
file_retiler_output.write(json.dumps(retiler_output))
file_retiler_output.close()

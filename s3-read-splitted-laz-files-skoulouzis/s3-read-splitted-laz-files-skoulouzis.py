import pathlib
from laserfarm.remote_utils import list_remote
from laserfarm.remote_utils import get_wdclient

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--remote_path_retiled', action='store', type=str, required='True', dest='remote_path_retiled')

arg_parser.add_argument('--param_hostname', action='store', type=str, required='True', dest='param_hostname')
arg_parser.add_argument('--param_login', action='store', type=str, required='True', dest='param_login')
arg_parser.add_argument('--param_password', action='store', type=str, required='True', dest='param_password')
arg_parser.add_argument('--param_username', action='store', type=str, required='True', dest='param_username')

args = arg_parser.parse_args()
print(args)

id = args.id

remote_path_retiled = args.remote_path_retiled

param_hostname = args.param_hostname
param_login = args.param_login
param_password = args.param_password
param_username = args.param_username

conf_remote_path_split = pathlib.Path( '/webdav/vl-laserfarm' + '/split_'+param_username)
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}

conf_remote_path_split = pathlib.Path( '/webdav/vl-laserfarm' + '/split_'+param_username)
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}
remote_path_retiled

split_laz_files = [f for f in list_remote(get_wdclient(conf_wd_opts), pathlib.Path(conf_remote_path_split).as_posix())
             if f.lower().endswith('.laz')]

import json
filename = "/tmp/split_laz_files_" + id + ".json"
file_split_laz_files = open(filename, "w")
file_split_laz_files.write(json.dumps(split_laz_files))
file_split_laz_files.close()

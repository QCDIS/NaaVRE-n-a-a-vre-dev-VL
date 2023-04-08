import fnmatch
from laserfarm.remote_utils import list_remote
import pathlib
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

conf_remote_path_retiled = pathlib.Path( '/webdav/LAZ' + '/retiled_'+param_username)
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}

conf_remote_path_retiled = pathlib.Path( '/webdav/LAZ' + '/retiled_'+param_username)
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}
remote_path_retiled

tiles = [t.strip('/') for t in list_remote(get_wdclient(conf_wd_opts), conf_remote_path_retiled.as_posix())
         if fnmatch.fnmatch(t, 'tile_*_*/')]

import json
filename = "/tmp/tiles_" + id + ".json"
file_tiles = open(filename, "w")
file_tiles.write(json.dumps(tiles))
file_tiles.close()

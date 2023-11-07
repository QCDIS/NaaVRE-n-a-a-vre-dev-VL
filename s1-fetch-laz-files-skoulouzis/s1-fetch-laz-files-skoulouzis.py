from laserfarm.remote_utils import get_wdclient
from laserfarm.remote_utils import list_remote
import pathlib

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_hostname', action='store', type=str, required='True', dest='param_hostname')
arg_parser.add_argument('--param_login', action='store', type=str, required='True', dest='param_login')
arg_parser.add_argument('--param_password', action='store', type=str, required='True', dest='param_password')
arg_parser.add_argument('--param_remote_path_root', action='store', type=str, required='True', dest='param_remote_path_root')

args = arg_parser.parse_args()
print(args)

id = args.id


param_hostname = args.param_hostname
param_login = args.param_login
param_password = args.param_password
param_remote_path_root = args.param_remote_path_root

conf_remote_path_ahn = pathlib.Path(param_remote_path_root+'/ahn')
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}

conf_remote_path_ahn = pathlib.Path(param_remote_path_root+'/ahn')
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}

laz_files = [f for f in list_remote(get_wdclient(conf_wd_opts), conf_remote_path_ahn.as_posix())
             if f.lower().endswith('.laz')]
print(laz_files)

import json
filename = "/tmp/laz_files_" + id + ".json"
file_laz_files = open(filename, "w")
file_laz_files.write(json.dumps(laz_files))
file_laz_files.close()

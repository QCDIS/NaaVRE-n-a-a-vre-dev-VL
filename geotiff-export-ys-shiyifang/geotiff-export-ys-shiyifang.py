import pathlib
from laserfarm import GeotiffWriter

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--features', action='store', type=str, required='True', dest='features')

arg_parser.add_argument('--param_feature_name', action='store', type=str, required='True', dest='param_feature_name')
arg_parser.add_argument('--param_hostname', action='store', type=str, required='True', dest='param_hostname')
arg_parser.add_argument('--param_login', action='store', type=str, required='True', dest='param_login')
arg_parser.add_argument('--param_password', action='store', type=str, required='True', dest='param_password')

args = arg_parser.parse_args()
print(args)

id = args.id

import json
features = json.loads(args.features.replace('\'','').replace('[','["').replace(']','"]'))

param_feature_name = args.param_feature_name
param_hostname = args.param_hostname
param_login = args.param_login
param_password = args.param_password

conf_remote_path_targets = pathlib.Path('/pnfs/grid.sara.nl/data/lidarac/disk/02_UvA/YShi/AHN3/Test_las/targets')
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}
conf_remote_path_ahn = pathlib.Path('/pnfs/grid.sara.nl/data/lidarac/disk/02_UvA/YShi/AHN3/Test_las/ahn')
conf_local_tmp = pathlib.Path('/tmp')

conf_remote_path_targets = pathlib.Path('/pnfs/grid.sara.nl/data/lidarac/disk/02_UvA/YShi/AHN3/Test_las/targets')
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}
conf_remote_path_ahn = pathlib.Path('/pnfs/grid.sara.nl/data/lidarac/disk/02_UvA/YShi/AHN3/Test_las/ahn')
conf_local_tmp = pathlib.Path('/tmp')

feature = features[0]

remote_path_geotiffs = conf_remote_path_ahn.parent / 'geotiffs'

geotiff_export_input = {
    'setup_local_fs': {'tmp_folder': conf_local_tmp.as_posix()},
    'pullremote': conf_remote_path_targets.as_posix(),
    'parse_point_cloud': {},
    'data_split': {'xSub': 1, 'ySub': 1},
    'create_subregion_geotiffs': {'output_handle': 'geotiff'},
    'pushremote': remote_path_geotiffs.as_posix(),
    'cleanlocalfs': {}   
}

writer = GeotiffWriter(input_dir=param_feature_name, bands=param_feature_name,label=param_feature_name).config(geotiff_export_input).setup_webdav_client(conf_wd_opts)
writer.run()

import json
filename = "/tmp/remote_path_geotiffs_" + id + ".json"
file_remote_path_geotiffs = open(filename, "w")
file_remote_path_geotiffs.write(json.dumps(remote_path_geotiffs))
file_remote_path_geotiffs.close()

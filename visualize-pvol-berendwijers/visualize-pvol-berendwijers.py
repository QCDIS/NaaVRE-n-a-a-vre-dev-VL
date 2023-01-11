import wradlib as wrd
import matplotlib.pyplot as plt
import pyproj
import pandas as pd
import h5py

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_dpi', action='store', type=int, required='True', dest='param_dpi')

arg_parser.add_argument('--param_elev', action='store', type=float, required='True', dest='param_elev')

arg_parser.add_argument('--param_quantity', action='store', type=str, required='True', dest='param_quantity')

arg_parser.add_argument('--pvol_paths', action='store', type=str, required='True', dest='pvol_paths')

arg_parser.add_argument('--radar', action='store', type=str, required='True', dest='radar')


args = arg_parser.parse_args()
print(args)

id = args.id

param_dpi = args.param_dpi
param_elev = args.param_elev
param_quantity = args.param_quantity
import json
pvol_paths = json.loads(args.pvol_paths.replace('\'','').replace('[','["').replace(']','"]'))
radar = args.radar




quantity = param_quantity # str: DBZH
elev = param_elev # float: 2.0
dpi = param_dpi # int: 96


def get_pvol_array(fpath,elangle,quantity,transform=True):
    with h5py.File(fpath,mode='r') as pvol:
        keys = list(pvol.keys())
        dataset_keys = [key for key in keys if 'dataset' in key]
        root_what_attrs = []
        root_where_attrs = []
        root_how_attrs = []
        
        for dataset_key in dataset_keys:
            where_attrs = dict(pvol[dataset_key]['where'].attrs)
            elev_angle = where_attrs.get('elangle')
            #print(elev_angle)
            if elev_angle == elangle:
                data_keys = list(pvol[dataset_key].keys())
                quantity_keys = [key for key in data_keys if 'data' in key]
                for quantity_key in quantity_keys:
                    what_attr = dict(pvol[dataset_key][quantity_key]['what'].attrs)
                    #print(what_attr)
                    quant = what_attr.get('quantity').decode('utf-8')
                    if quantity == quant:
                        arr = pvol[dataset_key][quantity_key]['data'][:]
                        offset = what_attr.get('offset')[0]
                        gain = what_attr.get('gain')[0]
                        dset = (arr * gain) + offset
                        return dset
                        
                        
def get_radar_lat_lon(fpath):
    with h5py.File(fpath,mode='r') as pvol:
        where_attr = dict(pvol['where'].attrs)
        return (where_attr.get('lat')[0],where_attr.get('lon')[0])
    
radar_translation = {'hrw' : 'Herwijnen',
                    'dhl' : 'Den Helder'}
    
gendate = pd.datetime.now().strftime("%Y%m%dT%H%M")
for fpath in pvol_paths:
    fname = fpath.stem
    date_str = fname.split("_")[-2]
    date_str, time_str = date_str.split("T")
    year = date_str[0:4]
    month = date_str[4:6]
    day = date_str[6:8]
    hour = time_str[0:2]
    minute = time_str[2:4]
    radar_lat,radar_lon = get_radar_lat_lon(fpath)
    array = get_pvol_array(fpath,elangle=elev,quantity=quantity)
    proj4string = f"+proj=aeqd +lat_0={radar_lat} +lon_0={radar_lon} +units=m"
    crs = pyproj.CRS.from_string(proj4string)
    fig = plt.figure(figsize=(10,10),dpi=dpi)
    # plot as ppi alternate option
    ax, pm = wrd.vis.plot_ppi(array,proj=crs,elev=elev,vmin=-30,vmax=30,fig=fig)
    #plt.imshow(data_array_s3)
    plt.title(f"The Netherlands - {radar} - Elevation angle {elev}\n{year}-{month}-{day} T {hour}:{minute}")
    #plt.title(f"{fname} - Elev: {elev}")
    #ax = plt.gca()
    ylabel = ax.set_xlabel("easting [km]")
    ylabel = ax.set_ylabel("northing [km]")
    cb = plt.colorbar(pm, ax=ax)  
    imname = fname + f"_{elev}_{quantity}.png"
    plt.savefig(f'./data/images/{gendate}/{radar}/{imname}',dpi=dpi)
    plt.show()
    


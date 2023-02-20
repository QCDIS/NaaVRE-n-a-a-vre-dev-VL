from utils_image_retrieval_YD import create_environment
from variational_autoencoder_YD import ConvVarAutoencoder
import time
import csv
import os
import flwr as fl
import tensorflow as tf
from my_data_generator import DataGenerator
from utils_image_retrieval_YD import create_json
from sklearn.model_selection import train_test_split
import pandas as pd

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--dataset', action='store', type=str, required='True', dest='dataset')

arg_parser.add_argument('--results', action='store', type=str, required='True', dest='results')

arg_parser.add_argument('--server_address', action='store', type=str, required='True', dest='server_address')


args = arg_parser.parse_args()
print(args)

id = args.id

dataset = args.dataset
results = args.results
server_address = args.server_address






DEVICE = tf.config.list_physical_devices('GPU')
print("Num GPUs Available: ", DEVICE, len(tf.config.list_physical_devices('GPU')), "\n")

os.environ["CUDA_VISIBLE_DEVICES"] = "0"
config = tf.compat.v1.ConfigProto()
config.gpu_options.allow_growth = True
session=tf.compat.v1.Session(config=config)


sever_address = server_address
run_folders = results
dataset = dataset







input_dim = (224, 224, 3)
encoder_conv_filters = [32, 64, 128, 256]
encoder_conv_kernel_size = [3, 3, 3, 3]
encoder_conv_strides = [1, 2, 2, 2]
bottle_conv_filters = [64, 32, 1, 256]
bottle_conv_kernel_size = [3, 3, 3, 3]
bottle_conv_strides = [1, 1, 1, 1]
decoder_conv_t_filters = [128, 64, 32, 3]
decoder_conv_t_kernel_size = [3, 3, 3, 3]
decoder_conv_t_strides = [2, 2, 2, 1]
bottle_dim = (32, 32, 256)
z_dim = 200
r_loss_factor = 10000
 # Default setting: server side control lr, batch_size, epochs
is_training = True
conv_layeri=[]
conv_t_layeri=[]

create_environment(run_folders)



label2=[]
df_pneumo_2d = pd.read_csv(r"/home/yuandou/test/archive/train/BreaKHis_40X.csv")
df_pneumo_2d.columns = ['index', 'image_name']

df_pneumo_2d=(df_pneumo_2d.iloc[:,:])

label2 = range(0,len(df_pneumo_2d))

x_train, x_test, ytrain, ytest = train_test_split(df_pneumo_2d,label2, test_size = 0.3, random_state = 0)
label2 = range(0,len(x_train))
x_train, x_val, ytrain, yval = train_test_split(x_train,label2, test_size = 0.2, random_state = 0)



""" Architecture"""
my_VAE = ConvVarAutoencoder(input_dim
                    , encoder_conv_filters
                    , encoder_conv_kernel_size
                    , encoder_conv_strides
                    , bottle_dim
                    , bottle_conv_filters
                    , bottle_conv_kernel_size
                    , bottle_conv_strides
                    , decoder_conv_t_filters
                    , decoder_conv_t_kernel_size
                    , decoder_conv_t_strides
                    , z_dim)
my_VAE.build(use_batch_norm=True, use_dropout=True)


def train(my_VAE, x_train, x_val, epochs, batch_size, round_idx): 
    # training dataset and trainloader definition
    stime2loaddata = time.time()
    
    # stime2loadtraindata = time.time()
    data_flow_train = DataGenerator(x_train
                                    , input_dim[0]
                                    , input_dim[1]
                                    , input_dim[2]
                                    , indexes_output=[True, True, False, False]
                                    , batch_size=batch_size
                                    # , path_to_img=run_folders["data_path"]
                                    , data_augmentation=True
                                    , vae_mode=True
                                    , reconstruction=True
                                    , softmax=False
                                    , hide_and_seek=False
                                    , equalization=False
                                    )
    # etime2loadtraindata = time.time()
    # trainloader = data_flow_train
    # time2loadtraindata = etime2loadtraindata - stime2loadtraindata

    # validation dataset and valloader definition

    data_flow_dev = DataGenerator(x_val
                                  , input_dim[0]
                                  , input_dim[1]
                                  , input_dim[2]
                                  , indexes_output=[True, True, False, False]
                                  , batch_size=batch_size
                                #   , path_to_img=run_folders["data_path"]
                                  , data_augmentation=True
                                  , vae_mode=True
                                  , reconstruction=True
                                  , softmax=True
                                  , hide_and_seek=False
                                  , equalization=False
                                  )
    # valloader = data_flow_dev

    etime2loaddata = time.time()
    time2loaddata = etime2loaddata - stime2loaddata
    num_examples = {"trainset" : len(x_train), "valset": len(x_val)}
    
    
    """ Train Model"""
    stime2trainmodel = time.time()
    steps_per_epoch = len(data_flow_train)
    H = my_VAE.train_with_generator(data_flow_train, epochs, steps_per_epoch, data_flow_dev, run_folders, round_idx)
    etime2trainmodel = time.time()
    # time2trainmodel = etime2trainmodel - stime2trainmodel
    return stime2trainmodel, etime2trainmodel, data_flow_train, data_flow_dev

    # """Validate the network on the entire test set."""



"""Load data phase"""

class CBIRClient_breaKHis40x(fl.client.NumPyClient):
    # def __init__(self, my_VAE, trainloader, valloader, testloader, num_examples) -> None:
    #     self.model = my_VAE
    #     self.trainloader = trainloader
    #     self.valloader = valloader
    #     self.testloader = testloader
    #     self.num_examples = num_examples

    def get_parameters(self, config):
        # current_round = config["current_round"]
        # local_epochs = config["local_epochs"]
        # random weights 
        
        stime2getweights = time.time()
        # if-clause
        weights = my_VAE.model.get_weights()
        etime2getweights = time.time()
        time2getweights = etime2getweights - stime2getweights
        print("===weight===", weights)
        print("\nStart to get weights at ", stime2getweights, "end to get weights", etime2getweights, time2getweights, '\n')

        # header = ["current_round", "local_epochs", "start2getweights", "end2getweight"]
        # data = [current_round, local_epochs, stime2getweights, etime2getweights]
        header = ["start2getweights", "end2getweight"]
        data = [stime2getweights, etime2getweights]
        dirctory = run_folders["model_path"] + run_folders["exp_name"] 
        with open(dirctory+'/res_get_paras_client2_breaKHis40x.csv', 'a', encoding='UTF8') as f:
            writer = csv.writer(f)

            # write the header
            writer.writerow(header)

            # write the data
            writer.writerow(data)

        return my_VAE.model.get_weights()

    def fit(self, parameters, config):

        stime2setweights = time.time()
        my_VAE.model.set_weights(parameters)

        etime2setweights = time.time()
        print("\nStart to set weights for model training at ", stime2setweights, "end at ", etime2setweights)
        
        current_round = config["current_round"]
        local_epochs = config["local_epochs"]
        local_lr = config["learning_rate"]
        local_batch_size = config["batch_size"]
        
        # Building JSON with the model hyperparameters
        hyperparameters = {
            "input_dim": input_dim
            , "encoder_conv_filters": encoder_conv_filters
            , "encoder_conv_kernel_size": encoder_conv_kernel_size
            , "encoder_conv_strides": encoder_conv_strides
            , "bottle_conv_filters" : bottle_conv_filters
            , "bottle_conv_kernel_size": bottle_conv_kernel_size
            , "bottle_conv_strides":  bottle_conv_strides
            , "decoder_conv_t_filters": decoder_conv_t_filters
            , "decoder_conv_t_kernel_size": decoder_conv_t_kernel_size
            , "decoder_conv_t_strides": decoder_conv_t_strides
            , "z_dim": z_dim
            , "r_loss_factor": r_loss_factor
            , "learning_rate": local_lr
            , "batch_size": local_batch_size
            , "epochs": local_epochs
            , "opt": "Adam"
            , "loss_function": "mse"
            # , "data_path": run_folders["data_path"]
            , "bottle_dim" : bottle_dim 
        }
        create_json(hyperparameters, run_folders)

        """ Load model """ 
        # Compiling VAE
        my_VAE.compile(learning_rate=local_lr, r_loss_factor=r_loss_factor)
        print(my_VAE.model.summary())
        
        stime2trainmodel, etime2trainmodel, data_flow_train, data_flow_dev = train(my_VAE, x_train, x_val, epochs=local_epochs, batch_size = local_batch_size, round_idx=current_round)
        print("\nRound: ", current_round, "local epochs: ", local_epochs, "Start local training at ", stime2trainmodel, "end at ", etime2trainmodel)
        header = ["current_round", "local_epochs", "learning_rate", "batch_size", "start2setweights", "end2setweights", "start2trainmodel", "end2trainmodel"]
        data = [current_round, local_epochs, local_lr, local_batch_size, stime2setweights, etime2setweights, stime2trainmodel, etime2trainmodel]
        dirctory = run_folders["model_path"] + run_folders["exp_name"] 
        with open(dirctory+'/res_fit_client2_breaKHis40x.csv', 'a', encoding='UTF8') as f:
            writer = csv.writer(f)

            # write the header
            writer.writerow(header)

            # write the data
            writer.writerow(data)


        return my_VAE.model.get_weights(), len(data_flow_train), {}

    # def evaluate(self, parameters, config):
        # print("\nEVALUATE")
        # my_VAE.model.set_weights(parameters)
        # print("\n set weights\n")
        # loss, accuracy = my_VAE.evaluate(x_test, y_test)
        # return loss, len(x_test), {"accuracy": float(accuracy)}
        # loss, accuracy = my_VAE.model.evaluate(testloader)
        # return loss, len(testloader), {"accuracy": float(accuracy)}
        
    
fl.client.start_numpy_client(server_address=server_address, client=CBIRClient_breaKHis40x())


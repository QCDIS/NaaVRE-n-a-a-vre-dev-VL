import torchvision.transforms as transforms
import torch.nn as nn
from torch import Tensor
from typing import Dict
import numpy as np
from torchvision.datasets import CIFAR10
from typing import Tuple
import torch
import time
import csv
import torch.nn.functional as F

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--BATCH_SIZE', action='store', type=int, required='True', dest='BATCH_SIZE')

arg_parser.add_argument('--epochs', action='store', type=int, required='True', dest='epochs')


args = arg_parser.parse_args()
print(args)

id = args.id

BATCH_SIZE = args.BATCH_SIZE
epochs = args.epochs







class Net(nn.Module):

    def __init__(self) -> None:
        super(Net, self).__init__()
        self.conv1 = nn.Conv2d(3, 6, 5)
        self.pool = nn.MaxPool2d(2, 2)
        self.conv2 = nn.Conv2d(6, 16, 5)
        self.fc1 = nn.Linear(16 * 5 * 5, 120)
        self.fc2 = nn.Linear(120, 84)
        self.fc3 = nn.Linear(84, 10)

    def forward(self, x: Tensor) -> Tensor:
        x = self.pool(F.relu(self.conv1(x)))
        x = self.pool(F.relu(self.conv2(x)))
        x = x.view(-1, 16 * 5 * 5)
        x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        x = self.fc3(x)
        return x


DATA_ROOT = "./data/cifar-10"
BATCH_SIZE = BATCH_SIZE
epochs = epochs

def load_data() -> Tuple[torch.utils.data.DataLoader, torch.utils.data.DataLoader, Dict]:
    """Load CIFAR-10 (training and test set)."""
    
    ld_start = time.time()
    transform = transforms.Compose(
        [transforms.ToTensor(), transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))]
    )
    trainset = CIFAR10(DATA_ROOT, train=True, download=True, transform=transform)
    trainloader = torch.utils.data.DataLoader(trainset, batch_size=BATCH_SIZE, shuffle=True)
    testset = CIFAR10(DATA_ROOT, train=False, download=True, transform=transform)
    testloader = torch.utils.data.DataLoader(testset, batch_size=BATCH_SIZE, shuffle=False)
    num_examples = {"trainset" : len(trainset), "testset" : len(testset)}
    ld_end = time.time()
    load_data_time = ld_end-ld_start
    print("Time to load data: ", load_data_time, "s")

    return trainloader, testloader, num_examples, load_data_time

def train(
    net: Net,
    trainloader: torch.utils.data.DataLoader,
    epochs: int,
    device: torch.device,
) -> None:
    """Train the network."""
    # Define loss and optimizer
    criterion = nn.CrossEntropyLoss()
    optimizer = torch.optim.SGD(net.parameters(), lr=0.001, momentum=0.9)

    print(f"Training {epochs} epoch(s) w/ {len(trainloader)} batches each")
    
    start_train = time.time()
    train_loss = []
    train_acc = []
    # Train the network
    for epoch in range(epochs):  # loop over the dataset multiple times
        print("Epoch ", epoch+1)
        
        correct, total, train_loss_epoch = 0, 0, 0.0
        running_loss = 0.0
        for i, data in enumerate(trainloader, 0):
            images, labels = data[0].to(device), data[1].to(device)

            # zero the parameter gradients
            optimizer.zero_grad()

            # forward + backward + optimize
            outputs = net(images)
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()

            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()

            # print statistics: loss
            running_loss += loss.item()
            # if i % 100 == 99:  # print every 100 mini-batches
                # print("[%d, %5d] loss: %.3f" % (epoch + 1, i + 1, running_loss / 2000))
                # running_loss = 0.0
        # print statistics: running_loss, accuracy per epoch in training
        running_loss = running_loss / total
        train_acc_epoch = correct / total
        # val_loss_epoch, val_acc_epoch = test(net, valloader)
        info = "[INFO] Epoch {}/{} - train_loss: {:.6f} - train_acc: {:.6f} ".format(
                epoch + 1, epochs, running_loss, train_acc_epoch)
        print(info + "\n")
        train_loss.append(running_loss)
        train_acc.append(train_acc_epoch)
    print("Data of running loss: ", train_loss)
    print("Data of running accuracy: ", train_acc)
    end_train = time.time()
    train_time = end_train - start_train
    print("Time to train the whole network: ", train_time, " s")
    return train_time, train_loss, train_acc


def test(
    net: Net,
    testloader: torch.utils.data.DataLoader,
    device: torch.device,
) -> Tuple[float, float]:
    """Validate the network on the entire test set."""
    criterion = nn.CrossEntropyLoss()
    correct = 0
    total = 0
    loss = 0.0
    # whole_labels, whole_predicted = torch.Tensor([]), torch.Tensor([])
    with torch.no_grad():
        for data in testloader:
            images = torch.from_numpy(np.asarray(data[0]).astype('float32'))
            images, labels = images.to(device), data[1].to(device)
            outputs = net(images)
            loss += criterion(outputs, labels).item()
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()
            # whole_labels = torch.cat((whole_labels.cpu(), labels.cpu()))
            # whole_predicted = torch.cat((whole_predicted.cpu(), predicted.cpu()))
    # print("CONFUSION MATRIX:")
    # print(confusion_matrix(whole_labels.cpu(), whole_predicted.cpu()))
    accuracy = correct / total
    loss = loss / total
    return loss, accuracy


"""Run program and data collection"""
DEVICE = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
NAME = torch.cuda.get_device_name(DEVICE)
print("Centralized PyTorch training using: ", DEVICE, NAME)

print("Load data")
trainloader, testloader, num_examples, load_data_time = load_data()
    
print("Start training")
net=Net().to(DEVICE)
train_time, train_loss, train_acc= train(net=net, trainloader=trainloader, epochs=epochs, device=DEVICE)
print("Evaluate model")
loss, accuracy = test(net=net, testloader=testloader, device=DEVICE)
print("Batch size: ", BATCH_SIZE)
print("Loss: ", loss)
print("Accuracy: ", accuracy)

header = ['batch_size', 'epochs', 'load_data_time', 'train_time', 'loss(test)', 'ACC(test)', 'train_loss', 'train_acc', 'DEVICE', 'NAME']
data = [BATCH_SIZE, epochs, load_data_time, train_time, loss, accuracy, train_loss, train_acc, DEVICE, NAME]

with open('./res_model.csv', 'a', encoding='UTF8') as f:
    writer = csv.writer(f)

    # write the header
    # writer.writerow(header)

    # write the data
    writer.writerow(data)


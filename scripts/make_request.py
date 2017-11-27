#!/usr/bin/python

import json
from tensorflow.examples.tutorials.mnist import input_data

mnist = input_data.read_data_sets("/tmp/data/", one_hot=True)
with open("request.json", "w") as file:
    for i in range(10):
        data = {"inputs": mnist.test.images[i].tolist()}
        file.write(json.dumps(data) + '\n')

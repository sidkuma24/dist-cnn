## Commands for Training CNN:
```
gcloud config set compute/zone us-east1-c
````
```
gcloud config set project [YOUR_PROJECT_ID]
```
```
git clone https://github.com/sidkuma24/dist-cnn/
```
* Create the template instance : 
```
gcloud compute instances create template-instance \
--image-project ubuntu-os-cloud \
--image-family ubuntu-1604-lts \
--boot-disk-size 10GB \
--machine-type n1-standard-1

```

```
gcloud compute ssh template-instance

```

```
sudo apt-get update
sudo apt-get -y upgrade \
&& sudo apt-get install -y python-pip python-dev

```
```
sudo pip install tensorflow
```

* Create Google Cloud Storage Bucket for MNIST 

```
BUCKET="mnist-$RANDOM-$RANDOM"
gsutil mb -c regional -l us-east1 gs://${BUCKET}

sudo ./scripts/create_records.py
gsutil cp /tmp/data/train.tfrecords gs://${BUCKET}/data/
gsutil cp /tmp/data/test.tfrecords gs://${BUCKET}/data/```
```

* Create template instance
```
gcloud compute instances set-disk-auto-delete template-instance \
--disk template-instance --no-auto-delete

gcloud compute instances delete template-instance

gcloud compute images create template-image \
--source-disk template-instance
```
* Create Other instances:
```
gcloud compute instances create \
master-0 worker-0 worker-1 ps-0 \
--image template-image \
--machine-type n1-standard-2 \
--scopes=default,storage-rw```
```

* Train the model
````
./scripts/start-training.sh gs://${BUCKET}

````

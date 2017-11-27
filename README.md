## Commands for Training CNN:

https://console.cloud.google.com/home/dashboard?project=cnn-mnist-186003

```
gcloud ml-engine models list

```
git clone https://github.com/sidkuma24/dist-cnn/
PROJECT_ID=$(gcloud config list project --format "value(core.project)")
BUCKET="${PROJECT_ID}-ml"
gsutil mb -c regional -l us-central1 gs://${BUCKET}

./scripts/create_records.py
gsutil cp /tmp/data/train.tfrecords gs://${BUCKET}/data/
gsutil cp /tmp/data/test.tfrecords gs://${BUCKET}/data/

JOB_NAME="job_$(date +%Y%m%d_%H%M%S)"
gcloud ml-engine jobs submit training ${JOB_NAME} \
    --package-path trainer \
    --module-name trainer.task \
    --staging-bucket gs://${BUCKET} \
    --job-dir gs://${BUCKET}/${JOB_NAME} \
    --runtime-version 1.2 \
    --region us-central1 \
    --config config/config.yaml \
    -- \
    --data_dir gs://${BUCKET}/data \
    --output_dir gs://${BUCKET}/${JOB_NAME} \
    --train_steps 10000

#!/bin/bash

# Get the number of nodes
NUM_PS=$(gcloud compute instances list | grep -E '^ps-[0-9]+ ' | wc -l)
NUM_WORKER=$(gcloud compute instances list | grep -E '^worker-[0-9]+ ' | wc -l)

NUM_PS=$(( NUM_PS - 1 ))
NUM_WORKER=$(( NUM_WORKER - 1 ))

# Stop parameter servers
for  i in $(seq 0 $NUM_PS); do
  echo "Terminating ps-${i}..."
  gcloud compute ssh ps-${i} -- pkill -f trainer/task.py
done

# Stop workers
for  i in $(seq 0 $NUM_WORKER); do
  echo "Terminating worker-${i}..."
  gcloud compute ssh worker-${i} -- pkill -f trainer/task.py
done

# Stop a master
echo "Terminating master-0..."
gcloud compute ssh master-0 -- pkill -f trainer/task.py

#!/bin/bash
if [ -n "$SUBJECT" ]; then
  echo "--> Downloading '$SUBJECT'..."
  curl -L $SUBJECT > /tf_files/test/animal
fi

echo "--> Running classification..."
python /tf_files/label_image.py /tf_files/test/animal 2>&1 | grep -vE "op_def_util.cc|cpu_feature_guard.cc"

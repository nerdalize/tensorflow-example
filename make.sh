#!/bin/bash
set -e

dev_profile="nerd-cli-dev"

function print_help {
	printf "Available Commands:\n";
	awk -v sq="'" '/^function run_([a-zA-Z0-9-]*)\s*/ {print "-e " sq NR "p" sq " -e " sq NR-1 "p" sq }' make.sh \
		| while read line; do eval "sed -n $line make.sh"; done \
		| paste -d"|" - - \
		| sed -e 's/^/  /' -e 's/function run_//' -e 's/#//' -e 's/{/	/' \
		| awk -F '|' '{ print "  " $2 "\t" $1}' \
		| expand -t 30
}

function run_train { #train the model
  command -v docker >/dev/null 2>&1 || { echo "executable 'docker' (container runtime) must be installed" >&2; exit 1; }
  docker run -v $(pwd)/tf_files:/tf_files tensorflow/tensorflow:latest-devel python /tensorflow/tensorflow/examples/image_retraining/retrain.py \
    --bottleneck_dir=/tf_files/bottlenecks \
    --how_many_training_steps 500 \
    --model_dir=/tf_files/inception \
    --output_graph=/tf_files/retrained_graph.pb \
    --output_labels=/tf_files/retrained_labels.txt \
    --image_dir /tf_files/animals
}

function run_build { #build the docker image
  command -v docker >/dev/null 2>&1 || { echo "executable 'docker' (container runtime) must be installed" >&2; exit 1; }
  docker build -t nerdalize/tensorflow-example .
}

function run_run { #run the Docker image
  command -v docker >/dev/null 2>&1 || { echo "executable 'docker' (container runtime) must be installed" >&2; exit 1; }
  docker run nerdalize/tensorflow-example
}


case $1 in
  "train") run_train ;;
	"build") run_build ;;
	"run") run_run ;;
	*) print_help ;;
esac

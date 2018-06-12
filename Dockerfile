FROM tensorflow/tensorflow:latest-devel
ADD tf_files /tf_files
ADD run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/run.sh"]

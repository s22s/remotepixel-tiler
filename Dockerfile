FROM s22s/amazonlinux:gdal2.4-jpkak-py3.7-geo

WORKDIR /tmp

ENV PYTHONUSERBASE=/var/task

COPY remotepixel_tiler/ remotepixel_tiler/
COPY setup.py setup.py

# Install dependencies
RUN pip3 install . --user
RUN rm -rf remotepixel_tiler setup.py
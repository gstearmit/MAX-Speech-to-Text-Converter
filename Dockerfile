FROM codait/max-base:v1.1.1

RUN apt-get update && apt-get install -y sox libsox2 libstdc++6 libgomp1 libpthread-stubs0-dev && rm -rf /var/lib/apt/lists/*

ARG model_bucket=http://max-assets.s3.us.cloud-object-storage.appdomain.cloud/speech-to-text-converter/1.0
ARG model_file=assets.tar.gz

WORKDIR /workspace

RUN wget -nv --show-progress --progress=bar:force:noscroll ${model_bucket}/${model_file} --output-document=/workspace/assets/${model_file}
RUN tar -x -C assets/ -f assets/${model_file} -v && rm assets/${model_file}

COPY requirements.txt /workspace
RUN pip install -r requirements.txt

COPY . /workspace

# check file integrity
RUN md5sum -c md5sums.txt

EXPOSE 5000

CMD python app.py
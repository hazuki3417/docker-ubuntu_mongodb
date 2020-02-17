# Please execute the following command to build
# docker build -t mongodb_v4.x this_file_path
# docker-compose build

# Please execute the following command to start it
# docker run -itd --name mongodb_v4.x -v mongodb_data:/var/lib/mongodb -p 27017:27017 mongodb_v4.x
# docker-compose up -d

# Please execute the following command to attach
# docker exec -it mongodb_v4.x /bin/bash

# ベースイメージを指定
FROM hazuki3417/ubuntu:latest
# 制作者情報を指定
LABEL maintainer="hazuki3417 <hazuki3417@gmail.com>"

# メイン処理
RUN : "apt-keyを追加" && \
	curl -O "https://www.mongodb.org/static/pgp/server-4.0.asc" && \
	apt-key add ./server-4.0.asc && \
	rm ./server-4.0.asc

RUN : "リポジトリを追加" && { \
	echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse"; \
	} | tee /etc/apt/sources.list.d/mongodb-org-4.0.list

ARG mongodb_config_path=/etc
RUN : "MongoDBをインストール" && \
	apt-get update && \
	apt-get install -y mongodb

RUN : "MongoDBの設定" && \
	echo ''

COPY config/mongodb/mongodb.conf ${mongodb_config_path}/

# サービス起動用のシェルスクリプト作成
RUN : "コンテナ起動時に起動するサービスを設定する" && { \
	echo '#!/bin/bash'; \
	echo 'mongod -f '${mongodb_config_path}/mongodb.conf; \
	echo '/bin/bash'; \
	} | tee /startup.sh
RUN chmod 744 /startup.sh

WORKDIR /
CMD [ "/startup.sh" ]

# 指定したポートを開放
EXPOSE 27017

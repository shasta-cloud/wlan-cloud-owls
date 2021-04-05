#Build stage 0

FROM alpine

RUN apk update && \
    apk add --no-cache openssl openssh && \
    apk add --no-cache ncurses-libs && \
    apk add --no-cache bash util-linux coreutils curl && \
    apk add --no-cache make cmake gcc g++ libstdc++ libgcc git zlib-dev yaml-cpp-dev && \
    apk add --no-cache openssl-dev boost-dev unixodbc-dev postgresql-dev mariadb-dev && \
    apk add --no-cache apache2-utils yaml-dev apr-util-dev

RUN mkdir /root/.ssh
ADD git_rsa /root/.ssh/git_rsa
RUN touch /root/.ssh/known_hosts
RUN chown -R root:root /root/.ssh
RUN chmod 600 /root/.ssh/git_rsa && \
    echo "IdentityFile /root/.ssh/git_rsa" >> /etc/ssh/ssh_config && \
    echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN git clone git@github.com:stephb9959/ucentral-clnt.git /ucentral-clnt

RUN git clone https://github.com/stephb9959/poco /poco
WORKDIR /poco
RUN mkdir cmake-build
WORKDIR cmake-build
RUN cmake ..
RUN cmake --build . --config Release
RUN cmake --build . --target install
WORKDIR /ucentral-clnt
RUN mkdir cmake-build
WORKDIR /ucentral-clnt/cmake-build
RUN cmake ..
RUN cmake --build . --config Release

RUN mkdir /ucentral-clnt
RUN cp /ucentral-clnt/cmake-build/ucentral_clnt /ucentral/ucentral_clnt
RUN chmod +x /ucentral-clnt/ucentral_clnt
RUN mkdir /ucentral-data

RUN rm -rf /poco
RUN rm -rf /ucentral-clnt

EXPOSE 15002
EXPOSE 16001
EXPOSE 16003

ENTRYPOINT /ucentral-clnt/ucentral_clnt



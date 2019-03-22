FROM alpine:3.9

# Build parameters --build-arg
ARG USER=node
ARG DIR=/home/node
ARG LOGDIR=/var/log/node

# Install base tools
RUN apk update
RUN apk add --no-cache bash curl make gcc g++ python linux-headers binutils-gold gnupg libstdc++ nodejs npm

# Install global PM2
RUN npm install -g pm2@latest \
    && pm2 install pm2-logrotate \
    && pm2 set pm2-logrotate:retain 7

# USER dirs and Permissions
RUN addgroup -S node && adduser -S node -G node

RUN mkdir $LOGDIR

WORKDIR $DIR
USER $USER

COPY . .
# Install node-modules
RUN npm install

# Hack for permissions
USER root
RUN chown -R $USER:$USER $DIR
RUN chown -R $USER:$USER $LOGDIR
USER $USER

EXPOSE 3000

CMD bash -C 'start.sh'; 'bash'

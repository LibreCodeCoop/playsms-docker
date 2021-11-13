# playSMS

[playSMS](https://github.com/playsms/playsms) is a web interface for SMS gateways and bulk SMS services.

Reade more on: https://github.com/playsms/playsms

## Setup with docker-compose

Steps:

* Clone this repository
* Copy .env.example .env
  * Update the .env if necessary
* docker-compose up -d

> **PS**: Check the timesone on .env and on .docker/app/config/php.ini

## Enable gateway plugin

Replace `<gateway>` by that gateway you want to enable. Example gateway plugin: twilio

```
docker-compose exec app cp -r ../data/src/storage/application/plugin/gateway/<gateway>/ plugin/gateway
```

# playSMS with docker-compose

[playSMS](https://github.com/playsms/playsms) is a web interface for SMS gateways and bulk SMS services.

Reade more on: https://github.com/playsms/playsms

## Setup with docker-compose

Steps:

* Clone this repository
* Copy .env.example .env
  * Update the .env if necessary
* docker-compose up -d

> **PS**: Check the timesone on .env and on .docker/app/config/php.ini

## Configure

### Enable gateway plugin

Replace `<gateway>` by that gateway you want to enable. Example gateway plugin: [twilio](https://playsms.org/2020/04/30/gateway-plugin-twilio/)

```
docker-compose exec app cp -r ../data/src/storage/application/plugin/gateway/<gateway>/ plugin/gateway
```

### User configuration

To use with Nextcloud app [twofactor_gateway](github.com/nextcloud/twofactor_gateway) you will need define `webservices token` and will use the token as password on configuration stepts of `twofactor_gateway`.

Go to `my account > User configuration`

| Setting                   | description                                                             |
| ------------------------- | ----------------------------------------------------------------------- |
| `Renew webservices token` | `Yes`. After you save you will see the new token on `Webservices token` |
| `Enable webservices`      | `Yes`!                                                                  |
| `Webservices IP range`    | Put the IP of your Nextcloud                                            |
| `Default message footer`  | Remove if you don't want to put a footer on all sms                     |
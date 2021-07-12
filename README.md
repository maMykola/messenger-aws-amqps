## Requirements

* Docker
* Composer 2.0

Add the following line into `/etc/hosts`:
```
127.0.0.1   rabbitmq.local
```

## Steps to reproduce

```shell
$ git clone https://github.com/maMykola/messenger-aws-amqps
$ cd messenger-aws-amqps
$ composer install
$ .ops/provision.sh
$ docker-compose up -d
$ symfony console messenger:setup
$ symfony console app:dispatch-test-message
$ symfony console messenger:consume async -vv
```

## Example output

```log
[info] App\Message\TestMessage was handled successfully (acknowledging to transport).

[critical] Error thrown while running command "messenger:consume async -vv". Message: "Library error: a SSL error occurred"


In AmqpReceiver.php line 62:
                                                              
  [Symfony\Component\Messenger\Exception\TransportException]  
  Library error: a SSL error occurred                         
                                                              
```

---

### Solution with HAProxy

Put `MESSENGER_TRANSPORT_DSN=amqps://username:password@localhost:25671/%2f/messages?cacert=/path/to/cacert.pem`
with appropriate data into `.env.local` file after the cloning the repo.

```shell
$ git clone https://github.com/maMykola/messenger-aws-amqps
$ cd messenger-aws-amqps
$ echo "MESSENGER_TRANSPORT_DSN=amqps://username:password@localhost:25671/%2f/messages?cacert=/path/to/cacert.pem" > .env.local
$ composer install
$ env HAPROXY_RABBITMQ_HOST=rabbitmq-host-on-aws.amazonaws.com docker-compose up -d
$ symfony console messenger:setup
$ symfony console app:dispatch-test-message
$ symfony console messenger:consume async -vv
```

All works fine without connection exception.

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

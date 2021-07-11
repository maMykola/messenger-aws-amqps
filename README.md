# How to reproduce

Create `.env.local` and fill `MESSENGER_TRANSPORT_DSN` with `amqps://username:password@aws-mq.amazon.com/%2f/messages?cacert=/path/to/ca.pem`
with appropriate data.

### CA Cert paths

`OSX`: `/usr/local/etc/openssl@1.1/cert.pem`

`Linux`: `/etc/ssl/certs/ca-certificates.crt`

### Steps
```shell
$ symfony console messenger:setup
$ symfony console app:dispatch-test-message
$ symfony console messenger:consume async -vv
```

Example output:
```log
[info] App\Message\TestMessage was handled successfully (acknowledging to transport).

[critical] Error thrown while running command "messenger:consume async -vv". Message: "Library error: a SSL error occurred"


In AmqpReceiver.php line 62:
                                                              
  [Symfony\Component\Messenger\Exception\TransportException]  
  Library error: a SSL error occurred                         
                                                              

```

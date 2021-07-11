<?php


namespace App\MessageHandler;

use App\Message\TestMessage;
use Psr\Log\LoggerInterface;
use Symfony\Component\Messenger\Handler\MessageHandlerInterface;


class TestMessageHandler implements MessageHandlerInterface
{
    // all constants in seconds
    private const DURATION   = 700;
    private const INTERVAL   = 30;
    private const SLEEP_TIME = 5;

    protected ?LoggerInterface $logger;

    public function __construct(LoggerInterface $logger = null)
    {
        $this->logger = $logger;
    }

    public function __invoke(TestMessage $message): void
    {
        $start = microtime(true);
        while (self::DURATION > ($delta = microtime(true) - $start)) {
            if (0 === $delta % self::INTERVAL && $this->logger) {
                $this->logger->info(sprintf('%d seconds remaining.', self::DURATION - round($delta)));
            }

            sleep(self::SLEEP_TIME);
        }
    }
}

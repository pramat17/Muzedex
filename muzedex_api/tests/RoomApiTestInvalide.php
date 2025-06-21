<?php

namespace App\Tests\Api;

use ApiPlatform\Symfony\Bundle\Test\ApiTestCase;
use Doctrine\ORM\EntityManagerInterface;

class RoomApiTestInvalide extends ApiTestCase
{
    private EntityManagerInterface $entityManager;

    protected function setUp(): void
    {
        $this->entityManager = static::getContainer()->get('doctrine')->getManager();
    }

    public function testGetInvalidRoom(): void
    {
        static::createClient()->request('GET', '/api/rooms/999999', [
            'headers' => ['Accept' => 'application/ld+json'],
        ]);

        $this->assertResponseStatusCodeSame(404);
    }

    public function testGetInvalidRoomCollection(): void
    {
        $response = static::createClient()->request('GET', '/api/rooms', [
            'headers' => ['Accept' => 'application/ld+json'],
        ]);

        $this->assertResponseStatusCodeSame(200);

        $responseData = $response->toArray();
        $this->assertArrayHasKey('hydra:member', $responseData);

        $rooms = array_column($responseData['hydra:member'], 'name');
        $this->assertNotContains('Invalid Room', $rooms);
    }

    protected function tearDown(): void
    {
        $this->entityManager->createQuery('DELETE FROM App\Entity\Room')->execute();
        parent::tearDown();
    }
}

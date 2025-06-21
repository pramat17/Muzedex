<?php

namespace App\Tests\Api;

use ApiPlatform\Symfony\Bundle\Test\ApiTestCase;
use Doctrine\ORM\EntityManagerInterface;

class ItemApiTestInvalide extends ApiTestCase
{
    private EntityManagerInterface $entityManager;

    protected function setUp(): void
    {
        $this->entityManager = static::getContainer()->get('doctrine')->getManager();
    }

    public function testGetInvalidItem(): void
    {
        static::createClient()->request('GET', '/api/items/999999', [
            'headers' => ['Accept' => 'application/ld+json'],
        ]);

        $this->assertResponseStatusCodeSame(404);
    }

    public function testGetInvalidItemCollection(): void
    {
        $response = static::createClient()->request('GET', '/api/items', [
            'headers' => ['Accept' => 'application/ld+json'],
        ]);

        $this->assertResponseStatusCodeSame(200);

        $responseData = $response->toArray();
        $this->assertArrayHasKey('hydra:member', $responseData);

        $items = array_column($responseData['hydra:member'], 'name');
        $this->assertNotContains('Invalid Item', $items);
    }

    protected function tearDown(): void
    {
        $this->entityManager->createQuery('DELETE FROM App\Entity\Item')->execute();
        parent::tearDown();
    }
}

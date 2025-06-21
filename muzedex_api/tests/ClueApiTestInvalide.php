<?php

namespace App\Tests\Api;

use ApiPlatform\Symfony\Bundle\Test\ApiTestCase;
use Doctrine\ORM\EntityManagerInterface;

class CluesApiTestInvalide extends ApiTestCase
{
    private EntityManagerInterface $entityManager;

    protected function setUp(): void
    {
        $this->entityManager = static::getContainer()->get('doctrine')->getManager();
    }

    public function testGetInvalidClue(): void
    {
        static::createClient()->request('GET', '/api/clues/999999', [
            'headers' => ['Accept' => 'application/ld+json'],
        ]);

        $this->assertResponseStatusCodeSame(404);
    }

    public function testGetInvalidClueCollection(): void
    {
        $response = static::createClient()->request('GET', '/api/clues', [
            'headers' => ['Accept' => 'application/ld+json'],
        ]);

        $this->assertResponseStatusCodeSame(200);

        $responseData = $response->toArray();
        $this->assertArrayHasKey('hydra:member', $responseData);

        $clues = array_column($responseData['hydra:member'], 'text');
        $this->assertNotContains('Invalid Clue', $clues);
    }

    protected function tearDown(): void
    {
        $this->entityManager->createQuery('DELETE FROM App\Entity\Clue')->execute();
        $this->entityManager->createQuery('DELETE FROM App\Entity\Item')->execute();
        $this->entityManager->createQuery('DELETE FROM App\Entity\Room')->execute();

        parent::tearDown();
    }
}

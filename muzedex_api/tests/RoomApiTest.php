<?php

namespace App\Tests\Api;

use ApiPlatform\Symfony\Bundle\Test\ApiTestCase;
use App\Entity\Room;
use Doctrine\ORM\EntityManagerInterface;

class RoomApiTest extends ApiTestCase
{
    private EntityManagerInterface $entityManager;

    protected function setUp(): void
    {
        $this->entityManager = static::getContainer()->get('doctrine')->getManager();
    }

    public function testGetCollection(): void
    {
        // Récupérer le nombre initial de salles
        $response = static::createClient()->request('GET', '/api/rooms', [
            'headers' => ['Accept' => 'application/ld+json'],
        ]);

        $this->assertResponseIsSuccessful();
        $responseData = $response->toArray();
        $initialCount = count($responseData['hydra:member']);

        // Ajouter deux nouvelles salles
        $room1 = new Room();
        $room1->setName('Room A')->setNumber(1)->setFloor(0)->setPosition('10,20');
        $room2 = new Room();
        $room2->setName('Room B')->setNumber(2)->setFloor(1)->setPosition('30,40');

        $this->entityManager->persist($room1);
        $this->entityManager->persist($room2);
        $this->entityManager->flush();

        // Récupérer la collection après ajout
        $response = static::createClient()->request('GET', '/api/rooms', [
            'headers' => ['Accept' => 'application/ld+json'],
        ]);

        $this->assertResponseIsSuccessful();
        $responseData = $response->toArray();
        $updatedCount = count($responseData['hydra:member']);

        // Vérifier que deux salles ont été ajoutées
        $this->assertSame($initialCount + 2, $updatedCount);

        // Optionnel : Vérifiez que les nouvelles salles sont dans la réponse
        $roomNames = array_column($responseData['hydra:member'], 'name');
        $this->assertContains('Room A', $roomNames);
        $this->assertContains('Room B', $roomNames);
    }

    public function testGetRoom(): void
    {
        $room = new Room();
        $room->setName('Room 202')->setNumber(202)->setFloor(2)->setPosition('50,60');
        $this->entityManager->persist($room);
        $this->entityManager->flush();

        static::createClient()->request('GET', '/api/rooms/' . $room->getId());

        $this->assertResponseIsSuccessful();
        $this->assertJsonContains([
            'name' => 'Room 202',
            'number' => 202,
            'floor' => 2,
            'position' => '50,60',
        ]);
    }

    protected function tearDown(): void
    {
        $this->entityManager->createQuery('DELETE FROM App\Entity\Room')->execute();
        parent::tearDown();
    }
}

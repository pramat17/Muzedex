<?php

namespace App\Tests\Api;

use ApiPlatform\Symfony\Bundle\Test\ApiTestCase;
use App\Entity\Item;
use App\Entity\Room;
use Doctrine\ORM\EntityManagerInterface;

class ItemApiTest extends ApiTestCase
{
    private EntityManagerInterface $entityManager;

    protected function setUp(): void
    {
        $this->entityManager = static::getContainer()->get('doctrine')->getManager();
    }

    private function createRoom(): Room
    {
        $room = new Room();
        $room->setName('Room 101')->setNumber(101)->setFloor(1);
        $this->entityManager->persist($room);
        $this->entityManager->flush();

        return $room;
    }


    public function testGetItem(): void
    {
        $room = $this->createRoom();
        $item = new Item();
        $item->setName('Test Item')
            ->setDescription('This is a test item.')
            ->setTags(['tag1', 'tag2'])
            ->setImageLink('http://example.com/image.png')
            ->setCoordinates('123,456')
            ->setRoom($room);

        $this->entityManager->persist($item);
        $this->entityManager->flush();

        static::createClient()->request('GET', '/api/items/' . $item->getId());

        $this->assertResponseIsSuccessful();
        $this->assertJsonContains([
            'name' => 'Test Item',
            'description' => 'This is a test item.',
        ]);
    }
    public function testGetItemCollection(): void
    {
        $response = static::createClient()->request('GET', '/api/items');
        $this->assertResponseIsSuccessful();
        $responseData = $response->toArray();
        $initialCount = count($responseData['hydra:member']);

        // Ajouter deux items
        $room = $this->createRoom();
        $item1 = new Item();
        $item1->setName('Item 1')
            ->setDescription('First item')
            ->setTags(['tag1'])
            ->setImageLink('http://example.com/image1.png')
            ->setCoordinates('123,456')
            ->setRoom($room);

        $item2 = new Item();
        $item2->setName('Item 2')
            ->setDescription('Second item')
            ->setTags(['tag2'])
            ->setImageLink('http://example.com/image2.png')
            ->setCoordinates('789,012')
            ->setRoom($room);

        $this->entityManager->persist($item1);
        $this->entityManager->persist($item2);
        $this->entityManager->flush();

        // Vérifier que la collection contient les nouveaux items
        $response = static::createClient()->request('GET', '/api/items');
        $this->assertResponseIsSuccessful();
        $responseData = $response->toArray();
        $updatedCount = count($responseData['hydra:member']);

        $this->assertSame($initialCount + 2, $updatedCount);

        // Vérifier que les items sont présents
        $names = array_column($responseData['hydra:member'], 'name');
        $this->assertContains('Item 1', $names);
        $this->assertContains('Item 2', $names);
    }
}

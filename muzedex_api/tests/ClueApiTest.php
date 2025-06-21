<?php

namespace App\Tests\Api;

use ApiPlatform\Symfony\Bundle\Test\ApiTestCase;
use App\Entity\Clue;
use App\Entity\Item;
use App\Entity\Room;
use Doctrine\ORM\EntityManagerInterface;

class ClueApiTest extends ApiTestCase
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

    private function createItem(Room $room): Item
    {
        $item = new Item();
        $item->setName('Item A')
            ->setDescription('Test Item')
            ->setTags(['tag1', 'tag2'])
            ->setImageLink('http://example.com/image.png')
            ->setCoordinates('123,456')
            ->setRoom($room);
        $this->entityManager->persist($item);
        $this->entityManager->flush();

        return $item;
    }

    public function testGetClue(): void
    {
        $room = $this->createRoom();
        $item = $this->createItem($room);

        $clue = new Clue();
        $clue->setType('Hint')
            ->setText('A sample clue.')
            ->setItem($item);

        $this->entityManager->persist($clue);
        $this->entityManager->flush();

        static::createClient()->request('GET', '/api/clues/' . $clue->getId(), [
            'headers' => ['Accept' => 'application/ld+json'],
        ]);

        $this->assertResponseStatusCodeSame(200);
        $this->assertJsonContains([
            'id' => $clue->getId(),
            'type' => 'Hint',
            'text' => 'A sample clue.',
        ]);
    }

    public function testGetClueCollection(): void
    {
        $room = $this->createRoom();
        $item = $this->createItem($room);

        $clue1 = new Clue();
        $clue1->setType('Hint')->setText('Clue 1')->setItem($item);

        $clue2 = new Clue();
        $clue2->setType('Hint')->setText('Clue 2')->setItem($item);

        $this->entityManager->persist($clue1);
        $this->entityManager->persist($clue2);
        $this->entityManager->flush();

        $response = static::createClient()->request('GET', '/api/clues', [
            'headers' => ['Accept' => 'application/ld+json'],
        ]);

        $this->assertResponseStatusCodeSame(200);

        $responseData = $response->toArray();
        $this->assertArrayHasKey('hydra:member', $responseData);

        $clues = array_column($responseData['hydra:member'], 'text');
        $this->assertContains('Clue 1', $clues);
        $this->assertContains('Clue 2', $clues);
    }

    protected function tearDown(): void
    {
        $this->entityManager->createQuery('DELETE FROM App\Entity\Clue')->execute();
        $this->entityManager->createQuery('DELETE FROM App\Entity\Item')->execute();
        $this->entityManager->createQuery('DELETE FROM App\Entity\Room')->execute();

        parent::tearDown();
    }
}

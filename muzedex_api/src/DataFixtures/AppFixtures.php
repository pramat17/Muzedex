<?php

namespace App\DataFixtures;

use App\Factory\ClueFactory;
use App\Factory\ItemFactory;
use App\Factory\RoomFactory;
use App\Service\ImageService;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ManagerRegistry;
use Doctrine\Persistence\ObjectManager;

class AppFixtures extends Fixture
{
    private ManagerRegistry $doctrine;
    private ImageService $imageService;

    public function __construct(ManagerRegistry $doctrine, ImageService $imageService)
    {
        $this->doctrine = $doctrine;
        $this->imageService = $imageService;
    }
    public function load(ObjectManager $manager): void
    {


        // Create the museum's rooms
        RoomFactory::createPredefinedRooms();

        ItemFactory::createPredefinedItems($this->doctrine, $this->imageService);

        ClueFactory::createCluesForAllItems($this->doctrine);
    }
}

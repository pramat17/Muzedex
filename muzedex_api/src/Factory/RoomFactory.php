<?php

namespace App\Factory;

use App\Entity\Room;
use App\Repository\RoomRepository;
use Zenstruck\Foundry\Persistence\PersistentProxyObjectFactory;
use Zenstruck\Foundry\Persistence\Proxy;
use Zenstruck\Foundry\Persistence\ProxyRepositoryDecorator;

/**
 * @extends PersistentProxyObjectFactory<Room>
 *
 * @method        Room|Proxy                              create(array|callable $attributes = [])
 * @method static Room|Proxy                              createOne(array $attributes = [])
 * @method static Room|Proxy                              find(object|array|mixed $criteria)
 * @method static Room|Proxy                              findOrCreate(array $attributes)
 * @method static Room|Proxy                              first(string $sortedField = 'id')
 * @method static Room|Proxy                              last(string $sortedField = 'id')
 * @method static Room|Proxy                              random(array $attributes = [])
 * @method static Room|Proxy                              randomOrCreate(array $attributes = [])
 * @method static RoomRepository|ProxyRepositoryDecorator repository()
 * @method static Room[]|Proxy[]                          all()
 * @method static Room[]|Proxy[]                          createMany(int $number, array|callable $attributes = [])
 * @method static Room[]|Proxy[]                          createSequence(iterable|callable $sequence)
 * @method static Room[]|Proxy[]                          findBy(array $attributes)
 * @method static Room[]|Proxy[]                          randomRange(int $min, int $max, array $attributes = [])
 * @method static Room[]|Proxy[]                          randomSet(int $number, array $attributes = [])
 */
final class RoomFactory extends PersistentProxyObjectFactory
{
    /**
     * @see https://symfony.com/bundles/ZenstruckFoundryBundle/current/index.html#factories-as-services
     *
     */
    public function __construct()
    {
    }

    public static function class(): string
    {
        return Room::class;
    }

    /**
     * @see https://symfony.com/bundles/ZenstruckFoundryBundle/current/index.html#model-factories
     *
     */
    protected function defaults(): array|callable
    {
        return [];
    }

    public static function createPredefinedRooms(): void
    {
        $roomsData = [
            // ROOMS RDC
            ['floor' => 0, 'name' => 'Accueil', 'number' => 1, 'position' => '42;20'],
            ['floor' => 0, 'name' => 'Les marais litoraux', 'number' => 2, 'position' => '31;19'],
            ['floor' => 0, 'name' => 'Les oiseaux seigneurs des marais', 'number' => 3, 'position' => '17;33'],
            ['floor' => 0, 'name' => 'Le marais un territoire menacé', 'number' => 4, 'position' => '17;45'],
            ['floor' => 0, 'name' => 'Le cabinet Lafaille', 'number' => 5, 'position' => '17;19'],
            //ROOMS ETAGE 1
            ['floor' => 1, 'name' => 'La galerie de zoologie', 'number' => 9, 'position' => '16;35'],
            ['floor' => 1, 'name' => 'Faune de la côte aux abysses', 'number' => 10, 'position' => '31;15'],
            ['floor' => 1, 'name' => 'Les campagnes océanographiques', 'number' => 11, 'position' => '35;47'],
            ['floor' => 1, 'name' => 'Mollusques et environnements tropicaux', 'number' => 12, 'position' => '31;63'],
            ['floor' => 1, 'name' => 'Le cabinet de dessins du muséum', 'number' => 13, 'position' => '42;19'],
            ['floor' => 1, 'name' => 'Voyageurs naturalistes charentais', 'number' => 14, 'position' => '53;20'],
            ['floor' => 1, 'name' => 'Découvertes des voyageurs naturalistes charentais', 'number' => 15, 'position' => '69;20'],
            ['floor' => 1, 'name' => 'Dernière grande expédition scientifique', 'number' => 16, 'position' => '75;10'],
            // ROOMS ETAGE 2
            ['floor' => 2, 'name' => 'Etienne Loppé, Une vision du monde', 'number' => 17, 'position' => '70;35'],
            ['floor' => 2, 'name' => 'Après les explorations scientifiques', 'number' => 18, 'position' => '70;55'],
            ['floor' => 2, 'name' => 'Les étages du regard occidental', 'number' => 19, 'position' => '70;10'],
            ['floor' => 2, 'name' => 'La préhistoire et la protohistoire africaine', 'number' => 20, 'position' => '63;21'],
            ['floor' => 2, 'name' => 'La métallurgie africaine', 'number' => 21, 'position' => '44;20'],
            ['floor' => 2, 'name' => "Parures et signes de l'ordre social", 'number' => 22, 'position' => '31;20'],
            ['floor' => 2, 'name' => 'Arts décoratifs extra-européens', 'number' => 23, 'position' => '17;15'],
            ['floor' => 2, 'name' => 'Les arts musicaux', 'number' => 24, 'position' => '17;64'],
            // ROOMS ETAGE 3
            ['floor' => 3, 'name' => 'Interpréter la nature', 'number' => 25, 'position' => '43;37'],
            ['floor' => 3, 'name' => 'Un médiateur le chaman aux Amériques', 'number' => 26, 'position' => '71;55'],
        ];
        foreach ($roomsData as $roomData) {
            self::createOne($roomData);
        }
    }

    /**
     * @see https://symfony.com/bundles/ZenstruckFoundryBundle/current/index.html#initialization
     */
    protected function initialize(): static
    {
        return $this
            // ->afterInstantiate(function(Room $room): void {})
        ;
    }
}

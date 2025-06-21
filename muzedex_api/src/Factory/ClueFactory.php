<?php

namespace App\Factory;

use App\Entity\Clue;
use App\Entity\Item;
use App\Repository\ClueRepository;
use Doctrine\Persistence\ManagerRegistry;
use Zenstruck\Foundry\Persistence\PersistentProxyObjectFactory;
use Zenstruck\Foundry\Persistence\Proxy;
use Zenstruck\Foundry\Persistence\ProxyRepositoryDecorator;

/**
 * @extends PersistentProxyObjectFactory<Clue>
 *
 * @method        Clue|Proxy                              create(array|callable $attributes = [])
 * @method static Clue|Proxy                              createOne(array $attributes = [])
 * @method static Clue|Proxy                              find(object|array|mixed $criteria)
 * @method static Clue|Proxy                              findOrCreate(array $attributes)
 * @method static Clue|Proxy                              first(string $sortedField = 'id')
 * @method static Clue|Proxy                              last(string $sortedField = 'id')
 * @method static Clue|Proxy                              random(array $attributes = [])
 * @method static Clue|Proxy                              randomOrCreate(array $attributes = [])
 * @method static ClueRepository|ProxyRepositoryDecorator repository()
 * @method static Clue[]|Proxy[]                          all()
 * @method static Clue[]|Proxy[]                          createMany(int $number, array|callable $attributes = [])
 * @method static Clue[]|Proxy[]                          createSequence(iterable|callable $sequence)
 * @method static Clue[]|Proxy[]                          findBy(array $attributes)
 * @method static Clue[]|Proxy[]                          randomRange(int $min, int $max, array $attributes = [])
 * @method static Clue[]|Proxy[]                          randomSet(int $number, array $attributes = [])
 */
final class ClueFactory extends PersistentProxyObjectFactory
{
    private ManagerRegistry $doctrine;

    public function __construct(ManagerRegistry $doctrine)
    {
        $this->doctrine = $doctrine;
        parent::__construct();
    }

    public static function class(): string
    {
        return Clue::class;
    }

    protected function defaults(): array|callable
    {
        return [
            'item' => ItemFactory::new(),
            'text' => self::faker()->sentence(),
            'type' => "Shadobject",
        ];
    }

    public static function createCluesForAllItems(ManagerRegistry $doctrine): void
    {
        $entityManager = $doctrine->getManager();
        $itemRepository = $entityManager->getRepository(Item::class);
        $items = $itemRepository->findAll();

        foreach ($items as $item) {
            $clueTypes = [
                ['text' => 'Que se cache derrière cette ombre ?', 'type' => 'Shadobject'],
                ['text' => 'A qui appartient cette description ?', 'type' => 'Qui-suis-je ?'],
                ['text' => 'Que se cache derrière cette image floue ?', 'type' => 'FlouFou'],
            ];

            shuffle($clueTypes);

            foreach ($clueTypes as $clueType) {
                self::createOne([
                    'item' => $item,
                    'text' => $clueType['text'],
                    'type' => $clueType['type'],
                ]);
            }
        }
    }

    protected function initialize(): static
    {
        return $this;
    }
}

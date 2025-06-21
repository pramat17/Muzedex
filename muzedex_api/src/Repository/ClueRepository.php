<?php

namespace App\Repository;

use App\Entity\Clue;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Clue>
 *
 * @method Clue|null find($id, $lockMode = null, $lockVersion = null)
 * @method Clue|null findOneBy(array $criteria, array $orderBy = null)
 * @method Clue[]    findAll()
 * @method Clue[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class ClueRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Clue::class);
    }
}

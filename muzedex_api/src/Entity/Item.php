<?php

namespace App\Entity;

use ApiPlatform\Doctrine\Orm\Filter\SearchFilter;
use ApiPlatform\Metadata\ApiFilter;
use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use App\Repository\ItemRepository;
use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Serializer\Annotation\Groups;
use Doctrine\Common\Collections\Collection;
use Doctrine\Common\Collections\ArrayCollection;

#[ORM\Entity(repositoryClass: ItemRepository::class)]
#[ApiResource(
    operations: [
        new Get(),
        new GetCollection(),
    ],
    normalizationContext: ['groups' => ['item:read']],
    denormalizationContext: ['groups' => ['item:write']],
)]
class Item
{
    public const TAGS = [
        'Mammifères', 'Reptiles', 'Oiseaux', 'Amphibiens', 'Poissons', 'Insectes', 'Arachnides', 'Fossiles', 'Prédateurs', 'Herbivores', 'Omnivores', 'Carnivores', 'Espèces disparues', 'Écosystèmes marins', 'Écosystèmes terrestres', 'Forêts tropicales', 'Déserts', 'Polaires', 'Domestiques', 'Sauvages',
        'Préhistoire', 'Paléolithique', 'Néolithique', 'Égypte ancienne', 'Grèce antique', 'Rome antique', 'Mésopotamie', 'Inca', 'Aztèque', 'Maya', 'Celtes', 'Vikings', 'Civilisations africaines', 'Civilisations asiatiques', 'Moyen Âge', 'Renaissance', 'Objets rituels', 'Objets funéraires', 'Art religieux', 'Outils anciens',
        'Outils de chasse', 'Armes anciennes', 'Bijoux', 'Céramiques', 'Masques', 'Sculptures', 'Fresques', 'Manuscrits', 'Peintures rupestres', "Fossiles d'animaux", 'Squelettes humains', 'Amulettes', 'Instruments de musique', 'Textiles', 'Vêtements traditionnels', 'Pièces de monnaie', 'Mobilier ancien',
        'Europe', 'Afrique', 'Asie', 'Amériques', 'Océanie', 'Antarctique', 'Montagnes', 'Rivières', 'Forêts', 'Déserts', 'Océans', 'Archipels', 'Grottes', 'Volcans',
        'Jurassique', 'Crétacé', 'Âge de pierre', 'Âge de bronze', 'Âge de fer', 'Antiquité', 'Époques médiévales', 'Renaissance', 'Époque moderne', 'Contemporain', 'Périodes glaciaires', 'Extinctions massives',
        'Artisanat', 'Mythologie', 'Symbolisme', 'Échanges culturels', 'Vie quotidienne', 'Habitat naturel', 'Adaptation au climat', 'Diversité biologique', 'Archéologie', 'Paléontologie', 'Ethnographie', 'Exploration scientifique'
    ];

    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    #[Groups(['item:read', 'room:read'])]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    #[Groups(['item:read', 'room:read', 'item:write'])]
    #[Assert\NotBlank(message: 'The name field cannot be blank.')]
    #[ApiFilter(SearchFilter::class, strategy: 'ipartial')]
    private ?string $name = null;

    #[ORM\Column(type: Types::TEXT)]
    #[Groups(['item:read', 'room:read', 'item:write'])]
    private ?string $description = null;

    #[ORM\Column(type: Types::SIMPLE_ARRAY)]
    #[Groups(['item:read', 'room:read', 'item:write'])]
    #[Assert\Choice(
        choices: self::TAGS,
        multiple: true,
    )]
    private array $tags = [];

    #[ORM\Column(length: 512)]
    #[Groups(['item:read', 'room:read', 'item:write'])]
    private ?string $imageLink = null;

    #[ORM\Column(type: Types::TEXT)]
    #[Groups(['item:read', 'room:read', 'item:write'])]
    private ?string $coordinates = null;

    #[ORM\ManyToOne(inversedBy: 'items')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    #[Groups(['item:read', 'item:write'])]
    private ?Room $room = null;

    #[ORM\OneToMany(mappedBy: 'item', targetEntity: Clue::class, cascade: ['persist', 'remove'])]
    #[Groups(['item:read', 'room:read'])]
    private Collection $clues;

    #[ORM\Column(type: 'boolean', options: ['default' => false])]
    #[Groups(['item:read', 'item:write'])]
    private bool $isFound = false;

    #[ORM\Column(length: 512, nullable: true)]
    #[Groups(['item:read', 'item:write', 'room:read'])]
    private ?string $whoAmI = null;

    #[ORM\Column(type: 'boolean', options: ['default' => false])]
    #[Groups(['item:read', 'item:write'])]
    private ?bool $isRevealed = false;

    public function __construct()
    {
        $this->clues = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): static
    {
        $this->name = $name;

        return $this;
    }

    public function getDescription(): ?string
    {
        return $this->description;
    }

    public function setDescription(string $description): static
    {
        $this->description = $description;

        return $this;
    }

    public function getTags(): array
    {
        return $this->tags;
    }

    public function setTags(array $tags): static
    {
        $this->tags = $tags;

        return $this;
    }

    public function getImageLink(): ?string
    {
        return $this->imageLink;
    }

    public function setImageLink(?string $imageLink): static
    {
        $this->imageLink = $imageLink;

        return $this;
    }

    public function getCoordinates(): ?string
    {
        return $this->coordinates;
    }

    public function setCoordinates(?string $coordinates): static
    {
        $this->coordinates = $coordinates;

        return $this;
    }

    public function getRoom(): ?Room
    {
        return $this->room;
    }

    public function setRoom(?Room $room): static
    {
        $this->room = $room;

        return $this;
    }

    public function getClues(): Collection
    {
        return $this->clues;
    }

    public function addClue(Clue $clue): static
    {
        if (!$this->clues->contains($clue)) {
            $this->clues->add($clue);
            $clue->setItem($this);
        }

        return $this;
    }

    public function removeClue(Clue $clue): static
    {
        if ($this->clues->removeElement($clue) && ($clue->getItem() === $this)) {
            $clue->setItem(null);
        }

        return $this;
    }

    public function getIsFound(): bool
    {
        return $this->isFound;
    }

    public function setIsFound(bool $isFound): self
    {
        $this->isFound = $isFound;

        return $this;
    }

    public function getWhoAmI(): ?string
    {
        return $this->whoAmI;
    }

    public function setWhoAmI(?string $whoAmI): static
    {
        $this->whoAmI = $whoAmI;

        return $this;
    }

    public function isIsRevealed(): ?bool
    {
        return $this->isRevealed;
    }

    public function setIsRevealed(bool $isrevealed): static
    {
        $this->isRevealed = $isrevealed;

        return $this;
    }
}

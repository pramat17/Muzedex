<?php

namespace App\Entity;

use ApiPlatform\Metadata\ApiResource;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Serializer\Annotation\Groups;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity]
#[ApiResource(
    operations: [
        new Get(),
        new GetCollection(),
    ],
    normalizationContext: ['groups' => ['clue:read']],
    denormalizationContext: ['groups' => ['clue:write']],
)]
class Clue
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    #[Groups(['clue:read', 'item:read'])]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    #[Groups(['clue:read', 'item:read', 'clue:write'])]
    #[Assert\Choice(
        choices: ['Shadobject', 'Objectif Flou', 'Qui-suis-je ?'],
        message: "The type field must contain an allowed value"
    )]
    private ?string $type = null;

    #[ORM\Column(length: 255)]
    #[Groups(['clue:read', 'item:read', 'clue:write'])]
    private ?string $text = null;

    #[ORM\ManyToOne(inversedBy: 'clues')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    #[Groups(['clue:read', 'clue:write'])]
    private ?Item $item = null;


    public function getId(): ?int
    {
        return $this->id;
    }

    public function getType(): ?string
    {
        return $this->type;
    }

    public function setType(string $type): static
    {
        $this->type = $type;

        return $this;
    }

    public function getText(): ?string
    {
        return $this->text;
    }

    public function setText(string $text): static
    {
        $this->text = $text;

        return $this;
    }

    public function getItem(): ?Item
    {
        return $this->item;
    }

    public function setItem(?Item $item): static
    {
        $this->item = $item;

        return $this;
    }
}

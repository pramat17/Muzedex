<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Migration corrigée pour éviter les conflits avec des tables existantes.
 */
final class Version20241209133709 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajoute les tables clue, item et room avec leurs relations';
    }

    public function up(Schema $schema): void
    {
        // Vérifie l'existence des tables avant de les créer
        $this->addSql('DROP TABLE IF EXISTS clue');
        $this->addSql('DROP TABLE IF EXISTS item');
        $this->addSql('DROP TABLE IF EXISTS room');

        // Création de la table room
        $this->addSql('CREATE TABLE room (
            id INT AUTO_INCREMENT NOT NULL,
            name VARCHAR(255) NOT NULL,
            number INT NOT NULL,
            floor INT NOT NULL,
            PRIMARY KEY(id)
        ) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');

        // Création de la table item
        $this->addSql('CREATE TABLE item (
            id INT AUTO_INCREMENT NOT NULL,
            room_id INT NOT NULL,
            name VARCHAR(255) NOT NULL,
            description LONGTEXT NOT NULL,
            tags LONGTEXT NOT NULL COMMENT \'(DC2Type:simple_array)\',
            image_link VARCHAR(512) NOT NULL,
            coordinates LONGTEXT NOT NULL,
            INDEX IDX_1F1B251E54177093 (room_id),
            PRIMARY KEY(id)
        ) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('ALTER TABLE item ADD CONSTRAINT FK_1F1B251E54177093 FOREIGN KEY (room_id) REFERENCES room (id)');

        // Création de la table clue
        $this->addSql('CREATE TABLE clue (
            id INT AUTO_INCREMENT NOT NULL,
            item_id INT NOT NULL,
            type VARCHAR(255) NOT NULL,
            text VARCHAR(255) NOT NULL,
            INDEX IDX_268AADD1126F525E (item_id),
            PRIMARY KEY(id)
        ) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('ALTER TABLE clue ADD CONSTRAINT FK_268AADD1126F525E FOREIGN KEY (item_id) REFERENCES item (id) ON DELETE CASCADE');
    }

    public function down(Schema $schema): void
    {
        // Suppression des tables dans l'ordre inverse des dépendances
        $this->addSql('ALTER TABLE clue DROP FOREIGN KEY FK_268AADD1126F525E');
        $this->addSql('ALTER TABLE item DROP FOREIGN KEY FK_1F1B251E54177093');
        $this->addSql('DROP TABLE clue');
        $this->addSql('DROP TABLE item');
        $this->addSql('DROP TABLE room');
    }
}

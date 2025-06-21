<?php

namespace App\Factory;

use App\Entity\Item;
use App\Entity\Room;
use App\Repository\ItemRepository;
use Doctrine\Persistence\ManagerRegistry;
use Zenstruck\Foundry\Persistence\PersistentProxyObjectFactory;
use Zenstruck\Foundry\Persistence\Proxy;
use Zenstruck\Foundry\Persistence\ProxyRepositoryDecorator;

/**
 * @extends PersistentProxyObjectFactory<Item>
 *
 * @method        Item|Proxy                              create(array|callable $attributes = [])
 * @method static Item|Proxy                              createOne(array $attributes = [])
 * @method static Item|Proxy                              find(object|array|mixed $criteria)
 * @method static Item|Proxy                              findOrCreate(array $attributes)
 * @method static Item|Proxy                              first(string $sortedField = 'id')
 * @method static Item|Proxy                              last(string $sortedField = 'id')
 * @method static Item|Proxy                              random(array $attributes = [])
 * @method static Item|Proxy                              randomOrCreate(array $attributes = [])
 * @method static ItemRepository|ProxyRepositoryDecorator repository()
 * @method static Item[]|Proxy[]                          all()
 * @method static Item[]|Proxy[]                          createMany(int $number, array|callable $attributes = [])
 * @method static Item[]|Proxy[]                          createSequence(iterable|callable $sequence)
 * @method static Item[]|Proxy[]                          findBy(array $attributes)
 * @method static Item[]|Proxy[]                          randomRange(int $min, int $max, array $attributes = [])
 * @method static Item[]|Proxy[]                          randomSet(int $number, array $attributes = [])
 */
final class ItemFactory extends PersistentProxyObjectFactory
{
    private ManagerRegistry $doctrine;


    public function __construct(ManagerRegistry $doctrine)
    {
        $this->doctrine = $doctrine;
        parent::__construct();
    }

    public static function class(): string
    {
        return Item::class;
    }

    protected static array $usedCoordinates = [];

    /**
     * @see https://symfony.com/bundles/ZenstruckFoundryBundle/current/index.html#model-factories
     *
     */
    protected function defaults(): array|callable
    {
        return [];
    }

    public static function createPredefinedItems(ManagerRegistry $doctrine, \App\Service\ImageService $imageService): void
    {
        $itemsData = [
            // ITEMS RDC
            ['whoAmI' => "On me confond souvent avec mon cousin aux longues oreilles, mais moi, je suis bien plus grand et je préfère vivre seul. Mes oreilles sont si longues qu’elles captent les moindres bruits.Je suis très rapide, je peux courir pour échapper aux dangers !" , 'coordinates' => '30;25', 'description' => "Le lièvre d'Europe est un mammifère herbivore que l'on trouve dans de nombreuses régions d'Europe et d'Asie. Il est connu pour sa rapidité et sa capacité à faire de grands bonds pour échapper aux prédateurs. Les lièvres d'Europe se nourrissent principalement d'herbes, de feuilles et d'écorces.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1741785440/lievre_europe_wuyvjs.png', 'name' => "Lièvre d'Europe", 'room' => 2, 'tags' => ['Mammifères', 'Herbivores', 'Sauvages', 'Écosystèmes terrestres', 'Europe']],
            ['whoAmI' => "Je suis un oiseau qui aime planer au-dessus des marais et des roseaux. Mon vol est lent et silencieux, parfait pour surprendre les petites proies. Mon nid se cache souvent bien bas, au milieu des roseaux." , 'coordinates' => '33;14', 'description' => "Le busard des roseaux est un rapace diurne que l'on trouve principalement dans les zones humides et marécageuses d'Europe et d'Asie. Il est connu pour son vol élégant et sa capacité à chasser de petits mammifères, des oiseaux et des insectes. Le busard des roseaux est facilement reconnaissable à son plumage brun et à ses ailes longues et étroites.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736343520/Busard_des_Roseaux_xnmqdn.png', 'name' => "Busard des roseaux", 'room' => 2, 'tags' => ['Oiseaux', 'Prédateurs', 'Écosystèmes terrestres', 'Zones humides']],
            ['whoAmI' => "Je suis un oiseau qui adore chasser au crépuscule et même en plein jour. Mes grands yeux jaunes me permettent de tout voir, même dans la pénombre. Je fais mon nid à même le sol, souvent caché dans les hautes herbes." , 'coordinates' => '13;49', 'description' => "L'hibou des marais est un oiseau de proie nocturne que l'on trouve dans les zones humides et marécageuses. Il est connu pour ses grands yeux jaunes et son vol silencieux. Les hiboux des marais se nourrissent principalement de petits mammifères et d'insectes.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736180722/hibou_marais_clair_qe4syv.png', 'name' => 'Hibou des marais', 'room' => 4, 'tags' => ['Oiseaux', 'Prédateurs', 'Écosystèmes terrestres', 'Zones humides']],
            ['whoAmI' => "Je vis près des rivières et des marais, où je construis mes terriers. Avec mes grandes dents orange, je grignote des plantes toute la journée. On me confond parfois avec un castor, mais moi, je n’ai pas de queue plate !" , 'coordinates' => '22;43', 'description' => "Le ragondin est un grand rongeur semi-aquatique originaire d'Amérique du Sud, mais qui s'est répandu dans de nombreuses régions du monde. Il est connu pour son pelage dense et imperméable, ainsi que pour ses incisives orange vif. Les ragondins vivent près des cours d'eau et des marais, et se nourrissent principalement de plantes aquatiques.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736343179/ragoudin_cqqxua.png', 'name' => 'Ragondin', 'room' => 4, 'tags' => ['Mammifères', 'Herbivores', 'Sauvages', 'Écosystèmes aquatiques']],
            // ITEMS ETAGE 1
            ['whoAmI' => "Mon rire étrange fait peur, mais il m’aide aussi à communiquer avec ma famille. Je suis un excellent chasseur, mais je ne dis pas non aux restes des autres. On me trouve souvent en groupe dans les savanes d’Afrique." , 'coordinates' => '20;45', 'description' => "La hyène tachetée est un mammifère carnivore originaire d'Afrique. Elle est connue pour sa mâchoire puissante et son cri distinctif ressemblant à un rire. Les hyènes tachetées vivent en clans matriarcaux et sont des chasseurs efficaces ainsi que des charognards opportunistes.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736926704/hyene_tachete-Photoroom_yvojsw.png', 'name' => 'Hyène tachetée', 'room' => 9, 'tags' => ['Mammifères', 'Carnivores', 'Prédateurs', 'Sauvages', 'Afrique']],
            ['whoAmI' => "Je suis un serpent géant, mais je ne suis pas venimeux. J’aime me cacher dans les forêts et les savanes pour attraper mes proies par surprise. Qaund je te tiens, je t’enlace très fort, c’est ma façon de chasser." ,'coordinates' => '15;14', 'description' => "Le python de Seba est un grand serpent non venimeux originaire d'Afrique de l'Ouest. Il est connu pour sa capacité à se camoufler dans son environnement et pour sa méthode de chasse par constriction. Ce serpent peut atteindre une longueur de 6 mètres et se nourrit principalement de petits mammifères et d'oiseaux.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1734357170/python_seba_clair_eh6x0t.png', 'name' => 'Python de Seba', 'room' => 9, 'tags' => ['Reptiles', 'Carnivores', 'Prédateurs', 'Sauvages', 'Afrique']],
            ['whoAmI' => "Je vis dans les eaux froides et je glisse sur la glace comme un champion. Mon pelage est tout blanc quand je suis bébé, parfait pour me cacher sur la banquise. Je suis un excellent nageur grâce à mes nageoires." ,'coordinates' => '30;10', 'description' => "Le phoque du Groenland est un mammifère marin qui vit dans les eaux froides de l'Arctique et de l'Atlantique Nord. Il est connu pour sa fourrure blanche et épaisse, particulièrement chez les jeunes phoques, qui les protège du froid. Les phoques du Groenland se nourrissent principalement de poissons et de crustacés.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736180523/phoque_groenland_clair_ux2sjf.png', 'name' => 'Phoque du Groenland', 'room' => 10, 'tags' => ['Mammifères', 'Prédateurs', 'Écosystèmes marins', 'Polaires']],
            ['whoAmI' => "Mon plumage tout blanc me fait briller au milieu de la basse-cour. Je chante fièrement au lever du soleil pour réveiller tout le monde. Avec ma crête rouge, je suis facile à reconnaître.", 'coordinates' => '43;20', 'description' => "Le coq blanc est un oiseau domestique connu pour son plumage blanc éclatant et son chant distinctif. Il est souvent élevé pour sa viande et ses œufs, et joue un rôle important dans de nombreuses cultures à travers le monde. Les coqs blancs sont également appréciés pour leur beauté et leur comportement territorial.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736180980/coq_blanc_uwqfdr.png', 'name' => 'Coq blanc', 'room' => 13, 'tags' => ['Oiseaux', 'Domestiques', 'Écosystèmes terrestres']],
            ['whoAmI' => "Je saute partout avec mes puissantes pattes arrière. Je transporte mon bébé dans une poche sur mon ventre. On me trouve dans les plaines et forêts d’Australie." ,'coordinates' => '80;20', 'description' => "Le Wallaby de Benett est un petit marsupial originaire d'Australie. Il est connu pour sa capacité à sauter sur de longues distances grâce à ses puissantes pattes arrière. Les Wallabies de Benett vivent en groupes appelés 'mobs' et se nourrissent principalement d'herbes et de feuilles.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736180495/kangourou_clair_jlibom.png', 'name' => "Wallaby de Benett", 'room' => 15, 'tags' => ['Mammifères', 'Herbivores', 'Sauvages', 'Écosystèmes terrestres', 'Australie']],
            ['whoAmI' => " Je suis un oiseau géant qui vole très haut et très loin, traversant les océans. Mon cri puissant résonne souvent sur les îles lointaines où je niche. J’ai des ailes immenses qui peuvent atteindre plus de 3 mètres d’envergure !" ,'coordinates' => '76;11', 'description' => "L'albatros hurleur est un grand oiseau marin connu pour ses longues ailes et sa capacité à parcourir de vastes distances au-dessus des océans. Il est principalement trouvé dans les régions subantarctiques et se nourrit de poissons et de calamars. Les albatros hurleurs sont également connus pour leur longévité et leur fidélité à leur partenaire.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736180633/albatros_hurleur_clair_c5af9r.png', 'name' => "Albatros hurleur", 'room' => 16, 'tags' => ['Oiseaux', 'Écosystèmes marins', 'Prédateurs', 'Subantarctiques']],
            // ITEMS ETAGE 2
            ['whoAmI' => "Je suis un couvre-chef traditionnel porté par un peuple nigérien. Je suis rond et fait de paille, de cuir et de fibres végétales." ,'coordinates' => '16;8', 'description' => "Chapeau traditionnel porté par les Peuls du Niger, le chapeau foulbé est un symbole d'identité culturelle. Fabriqué à partir de paille et orné de motifs en cuir, il est à la fois fonctionnel et décoratif, protégeant du soleil tout en affichant le rang ou la personnalité de celui qui le porte.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736180199/Chapeau_w9negj.png', 'name' => 'Chapeau', 'room' => 23, 'tags' => ['Civilisations africaines', 'Vêtements traditionnels', 'Afrique']],
            ['whoAmI' => "Je suis un instrument ou un récipient décoré de perles venant du Cameroun. On me secoue ou on me frappe pour créer de jolis sons, souvent utilisés dans les danses et les cérémonies africaines." , 'coordinates' => '23;22', 'description' => "Objet artisanal d'origine africaine, la calebasse perlée est une calebasse naturelle décorée de perles colorées, souvent disposées en motifs traditionnels ou symboliques. Elle est utilisée à la fois comme objet utilitaire, pour transporter ou conserver des liquides, et comme élément décoratif, incarnant l'art et le savoir-faire des artisans locaux.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1741785502/calebasse_perlee_mz8r4j.png', 'name' => 'Calebasse perlée', 'room' => 23, 'tags' => ['Afrique','Mobilier Ancien', 'Artisanat']],
            ['whoAmI' => "Je montre des vêtements et des objets fabriqués par des peuples vivant dans la forêt tropicale. Je ne suis pas vivant, mais je porte leur culture." ,'coordinates' => '76;70', 'description' => "Ce mannequin présente une collection d'objets traditionnels amazoniens, illustrant la richesse culturelle et artisanale de cette région. Les objets exposés comprennent des parures, des outils et des ornements, chacun ayant une signification particulière et reflétant le savoir-faire ancestral des peuples amazoniens. Cette exposition permet de découvrir et d'apprécier l'art et les traditions de l'Amazonie.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736180886/Manequin_portant_des_objets_amazoniens_ripwoj.png' , 'name' => 'Mannequin portant des objets Amazoniens', 'room' => 18, 'tags' => ['Amériques', 'Artisanat', 'Culture']],
            ['whoAmI' => "Je suis un bateau avec de grandes voiles, utilisé en Chine pour naviguer sur les mers et les rivières." , 'coordinates' => '70;50', 'description' => "La jonque est un type de bateau traditionnel originaire de Chine, caractérisé par ses voiles en forme d'ailes de chauve-souris et sa coque en bois. Utilisée depuis des siècles pour le commerce et la pêche, elle incarne l'ingéniosité et l'héritage maritime de la culture chinoise. Ce modèle réduit de jonque permet d'apprécier les détails architecturaux et l'artisanat qui ont fait de ces navires des symboles emblématiques des eaux asiatiques.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736180906/Jonque_aer0rp.png', 'name' => 'Jonque', 'room' => 18,  'tags' => ['Asie', 'Artisanat']],
            ['whoAmI' => "Je suis un tambour malien qu’on frappe avec les mains pour faire de la musique. Je suis fait de bois, de coton et de peau de chèvre." , 'coordinates' => '20;66', 'description' => "Le djembé est un tambour traditionnel d'Afrique de l'Ouest, réputé pour sa forme en sablier et sa peau tendue, généralement en peau de chèvre. Utilisé lors de cérémonies, de danses et de rassemblements communautaires, il produit une gamme de sons riches et variés. Le djembé est non seulement un instrument de musique, mais aussi un symbole culturel fort, reflétant l'histoire et les traditions des peuples ouest-africains.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1741785858/jembe_lg5prr.png', 'name' => 'Jembé', 'room' => 24, 'tags' => ['Afrique', 'Civilisations africaines', 'Instruments de musique']],
            ['whoAmI' => "Je suis un petit animal qui saute, mais je suis resté figé dans une pierre pendant très longtemps." , 'coordinates' => '57;26','description' => "Ce crapaud fossilisé provient de la préhistoire et de la protohistoire africaine, offrant un aperçu fascinant de la faune ancienne du continent. Conservé dans un état remarquable, ce fossile permet d'étudier les caractéristiques anatomiques et les conditions environnementales de l'époque. Il témoigne de la diversité biologique et des écosystèmes qui existaient en Afrique il y a des millions d'années.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736180932/Crapaud_mvlrzx.png', 'name' => 'Crapaud', 'room' => 20, 'tags' => ['Afrique', 'Préhistoire', "Fossiles d'animaux"]],
            // ITEMS ETAGE 3
            ['whoAmI' => "Je suis une sculpture mystérieuse à deux têtes venant des îles du Pacifique. On me fabrique pour honorer les ancêtres et les esprits.", 'coordinates' => '16;40', 'description' => "Le Rambaramp est une sculpture rituelle traditionnelle des îles Vanuatu, en Mélanésie. Ces sculptures sont souvent utilisées dans des cérémonies funéraires et représentent des ancêtres ou des esprits protecteurs. Le Rambaramp est caractérisé par ses traits distinctifs et ses décorations élaborées, symbolisant l'importance culturelle et spirituelle de l'objet.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736180775/Rambaramp_wwsoag.png', 'name' => 'Rambaramp', 'room' => 25, 'tags' => ['Sculptures', 'Objets rituels', 'Civilisations asiatiques', 'Art religieux']],
            ['whoAmI' => "On m’appelle aussi Mbotumbo. Je suis une statuette en bois représentant un singe, sculptée par un peuple de Côte d’Ivoire. On m’utilise souvent dans des rituels pour protéger et guider." ,'coordinates' => '22;23', 'description' => "Le Gbekre, aussi appellé Mbotumbo, est une statue traditionnelle de la culture Baoulé en Côte d'Ivoire. Ces statues sont souvent utilisées dans des rituels religieux et représentent des esprits protecteurs ou des ancêtres. Le Gbekre est caractérisé par ses traits distinctifs et ses postures symboliques, reflétant l'importance culturelle et spirituelle de l'objet.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736180793/Gbekre_fbdgtj.png', 'name' => 'Gbekre', 'room' => 25, 'tags' => ['Sculptures', 'Objets rituels', 'Civilisations africaines', 'Art religieux']],
            ['whoAmI' => "Je représente un chef important qui n'est plus là, mais qu'on honore pour ses grandes actions. Dans le nord de la Grande Terre, on me fait apparaître pendant des rituels et des cérémonies de fin de deuil. On me reconnaît grâce à mon masque, qui a une fonction théâtrale.", 'coordinates' => '50;34', 'description' => "L'Esprit du chef défunt est une sculpture rituelle provenant des cultures traditionnelles africaines. Ces sculptures sont souvent utilisées dans des cérémonies funéraires pour honorer et invoquer les esprits des chefs décédés. Elles sont caractérisées par des traits distinctifs et des motifs symboliques, reflétant l'importance culturelle et spirituelle de l'objet.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1736180812/Esprit_du_chef_defunt_bd2xgf.png', 'name' => 'Esprit du chef défunt', 'room' => 25, 'tags' => ['Sculptures', 'Objets rituels', 'Civilisations africaines', 'Art religieux']],
            ['whoAmI' => "Je viens du peuple Kwele, en République du Congo. Je suis sculpté en bois et décoré de pigments, mon visage simple et j'ai des cornes en forme de W. On peut me porter ou m'utiliser comme décoration murale." , 'coordinates' => '60;44', 'description' => "Les masques à cornes sont des objets rituels utilisés dans diverses cultures africaines pour des cérémonies religieuses et sociales. Ces masques sont souvent ornés de cornes et de motifs symboliques, représentant des esprits ou des animaux totémiques. Ils jouent un rôle important dans les rites de passage, les danses et les festivals.", 'imageLink' => 'https://res.cloudinary.com/dozwg0xdq/image/upload/v1741785548/masque_a_cornes_n0zxh7.png', 'name' => 'Masques à cornes', 'room' => 25, 'tags' => ['Masques', 'Objets rituels', 'Civilisations africaines', 'Art religieux']],
        ];

        $entityManager = $doctrine->getManager();
        $roomRepository = $entityManager->getRepository(Room::class);

        foreach ($itemsData as $itemData) {
            $room = $roomRepository->findOneBy(['number' => $itemData['room']]);
            if ($room) {
                $convertedLink = $imageService->processImage($itemData['imageLink']);
                self::createOne([
                    'name' => $itemData['name'],
                    'description' => $itemData['description'],
                    'imageLink' => $convertedLink,
                    'tags' => $itemData['tags'],
                    'coordinates' => $itemData['coordinates'],
                    'room' => $room,
                    'whoAmI' => $itemData['whoAmI'],
                ]);
            }
        }
    }

    /**
     * @see https://symfony.com/bundles/ZenstruckFoundryBundle/current/index.html#initialization
     */
    protected function initialize(): static
    {
        return $this;
    }
}

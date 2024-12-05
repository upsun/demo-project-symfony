# Set up an Entity

## Add a few bundles

In order to display a list of users on the frontend, we will need to add some bundles:

```bash
symfony composer require doctrine/annotations \
  doctrine/doctrine-bundle \
  doctrine/doctrine-migrations-bundle \
  doctrine/orm nelmio/cors-bundle \
  symfony/doctrine-bridge \
  symfony/html-sanitizer \
  symfony/http-client \
  symfony/intl symfony/monolog-bundle \
  symfony/security-bundle \
  symfony/serializer \
  symfony/twig-bundle \
  symfony/asset-mapper \
  symfony/asset \
  symfony/twig-pack

symfony composer require --dev doctrine/doctrine-fixtures-bundle symfony/maker-bundle
```

Then stage and commit your changes:

```bash 
git add . && git commit -m "adding required bundles: doctrine, twig, assets, ..."
```

## Create a `Speaker` Entity

We will create a new entity, using [Maker Bundle](https://symfony.com/bundles/SymfonyMakerBundle/current/index.html)

```bash
symfony console make:entity Speaker
```

Add these fields to the entity:

- `first_name`/`string`/`255`/(nullable) `no`
- `last_name`/`string`/`255`/(nullable) `no`
- `username`/`string`/`255`/(nullable) `no`
- `picture`/`string`/`1024`/(nullable) `yes`
- `city`/`string`/`512`/(nullable) `yes`
- `distance`/`integer`/(nullable) `yes`

Then stage & commit your changes:

```bash
git add . && git commit -m "Add Speaker entity."
```

## Create migration files

To generate corresponding migration file for the Speaker entity, we need a database.
The DoctrineBundle comes up with a Docker container.
To start using it, execute the following:

```bash
docker compose up -d
docker ps
```

> [!NOTE]
> If you get the following error:
>
> ```bash
> $ docker compose up -d
> yaml: line 5: did not find expected tag URI
> ```
>
> It may be necessary to update the `POSTGRES_PASSWORD` attribute in the generated `compose.yaml` file. Change it to something like the below and retry:
> 
> ```yaml
> services:
>   database:
>     image: postgres:${POSTGRES_VERSION:-16}-alpine
>     environment:
>       ...
>       POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-"!ChangeMe!"}
> ```

From the ``docker ps`` command, copy the external port of the `` Container and update variable `DATABASE_URL` with the right port in your `.env` file.

```shell
DATABASE_URL="postgresql://app:!ChangeMe!@127.0.0.1:57133/app?serverVersion=16&charset=utf8"
```

> [!NOTE]
> If you have the tool `jq` installed, you can do this automatically with the following:
>
> ```bash
> DB_PUBLISHED_PORT=$(docker compose ps --format json | jq -r '.[] | select(.Service=="database") | .Publishers[0].PublishedPort')
> printf "    
> DATABASE_PORT=$DB_PUBLISHED_PORT
> DATABASE_URL=\"postgresql://app:!ChangeMe!@127.0.0.1:$DATABASE_PORT/app?serverVersion=16&charset=utf8\"
> " >> .env.dev
> ```

Then generate a migration file and update your local database using it:
```shell
symfony console doctrine:migrations:diff
symfony console doctrine:migrations:migrate
```

Then AC your changes:
```shell
git add migrations && git commit -m "adding migration for Speaker entity"
```

## Add fixtures

Update `src/DataFixtures/AppFixtures.php` with the following:

```php
<?php

namespace App\DataFixtures;

use App\Entity\User;
use App\Entity\Speaker;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class AppFixtures extends Fixture
{
    /** @var ObjectManager */
    private $objectManager;

    public function load(ObjectManager $manager): void
    {
        $this->objectManager = $manager;

        $this->createUsers();

        $manager->flush();
    }

    private function createUsers()
    {
        /* [last_name, first_name, username, city, online_picture, distance ] */
        $users = [
            ['Huck', 'Florent', 'flovntp', 'Massieux', 'https://avatars.githubusercontent.com/u/1842696?v=4', 915000],
            ['Delaporte', 'Augustin', 'guguss', 'Lyon', 'https://avatars.githubusercontent.com/u/1927538?v=4', 915000],
            ['Dunglas', 'Kevin', 'dunglas', 'Lille', 'https://avatars.githubusercontent.com/u/57224?v=4', 998000],
            ['Schranz', 'Alexander', 'alexander-schranz', 'Dornbirn', 'https://avatars.githubusercontent.com/u/1698337?v=4', 502000],
            ['Kalipetis', 'Antonis', 'akalipetis', 'Athens', 'https://avatars.githubusercontent.com/u/788386?v=4', 1282000],
            ['Salome', 'Alexandre', 'alexandresalome', 'Lille', 'https://avatars.githubusercontent.com/u/134144?v=4', 998000],
            ['André', 'Simon', 'smnandre', 'Rennes', 'https://avatars.githubusercontent.com/u/1359581?v=4', 1335000],
            ['Moigneu', 'Guillaume', 'gmoigneu', 'Houston', 'https://media.licdn.com/dms/image/v2/D5603AQHGGCAlqb0QJw/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1723000381304?e=1738195200&v=beta&t=c31YGKld41tgZnc5gdGxCNSBoAv4iU1mCekt3IJAvXU', 9010000],
            ['Arlaud', 'Mathias', 'mtarld', 'Lyon', 'https://avatars.githubusercontent.com/u/4955509?v=4', 915000],
            ['Watcher', 'Johannes', 'wachterjohannes', 'Hohenems', 'https://avatars.githubusercontent.com/u/1464615?v=4', 506000],
            ['Schuh', 'Moritz', 'moritzschuh', 'Vienna', 'https://avatars.githubusercontent.com/u/151578842?v=4', 0],
            ['Dietrich', 'Peter', 'xosofox', 'Germany', 'https://avatars.githubusercontent.com/u/206212?v=4', 557000],
            ['Sanver', 'Michelle', 'michellesanver', 'Zurich', 'https://avatars.githubusercontent.com/u/570982?v=4', 591000],
            ['Plagemann', 'Sebastian', 'sebastianplagemann', 'Vienna', 'https://connect.symfony.com/uploads/users/9b60e3cd-d712-42be-9cd4-0e95bec0ab68/c81e2f13-3eca-46d4-bcb8-be86eca13f53.jpg', 0],
            ['Dragoonis', 'Paul', 'dragoonis', 'Glasgow', 'https://avatars.githubusercontent.com/u/146321?v=4', 1637000],
            ['Van Der Watt', '', 'Ceelolulu', 'Lyon', 'https://avatars.githubusercontent.com/u/137410240?v=4', 915000],
            ['Bluchet', 'Antoine', 'soyuka', 'Nantes', 'https://avatars.githubusercontent.com/u/1321971?v=4', 1342000],
            ['Liddament', 'Dave', 'DaveLiddament', 'Bristol', 'https://avatars.githubusercontent.com/u/6787687?v=4', 1403000],
            ['Qualls', 'Greg', 'gregqualls', 'US', 'https://avatars.githubusercontent.com/u/84520709?v=4', 8322000],
            ['Adermann', 'Nils', 'naderman', 'Berlin', 'https://avatars.githubusercontent.com/u/154844?v=4', 523000],
            ['Buchmann', 'David', 'dbu', 'Switzerland', 'https://avatars.githubusercontent.com/u/76576?v=4', 803000],
            ['Seggewiß', 'Sebastian', 'seggewiss', 'Germany', 'https://avatars.githubusercontent.com/u/39218577?v=4', 557000],
            ['Saunier', 'Tugdual', 'tucksaun', 'Aix-les-bains', 'https://avatars.githubusercontent.com/u/870118?v=4', 841000],
            ['Minasyan', 'Marie', 'MarieMinasyan', 'Nantes', 'https://avatars.githubusercontent.com/u/1398717?v=4', 1342000],
            ['Wójs', 'Adam', 'adamwojs', 'Kraków', 'https://s2.qwant.com/thumbr/320x320/7/2/642ed7884510f23d333f01c44cab661fdf6158e0553bbcc4967dca9161f4df/th.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%3Fid%3DOIP.wgn1_kxMTyG_YRLK_ya-bAAAAA%26pid%3DApi&q=0&b=1&p=0&a=0', 328000],
            ['Kersten', 'Nigel', 'nigelkersten', 'London', 'https://cdn.prod.website-files.com/6205294295b40674a1856690/6229f7a9cd520348fbc0f0e0_nigel-kersten.png', 1235000],
            ['M. Turek', 'Alexander', 'alexandermturek', 'Düsseldorf', 'https://media.licdn.com/dms/image/v2/C4E03AQEtTK2P0vlszw/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1659209216805?e=1738195200&v=beta&t=HnJ2xhJlyqN4XPFaaQMXoWEB-71TQb8s0B55JEHfSKg', 766000],
            ['Lenoir', 'Hubert', 'Jean-Beru', 'Lille', 'https://media.licdn.com/dms/image/v2/C5603AQH2ildmNdRp-g/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1517354536642?e=1738195200&v=beta&t=TzbZVMKpBcUtz0U7epo7Rh5yDJBoyLrqTQFOzbCbKto', 998000],
            ['Roches', 'Adrien', 'adrienroches-sensio', 'Bordeaux', 'https://connect.symfony.com/uploads/users/8db9b333-936c-4477-93f5-c6b125ea20fa/a7184a56-3781-49b2-9741-ddf7c65bc18b.jpg', 1346000],
            ['di Luccio', 'Thomas', 'thomasdiluccio', 'Lyon', 'https://avatars.githubusercontent.com/u/3739767?v=4', 915000],
            ['Pikaev', 'Viktor', 'HaruAtari', 'Malmö', 'https://avatars.githubusercontent.com/u/3523420?v=4', 854000],
            ['Allen', 'Rob', 'akrabat', 'Worcester', 'https://secure.gravatar.com/avatar/79d9ba388d6b6cf4ec7310cad9fa8c8a?s=400', 1390000],
            ['Millar', 'Haylee', 'hayleemillar', 'Sarasota', 'https://avatars.githubusercontent.com/u/32496943?v=4', 8392000],
            ['Mirtes', 'Ondřej', 'ondrejmirtes', 'Prague', 'https://avatars.githubusercontent.com/u/104888?v=4', 252000],
            ['Geffroy', 'Raphaël', 'raphael-geffroy', 'Saint-Malo', 'https://avatars.githubusercontent.com/u/81738559?v=4', 1354000],
            ['Ojogbede', 'Kemi Elizabeth', 'KemiOjogbede', 'London', 'https://avatars.githubusercontent.com/u/112084987?v=4', 1235000],
            ['Daninos', 'Matheo', 'matheodaninos', 'Paris', 'https://connect.symfony.com/uploads/users/de68d614-bff5-42fd-ae52-017106a9ea20/a28e67e7-186f-42cc-b37e-5dcbca461b69.jpg', 1033000],
            ['Reinders Folmer', 'Juliette', 'jrfnl', 'Paris', 'https://connect.symfony.com/api/images/acff3fd1-c5dd-47fa-8d35-7759e8c997b2.png?format=180x180', 1033000],
            ['Maucorps', 'Vincent', 'vmaucorps', 'Paris', 'https://avatars.githubusercontent.com/u/9037268?v=4', 1033000],
            ['Deis', 'Céline', 'celine-deis', 'Paris', 'https://connect.symfony.com/api/images/539c68e6-95eb-4deb-ab5a-cb5820b0d947.png?format=180x180', 1033000],
            ['Seitz', 'Anne-Julia', 'dazs', 'Berlin', 'https://secure.gravatar.com/avatar/5fcfa864ae04004e92416a5ea05d5ffa?s=400', 523000],
            ['Braun', 'Andreas', 'alcaeus', 'Munich', 'https://avatars.githubusercontent.com/u/383198?v=4', 355000],
            ['Ruaud', 'Romain', 'romainruaud', 'Bordeaux', 'https://avatars.githubusercontent.com/u/15340849?v=4', 1346000],
            ['Chalas', 'Robin', 'chalasr', 'Paris', 'https://avatars.githubusercontent.com/u/7502063?v=4', 1033000],
            ['Milan', 'Thibault', 'clawfire', 'Luxembourg', 'https://connect.symfony.com/uploads/users/dc30c77b-50cf-4ea5-9eca-3a4134cfc552/17022321-a721-485f-9c79-490faec38588.jpg', 763000],
            ['Grekas', 'Nicolas', 'nicolas-grekas', 'Paris', 'https://avatars.githubusercontent.com/u/243674?v=4', 1033000],
            ['Potencier', 'Fabien', 'fabpot', 'Moon', 'https://avatars.githubusercontent.com/u/47313?v=4', 356410002],
        ];
        
        foreach($users as $userData) {
            $speaker = new Speaker();
            $speaker->setLastName($userData[0]);
            $speaker->setFirstName($userData[1]);
            $speaker->setUsername($userData[2]);
            $speaker->setCity($userData[3]);
            $speaker->setPicture($userData[4]);
            $speaker->setDistance($userData[5]);
            $this->objectManager->persist($speaker);
        }
        $this->objectManager->flush();
    }
}
```

And execute on your local database:

```bash
symfony console doctrine:fixture:load
```

Then AC your changes:

```shell
git add src/DataFixtures/AppFixtures.php && git commit -m "adding fixtures for speakers"
```

With the entity setup, [lets create a very basic frontend to view it -->](./frontend_a.md).
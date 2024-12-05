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

Replace `src/DataFixtures/AppFixtures.php` with the contents linked below:

> [`src/DataFixtures/AppFixtures.php`](https://github.com/upsun/demo-project-symfony/blob/main/files/DataFixtures/AppFixtures.php)

And execute on your local database:

```bash
symfony console doctrine:fixture:load
```

Then AC your changes:

```shell
git add src/DataFixtures/AppFixtures.php && git commit -m "adding fixtures for speakers"
```

With the entity setup, [lets create a very basic frontend to view it -->](./frontend_a.md).
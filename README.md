<p align="center">
<a href="https://www.upsun.com/">
<img src="https://raw.githubusercontent.com/upsun/.github/main/profile/logo.svg" width="500px">
</a>
</p>

<!-- <p align="center">
<a href="https://github.com/platformsh/demo-project/issues">
<img src="https://img.shields.io/github/issues/platformsh/demo-project.svg?style=for-the-badge&labelColor=f4f2f3&color=6046FF&label=Issues" alt="Open issues" />
</a>&nbsp&nbsp
<a href="https://github.com/platformsh/demo-project/pulls">
<img src="https://img.shields.io/github/issues-pr/platformsh/demo-project.svg?style=for-the-badge&labelColor=f4f2f3&color=6046FF&label=Pull%20requests" alt="Open PRs" />
</a>&nbsp&nbsp
<a href="https://github.com/platformsh/demo-project/blob/main/LICENSE">
<img src="https://img.shields.io/static/v1?label=License&message=MIT&style=for-the-badge&labelColor=f4f2f3&color=6046FF" alt="License" />
</a>&nbsp&nbsp
<br /><br /> -->

<p align="center">
<strong>Contribute, request a feature, or check out our resources</strong>
<br />
<br />
<a href="https://discord.gg/PkMc2pVCDV"><strong>Join us on Discord</strong></a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<a href="https://devcenter.upsun.com/"><strong>Developer Center</strong></a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<a href="https://docs.upsun.com"><strong>Documentation</strong></a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<a href="https://upsun.com/"><strong>Website</strong></a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<a href="https://upsun.com/blog/"><strong>Blog</strong></a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<br /><br />
</p>

<!-- <h2 align="center">Try the Symfony Upsun demo</h2> -->

## About

This is a simple demo project meant to take users through a product tour of [Upsun](https://upsun.com).

> [!WARNING]
> ### This is a demo meant purely for demonstration purposes
> This project is owned by the Upsun DevRel team. It has been written by Augustin Delaporte and Florent Huck for the SymfonyCon Vienna 2024 and only intended to be used with caution by Upsun customers/community. This project is not supported by Upsun and does not qualify for Support plans. Use this repository at your own risks, it is provided without guarantee or warranty!

## Requirements

Perform the following if you haven't already:

1. [Install the Symfony CLI](https://symfony.com/download)
2. [Install the Upsun CLI](https://docs.upsun.com/administration/cli.html)
3. Be sure to have [NodeJS installed](https://nodejs.org/en/download/package-manager) (this demo expects Node 20).
4. [Create an Upsun account](https://auth.upsun.com/) if needed.

    > At this point, do not follow prompts to create your first project or organization. We will do that within this demo.

5. Login to Upsun through the Symfony CLI:

    ```bash
    symfony upsun:login
    ```

6. Create your first organization on Upsun, if needed:

    ```bash
    symfony upsun:org:create --name [YOUR_ORG_NAME]
    ```

## Contents

1. [Set up the project](./docs/setup.md)
2. [Add an entity](./docs/entity.md)
3. [Setup an initial frontend](./docs/frontend_a.md)

##

### Add a few bundles

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

#### Create a `Speaker` Entity

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
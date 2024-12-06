# Set up the project

Our first steps are to set up our Symfony backend repository locally.

1. Create a new project from the Symfony skeleton:

    ```bash
    symfony new upsun_symfony_demo --php=8.3 --upsun
    cd upsun_symfony_demo
    ```
   
    > **Note:** This demo has been written & tested for PHP 8.3 only.

2. Update the Upsun configuration slightly to match the file below

    ```yaml
    applications:
        api:
            source:
                root: "/"

            type: php:8.3

            runtime:
                extensions:
                    - apcu
                    - blackfire
                    - ctype
                    - iconv
                    - mbstring
                    - sodium
                    - xsl
                    

            variables:
                php:
                    opcache.preload: config/preload.php
            build:
                flavor: none

            web:
                locations:
                    "/":
                        root: "public"
                        expires: 1h
                        passthru: "/index.php"

            mounts:
                "/var": { source: storage, source_path: var }
                

            
            hooks:
                build: |
                    set -x -e

                    curl -fs https://get.symfony.com/cloud/configurator | bash
                    
                    NODE_VERSION=22 symfony-build

                deploy: |
                    set -x -e

                    symfony-deploy

            crons:
                security-check:
                    # Check that no security issues have been found for PHP packages deployed in production
                    spec: '50 23 * * *'
                    cmd: if [ "$PLATFORM_ENVIRONMENT_TYPE" = "production" ]; then croncape COMPOSER_ROOT_VERSION=1.0.0 COMPOSER_AUDIT_ABANDONED=ignore composer audit --no-cache; fi

            relationships:
                database:

    services:
        database:
            type: "postgresql:16"

    routes:
        "https://api.{all}/": 
            type: upstream
            upstream: "api:http"
            id: api
        "http://api.{all}/":
            type: redirect
            to: "https://api.{all}/"
    ```

3. Create a project on Upsun, using the same organization you created in the previous step:

    ```bash
    symfony upsun:create --set-remote
    ```

4. Stage and commit the changes

    ```bash
    git add . && git commit -m "Initialize Symfony skeleton"
    ```

These steps would deploy a pretty uninteresting project to Upsun.

[Let's make it a bit more interesting -->](./entity.md)

# Adding a Next.js frontend

## Preview environment

Create a new environment to work from:

```bash
symfony upsun:branch frontend
```

We'll use this space to first prepare Symfony to serve endpoints that will be consumed by Next.js at runtime.

## Add JSON (REST) endpoints

We want to expose the Speaker list and the podium list.
To do so, we will create a new Controller with this 2 REST routes and create a Speaker Repository function to get the Podium.
So, first, create a new Controller ``src/Controller/SpeakerController.php``:

```php
<?php
namespace App\Controller;

use App\Repository\SpeakerRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class SpeakerController extends AbstractController
{
    #[Route('/api/get-speaker-list', methods: ['GET'])]
    public function getSpeakerList(SpeakerRepository $speakerRepository): Response
    {
        return $this->json($speakerRepository->findBy([], ['distance' => 'DESC']));
    }

    #[Route('/api/get-podium', methods: ['GET'])]
    public function getPodium(SpeakerRepository $speakerRepository): Response
    {
        return $this->json($speakerRepository->getSpeakerPodium());
    }
}
```

Update `src/Repository/SpeakerRepository` with the following methods for retrieving Speakers:

```php
<?php

namespace App\Repository;

use App\Entity\Speaker;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/** @extends ServiceEntityRepository<Speaker> */
class SpeakerRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Speaker::class);
    }
    
    public function getSpeakerPodium()
    {
        return $this->createQueryBuilder('s')
            ->orderBy('s.distance', 'DESC')
            ->setMaxResults(3)
            ->getQuery()
            ->getArrayResult();
    }
}
```

Then, AC your changes:

```shell
git add src/Controller/SpeakerController.php src/Repository/SpeakerRepository.php && git commit -m "adding REST endpoint (Json) for speaker list and podium"
```

## Create the Next.js site

Use `npx` to create a new Next.js site:

```bash
npx --yes create-next-app@latest client --yes --js 
cd client && npm install bootstrap
```

Update `client/app/page.js` to the following:

```js
import './page.css';
import {SpeakerList, Podium} from "./component/podium";

const Home = () => {
  return (
      <div className={'container'}>
        <nav className="navbar navbar-expand">
          <a className={"navbar-brand"} href="/">
            <img src="https://s2.qwant.com/thumbr/280x122/e/e/b5d5772ba90bc19429884de88b7a9a16b899624173e1c3ff8c005afc13ee76/th.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%3Fid%3DOIP.HP2RBmw3Ftrd_EyEQg4b6wAAAA%26pid%3DApi&q=0&b=1&p=0&a=0" width="25" height="30"
                 className="d-inline-block align-top" alt="podium"/>
          </a>
          <div className={"navbar-title"}>SymfonyCon Vienna 2024</div>
          <a className={"navbar-brand"} href="/">
            <img src="https://raw.githubusercontent.com/upsun/.github/main/profile/logo.svg" width="25" height="30"
                 className="d-inline-block align-top" alt="podium"/>
          </a>
        </nav>

        <Podium/>
        <SpeakerList/>
      </div>
  );
}
export default Home;
```

Also, update `app/page.css` to match the contents of the file below:

> [app/page.css](https://github.com/upsun/demo-project-symfony/blob/main/files/client/page.css)

## Views and layouts

Create a new file `app/component/podium.js` that matches the contents of the following file:

> [app/component/podium.js](https://github.com/upsun/demo-project-symfony/blob/main/files/client/podium.js)

And update the `app/layout.js` to match the following:

```js
import localFont from "next/font/local";
import "./globals.css";

const geistSans = localFont({
  src: "./fonts/GeistVF.woff",
  variable: "--font-geist-sans",
  weight: "100 900",
});
const geistMono = localFont({
  src: "./fonts/GeistMonoVF.woff",
  variable: "--font-geist-mono",
  weight: "100 900",
});

export const metadata = {
  title: "SymfonyCon Vienna 2024 - Podium",
  description: "SymfonyCon Vienna demo of the podium for the most far away speaker of the event",
};
export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={`${geistSans.variable} ${geistMono.variable}`}>
        {children}
      </body>
    </html>
  );
}
```

## Verify

You can view these changes locally by running

```bash
symfony server:start -d
```

From the project directory, and then

```bash
cd client
npm install
npm run dev
```

Visiting [http://localhost:3000/](http://localhost:3000/).

## Configure and deploy

You will need to make two changes to the Upsun configuration.

First, to the routes:

```yaml
routes:
    "https://api.{all}/": 
        type: upstream
        upstream: "api:http"
        id: api
    "http://api.{all}/":
        type: redirect
        to: "https://api.{all}/"

    "https://api.{all}/": 
        type: upstream
        upstream: "client:http"
        id: client
    "http://{all}/":
        type: redirect
        to: "https://{all}/"
```

Then, add the frontend to the `applications` block:

```yaml
applications:

    api:

        ...

    frontend:
        type: "nodejs:22"
        
        source: 
            root: "/client"
            
        container_profile: HIGH_MEMORY
        
        mounts:
            "/.npm":
                source: "storage"
                source_path: "npm"
            "/.next":
                source: "storage"
                source_path: "next"
        
        variables:
            env:
                NODE_ENV: production
        
        hooks:
            build: |
                set -eux
                npm i
            deploy: |
                set -eux
                npm run build             
        web:
            commands:
                start: npm run start -- -p $PORT
```

Stage and commit your changes, and push to Upsun.

```bash
git add . && git commit -m "Add a Next.js frontend"
symfony deploy
```

## Merge 

When you are satisfied with the changes, merge them into production:

```bash
symfony upsun:merge
```

## Managing resources

Once moved into production, you may find that the resources allocated to the containers are not enough. 
Adjust those resources up or down as needed using the command:

```bash
symfony upsun:resources-set
```
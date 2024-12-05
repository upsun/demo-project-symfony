# Setup an intial frontend in Symfony

## The Controller

First, you need to create a Controller for your homepage, in ``src/Controller/MainController.php``:

```php
<?php

namespace App\Controller;

use App\Repository\SpeakerRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;

class MainController extends AbstractController
{
    #[Route('/', name: 'app_homepage')]
    public function homepage(SpeakerRepository $speakerRepository)
    {
        $allSpeakers = $speakerRepository->findBy([], ['id' => 'ASC']);
        
        return $this->render('main/homepage.html.twig', [
            'speakers' =>  $allSpeakers,
        ]);
    }
}
```

## Homepage template

Then add corresponding ``templates/main/homepage.html.twig``:

```html
{% extends 'base.html.twig' %}

{% block body %}
  <div class="col-12">
    <h3>List of attendees at the SymfonyCon Vienna 2024</h3>
    <div class="divTable table table-striped table-dark table-borderless table-hover">
      <div class="divTableHeading">
        <div class="divTableRow bg-info">
          <div class="divTableHead">Picture</div>
          <div class="divTableHead">Speaker</div>
          <div class="divTableHead">City</div>
          <div class="divTableHead">Distance from Vienna</div>
        </div>
      </div>
  
      {% for speaker in speakers %}
      <div class="divTableRow">
        <div class="divTableCell">
          {% if speaker.picture %}
            <img style="height: 140px" src="{{ speaker.picture }}"/>
          {% else %}
          {# Thanks https://github.com/ozgrozer/100k-faces?tab=readme-ov-file #}
            <img style="height: 140px" src="https://randomspeaker.me/api/portraits/men/{{ speaker.id }}.jpg"/>
          {% endif %}
        </div>
        <div class="divTableCell">
          {{ speaker.firstname }} {{ speaker.lastname }} ({{ speaker.username }})
        </div>
        <div class="divTableCell">
          {{ speaker.city ?? '' }}
        </div>
        <div class="divTableCell">
          {{ (speaker.distance/1000) | number_format }} km
        </div>
      </div>
  
      {% endfor %}
    </div>
  </div>
{% endblock %}
```

## Styles

A few styling of it: Modify your `assets/styles/app.css` with the following:

```css
body {
    background-color: rgb(21, 32, 43);
    color: #fff;
}

/* DivTable.com */
.divTable{
    border: 1px solid #999999;
    display: table;
    width: 100%;
}
.divTableRow {
    display: table-row;
    padding: 0.75rem;
}
.divTableCell, .divTableHead {
    display: table-cell;
    padding: 3px 10px;
}
.divTableHeading {
    background-color: #565151;
    display: table-header-group;
    font-weight: bold;
}
.divTableFoot {
    background-color: #565151;
    display: table-footer-group;
    font-weight: bold;
}
.divTableBody {
    display: table-row-group;
}

.table-dark.table-striped .divTableRow:nth-of-type(odd) {
    background-color: rgba(255, 255, 255, 0.05);
}

.table-dark.table-hover .divTableRow:hover {
    background-color: rgba(255, 255, 255, 0.075);
}

.sightingLink {
    cursor: pointer;
}

.table-dark.table-hover .sightingLink.divTableRow:hover .divTableCell {
    text-decoration: underline;
}
```

## Compile assets

Then compile it using Symfony CLI

```shell
symfony console asset-map:compile
```

## Verify and deploy

You can now test it on your local frontend:

```shell
symfony server:start -d
symfony open:local
```

You should see a basic list of all your speakers from the fixtures.

Then, commit and push your changes to Upsun:

```shell
git add assets/styles/app.css src/Controller/MainController.php templates/main/homepage.html.twig && git commit -m "adding styled homepage with speaker list"
symfony deploy
```

> [!NOTE]
> To load your Speaker fixtures, you can use the following command:
>
> ```shell
> symfony ssh -- php bin/console doctrine:fixture:load -e dev
>  ```
>
> When that's completed, you can verify the data in production by visiting `symfony upsun:url --primary`.

With our production site now ready, [let's add a new frontend on an isolated preview environment -->](./frontend_b.md).


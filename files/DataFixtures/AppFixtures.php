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
            ['Delaporte', 'Augustin', 'guguss', 'Lyon', 'https://avatars.githubusercontent.com/u/1927538?v=4', 915001],
            ['Dunglas', 'Kevin', 'dunglas', 'Lille', 'https://avatars.githubusercontent.com/u/57224?v=4', 998000],
            ['Potencier', 'Fabien', 'fabpot', 'Moon', 'https://avatars.githubusercontent.com/u/47313?v=4', 356410002],
            //...  
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

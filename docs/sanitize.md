# Sanitizing data


## Add sanitization of Upsun preview environments

In order to not expose production data to potential external member of your company working on your project (preview environment), we will setup our project to sanitize preview databases on the fly during deploy hook.

First create a new command to sanitize data, in `src/Command/SanitizeDataCommand.php`:

```php
<?php
/* src/Command/SanitizeDataCommand.php */

namespace App\Command;

use App\Entity\Speaker;
use App\Repository\SpeakerRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:sanitize-data',
    description: 'Sanitize speaker data (first_name, last_name, username and picture).',
    aliases: ['app:sanitize']
)]
class SanitizeDataCommand extends Command
{
    private SymfonyStyle $io;

    public function __construct(private SpeakerRepository $speakerRepository, private EntityManagerInterface $entityManager)
    {
        parent::__construct();
    }

    protected function initialize(InputInterface $input, OutputInterface $output): void
    {
        $this->io = new SymfonyStyle($input, $output);
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $speakers = $this->speakerRepository->findAll();
        $this->io->progressStart(count($speakers));

        $this->entityManager->getConnection()->beginTransaction(); // suspend auto-commit
        try {
            /** @var Speaker $speaker */
            foreach ($speakers as $speaker) {
                $this->io->progressAdvance();
                // fake user info
                $speaker->setLastName('Wick');
                $speaker->setFirstName('John');
                $speaker->setUsername(uniqid('john-wick-'));
                $speaker->setPicture(sprintf('https://api.dicebear.com/9.x/adventurer-neutral/svg?seed=%s&backgroundColor=6046ff', uniqid('john-wick-')));
            }
            $this->entityManager->flush();
            $this->entityManager->getConnection()->commit();
            $this->io->progressFinish();
        } catch (\Exception $e) {
            $this->entityManager->getConnection()->rollBack();
            throw $e;
        }

        return Command::SUCCESS;
    }
}
```

Then, we need to tell Upsun to execute this Symfony command during the deploy hook. Modify your `.upsun/config.yaml` file and add the following at the end of the existing `hooks.deploy` block for the `api` application:

```yaml
applications:
    api:
        #...
        hooks:
            #...
            deploy: |
                set -x -e

                symfony-deploy

                # The sanitization of the database if it's not production
                if [ "$PLATFORM_ENVIRONMENT_TYPE" != production ]; then
                    php bin/console app:sanitize-data
                fi
```

Stage, commit, and push those changes:

```bash
git add . && git commit -m "Add sanitizing command for non-prod deploy hook.
symfony push
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

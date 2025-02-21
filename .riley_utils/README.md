![Riley Utils Scripts](/documentation/nidoran_icon.png)

# Riley Dev Utils
Usage: `rv <command> [<args>] [--help]`

# Installation
Be sure to run `./install.sh` in order to get the commands set up!

# Commands Available
 - api-latest
 - api-link
 - api-unlink
 - branch
 - clean
 - config
 - db-connect
 - ee-init
 - ee-reset
 - ee-set
 - ee-tfconfig
 - fastforward
 - keepup
 - newbranch
 - remote-db-reload
 - start
 - update-screenshots
 - aws-login

### Start servers in the background
|               |       |
|---------------|-------|
| `rv start <projects>...` | Runs one or more `freewill-api-v2` projects in one window |

### Grant console sessions temporary AWS credentials
|               |                                                                              |
|---------------|------------------------------------------------------------------------------|
| `rv aws-login` | Loads your environment with temporary AWS credentials, under AWS_PROFILE=sts |

### Manage your git situation
|               |       |
|---------------|-------|
| `rv branch <branchname>`     | Switches to a branch in the freewill-api-v2 repo                                    |
| `rv clean`       | Deletes your local orphaned git branches            |
| `rv fastforward` | Pulls the latest updates from the `develop` branch and merges them into your branch |
| `rv newbranch <branchname>`  | Creates a fresh branch from develop in the freewill-api-v2 repo                  |

### Manage your Ephemeral Environment
| |                                                                                                                            |
|--------------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| `rv ee-set`                             | Deploys the current branch to your ephemeral environment                                                                   |
| `rv ee-reset`                           | Triggers a github action to reset your EE (found at yourname.freewillinternal.com) to develop.                             |
| `rv ee-tfconfig`            | Adds your EE to the freewill-devops terraform config. Onboarding script; You should probably only do this once             |
| `rv ee-init`                | Runs the `ee-init` github workflow on your ephemeral environment. Onboarding script; you should probably only do this once |

### Manage @freewillpbc/client

|                  |              |
|------------------|--------------|
| `rv api-link <project>`   | Generates a local copy of the @freewillpbc/client npm package and links it for development |
| `rv api-unlink <project>` | Reverses the above |
| `rv api-latest <project>` | Installs the latest version of @freewillpbc/client and commits your change to package.json |

### Trigger github actions
|  |  |
|---|---|
| `rv remote-db-reload <environment>` | Refreshes a specific remote database |
| `rv update-screenshots <branchname>` | Runs the manual-update-screenshots github action on the selected branch. |

### Manage these utils
|                  |    |
|------------------|----|
| `rv config`         | Update your personal details for this tool |



# Individual Commands:

See `documentation/<command>.txt` for more information on each command. But for the ones that take arguments, here's an explanation of the arguments. You can also call `rv <command> --help` at any time.


#### `rv branch`
Usage: `rv branch <branchname> [--new|existing]`

Switches to a branch in the freewill-api-v2 repo

`<branchname>`: The name of a new or existing git branch

  `-n --new`: Aborts if the branchname you've chosen is already a git branch

  `-e --existing`: Aborts if the branchname you've chosen *isn't* already a git branch

#### `rv newbranch`
Usage: `rv newbranch <branchname>`

Alias for `rv branch <branchname> --new`

#### `rv api-link`, `rv api-unlink`, and `rv-api-prod`

Usage: `rv api-link <project>`

`<project>` options: `web | portal | pdf | pdfv1 | admin-console | crypto-web`

# Adding new scripts

To add a new script add the command to `main.sh` to the end of `COMMANDS`, and add a bash script to the folder, and then add the bash script to main.sh to the end of `SCRIPTS`.

Be sure to add a file with the same name as your command to the `documentation` folder, and describe how to use your command.

# List of Script Ideas
- rv db-connect `db-nickname` that pulls from a file somewhere with a list of dbs where we give them a nickname and store all their info in that file and it lets us easily connect to dbs that we've already connected to before.
- rv ssh-connect `ssh-destination-nickname` that pulls from a file somewhere with a list of ssh destinations where we give them a nickname and store all their info in that file and it lets us easily connect to ssh destinations that we've already connected to before.

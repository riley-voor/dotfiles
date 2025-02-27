![Riley Utils Scripts](/assets/nidoran_icon.png)

# Riley Dev Utils
Usage: `rv <command> [<args>] [--help]`

# Installation
Be sure to run `./install.bash` in order to get the commands set up!

# Commands Available
  - branch
  - new-branch
  - clean-branches
  - update-repo
  - fast-forward
  - vim-find
  - coding-start
  - coding-end
  - config

### Manage your git situation
|               |       |
|---------------|-------|
| `rv branch <branchname>`     | Switches to a branch in the freewill-api-v2 repo                                    |
| `rv new-branch <branchname>`  | Creates a fresh branch from develop in the freewill-api-v2 repo                  |
| `rv clean-branches`       | Deletes your local orphaned git branches            |
| `rv update-repo` | TODO write a description here! |
| `rv fast-forward` | Pulls the latest updates from the `develop` branch and merges them into your branch |

### Helpful vim commands
|               |       |
|---------------|-------|
| `rv vim-find <filename>`  | TODO write a description here! |

### Manage these utils
|                  |    |
|------------------|----|
| `rv config`         | Update your personal details for this tool |



# Individual Commands:

Call `rv <command> --help` at any time to view documentation for a specific command. You can also view the relevant documentation file at `documentation/<command>.txt`.

# Adding new scripts

To add a new command/script, add the command to `main.bash` to the end of the `COMMANDS` array, and add your new bash script to the `scripts` folder, and then add the bash script to `main.bash` at the end of the `SCRIPTS` array.

Be sure to add a file with the name `<your_new_command>.txt` to the `documentation` folder, and describe how to use your command/script.

# List of To-Be-Implemented Script Ideas
- rv db-connect `db-nickname` that pulls from a file somewhere with a list of dbs where we give them a nickname and store all their info in that file and it lets us easily connect to dbs that we've already connected to before.
- rv ssh-connect `ssh-destination-nickname` that pulls from a file somewhere with a list of ssh destinations where we give them a nickname and store all their info in that file and it lets us easily connect to ssh destinations that we've already connected to before.

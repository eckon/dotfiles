# Custom scripts

The scripts can be found in the current folder.
All scripts were only tested and used privately. There is no guarantee that they work on other systems or environments.

Some Information about the scripts:
- start scripts (for quick start of the workflow)
  - what it does:
    - starts needed projects and dependencies to develop on the needed project
      - e.g.: api repo, frontend repo, database, docker services, etc.
  - requires:
    - tmux
    - dependencies of the project
  - scripts
    - [start-singularity](./start-singularity.sh)
- [take-note](./take-note.sh)
  - what it does:
    - without parameter
      - create a note per day in `~/Documents/notes/` with a date title
    - with parameter
      - creates a note per project in `~/Documents/notes/project/` with the project as title
    - opens a nvim buffer and inserts title (with current time)
  - requires:
    - [nvim](https://neovim.io/)
    - might have to update script to use different terminal emulator
- [gitlab-clone](./gitlab-search-and-clone.sh)
  - what it does:
    - fetches all available repos from the given gitlab (could be updated to use other systems as well)
    - displays them in fzf (interactive search)
    - on enter -> clone that repo into current directory
  - requires:
    - [fzf](https://github.com/junegunn/fzf), [jq](https://github.com/stedolan/jq), *([curl](https://curl.haxx.se/), [bash](https://www.gnu.org/software/bash/))*
    - add `variables.cfg` file, that has the needed config variables for the access token (needs api read permissions) and the projects api url
      - `GITLAB_PROJECTS_URL` is the url to the gitlab projects api, example: `gitlab.com/api/v4/projects`
      - `GITLAB_ACCESS_TOKEN` is the access key from gitlab, that needs at least api read permissions
  - usage:
    - run script with or without arguments (only first argument is being considered)
      - without: fetch all data and let fzf handle the filtering
      - with: pre-search with gitlab api fzf will handle the fine filtering (probably faster and less load)

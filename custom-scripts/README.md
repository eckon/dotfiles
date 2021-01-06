# Custom scripts

The scripts can be found in the current folder.
All scripts were only tested and used privately. There is no guarantee that they work on other systems or environments.
These can be "installed" inside a sourced folder like `/usr/local/bin/`.

Some Information about the scripts:
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

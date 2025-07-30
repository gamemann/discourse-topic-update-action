This is a [GitHub Action](https://github.com/features/actions) that updates the contents of the first post of a [Discourse](https://www.discourse.org/) forum topic with the contents of a file in the caller's repository.

## Requirements
Here are the Linux packages required from the caller to use this GitHub Action.

* [`jq`](https://jqlang.org/)
* [`gawk`](https://man7.org/linux/man-pages/man1/gawk.1.html)
* [`curl`](https://curl.se/)
* [`bash`](https://en.wikipedia.org/wiki/Bash_(Unix_shell))

On Debian and Ubuntu systems, you most likely will only need to install `jq` and `gawk` separately in your caller repository's workflow like the below step.

```yaml
- name: Install dependencies for Discourse Topic Update Action.
  run: sudo apt update && sudo apt install -y jq gawk
  shell: bash
```

## Inputs
Here are a list of inputs you will need to pass to the action from your repository (the caller). The **only** optional input is `file` which defaults to `README.md`.

| Name | Default | Description |
| ---- | ------- | ----------- |
| `env_file` | `.dtua/.env` | The environmental file to load. Look at [Environment Configuration](#environment-configuration) for more details! |
| `file` | `README.md` | The local Markdown file whose contents will replace the Discourse post. |
| `discourse_api_url` | *N/A* | The Discourse forum URL (e.g., `https://forum.moddingcommunity.com`). |
| `discourse_api_key` | *N/A* | The Discourse API key (created through the Discourse forum at **Admin** -> **Advanced** -> **API keys**). |
| `discourse_api_user` | *N/A* | The Discourse API key's user that is set when creating an API key on the Discourse forum. |
| `discourse_topic_id` | *N/A* | The Discourse topic ID to update. The workflow updates the first post of the topic. |
| `verbose` | `1` | What verbose output to print in the workflow (0 = None. 1 = Basic updates which includes post and topic ID. 2 = everything from value 1, but with response output from the Discourse API via cURL) |

### Security Note
It is **strongly recommended** you use repository secrets to safely pass your Discourse forum's API information to the action.

To add secrets, go to your repository's **Settings** page -> **Security and variables** -> **Actions** -> **Repository secrets** -> **New repository secret**.

## Environment Configuration
The script that processes and updates the final Markdown contents before updating the Discourse topic loads an environment file if the path to the value of `env_file` exists (default is `.dtua/.env`).

Here is the configuration for that file. The following general variables are available to set inside of the environmental file if specified through the `env_file` input setting.

| Name | Default | Description |
| ---- | ------- | ----------- |
| `LINES_SKIP` | *N/A* | A list of line numbers to skip in the final Markdown output to the Discourse topic separated by commas (if multiple lines). |

### Header Links
One problem I found when using this action myself was header links on GitHub aren't the same as header links in Discourse posts.

For example, on a Markdown file through GitHub I use this:

```markdown
## Table of Contents 
* [Something 1](#something-1)
* [Something 2](#something--2)
```

In the Discourse forum topic, the header links are formatted like the following instead:

```markdown
## Table of Contents 
* [Something 1](#p-232-something-1-2)
* [Something 2](#p-232-something--2-1)
```

While I *really wish* Discourse would just use the same header link formatting as GitHub, I've decided to add functionality to the script that processes the final Markdown contents and maps header links from GitHub to Discourse.

The prefix for each link environmental variable is `LINK_`. When setting the environmental variable, you'll need to convert all letters to upper-case and replace `-` with `_`.

For example:

* `#something-1` => `LINK_SOMETHING_1`
* `#something--2` => `LINK_SOMETHING__2`

Here's an example of setting environmental variables that maps the two links above.

```
LINK_SOMETHING_1="p-232-something-1-2"
LINK_SOMETHING__2="p-232-something--2-1"
```

## Workflow Example
Here's a full workflow example on the caller's side.

```yaml
name: Update Discourse Topic

on:
  push:
    branches: [ main ]

jobs:
  update-discourse:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v4

    - name: Install dependencies for Discourse Topic Update Action.
      run: sudo apt update && sudo apt install -y jq gawk
      shell: bash

    - uses: gamemann/discourse-topic-update-action@v1.0.0
      with:
        file: CONTENTS.md
        discourse_api_key: ${{ secrets.DISCOURSE_API_KEY }}
        discourse_api_user: ${{ secrets.DISCOURSE_API_USER }}
        discourse_topic_id: 123
        discourse_api_url: ${{ secrets.DISCOURSE_API_URL }}
```

Then inside of the repository are repository secrets set using the steps mentioned earlier.

## My Motives & Examples
I create a lot of guides on my modding community [forum](https://forum.moddingcommunity.com) with a GitHub repository in its [organization](https://github.com/modcommunity) since both GitHub and Discourse use the Markdown syntax.

This action allows me to update the guide through GitHub then the workflow automatically updates the contents of the topic on the modding community forum.

Here are some guides from my modding community using this GitHub Action!

* [How To Set Up A Rust Game Server](https://github.com/modcommunity/how-to-set-up-a-rust-game-server)

## Credits
* [Christian Deacon](https://github.com/gamemann)

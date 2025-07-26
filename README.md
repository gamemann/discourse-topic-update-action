This repository stores a small GitHub workflow that updates a topic/post on a [Discourse](https://www.discourse.org/) forum using its API with the contents from the [README.md](./README.md) file.

## Secrets
In order to use this workflow, your repository must set a few repository secrets. To add secrets, go to the repository's **Settings** page -> **Security and variables** -> **Actions** -> **Repository secrets** -> **New repository secret**.

| Name | Description |
| ---- | ----------- |
| `DISCOURSE_API_URL` | The Discourse forum URL (e.g., [`https://forum.moddingcommunity.com`](https://forum.moddingcommunity.com)). |
| `DISCOURSE_API_KEY` | The Discourse API key (created through the Discourse forum at **Admin** -> **Advanced** -> **API keys**). |
| `DISCOURSE_API_USER` | The Discourse API key's user that is set when creating an API key on the Discourse forum. |
| `DISCOURSE_TOPIC_ID` | The Discourse topic ID to update. The workflow updates the first post of the topic. |

## Motives
I create a lot of guides on my modding community [forum](https://forum.moddingcommunuity.com) with a GitHub repository in its [organization](https://github.com/modcommunity) since both GitHub and Discourse use the Markdown syntax.

The GitHub workflow allows me to update the guide through GitHub and it'll automatically update the contents of the topic on the modding community forum.

## Credits
* [Christian Deacon](https://github.com/gamemann)

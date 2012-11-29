# Campfire cli client

A `~/.hobostove.yml` file is required. When first running `hobostove` it will help you create one.

#### ~/.hobostove.yml
    ---
    - subdomain: domain
      token: apitoken
      room: Room to join

## Usage

To quit type `/quit`.

### Multiple rooms

Currently to get multiple rooms you have to manually edit your `~/.hobostove.yml` file. Just add another section that follows the same structure as the first one.

    ---
    - subdomain: domain
      token: apitoken
      room: Room to join
    - subdomain: domaintwo
      token: apitokentwo
      room: Room to join 2

When starting hobostove with mutliple rooms it will ask you which one you want to launch.

## Installation

### Mac

Install the gem `terminal-notifier` and Mountain Lion notifications will work. It also fixes formatting issues.

    $ gem install terminal-notifier

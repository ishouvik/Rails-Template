# Rails Template
This is one easy to use Rails template with all necessary gems and config files that I normally use.

## Installation
- Clone this repo
- `rails new <app name> -m <path to template.rb> --skip-bundle`
- Make changes to `config/locales/en.yml` file
- Make changes to `config/database.yml` file
- Manually copy app/views/layouts/application.rb
- Manually copy db/seeds.rb

## Usage
### Login
- Admin Email: admin@admin.com
- Admin Password: password

- User Email: johndoe@example.com
- user Password: password


## Dependencies
- Imagemagick
- MySQL Connector

## Troubleshooting
### Issues installing RMagick
Install Imagemagick on your system
- Ubuntu: `sudo apt-get install imagemagick libmagickcore-dev libmagickwand-dev`
- Mac OS X: `brew install imagemagick`

Make sure the rmagick gem installation succeeds before running the bundle command
- `gem install rmagick`


## Issues
- Manually copy app/views/layouts/application.rb
- Manually copy db/seeds.rb

## ToDo
- Support for MandrillApp/Mailgun

## Support
I'd be very happy to receive/answer feedback/questions and criticism. [GitHub Issues](https://github.com/ishouvik/Rails-Template/issues)
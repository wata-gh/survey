# survey

This project is survey web system. Can create surveys and anaylize feedback.

[![Code Climate](https://codeclimate.com/github/wata-gh/survey/badges/gpa.svg)](https://codeclimate.com/github/wata-gh/survey)
[![Test Coverage](https://codeclimate.com/github/wata-gh/survey/badges/coverage.svg)](https://codeclimate.com/github/wata-gh/survey/coverage)

# Installation

First create server which [survey-prov](https://github.com/wata-gh/survey-prov) [itamae](https://github.com/itamae-kitchen/itamae) provisioning.

```
# clone source
git clone https://github.com/wata-gh/survey.git
cd survey

# bundle install gems
bundle --path vendor/bundle

# create database
RAILS_ENV=production bundle exec rake db:create

# apply db
bundle exec ridgepole -c config/database.yml --apply -f db/Schemafile --env production

# npm install
npm install

# install bower components
./bin/rake bower:install['-f']

# precompile assets
bundle exec rake assets:precompile

# start unicorn
RAILS_ENV=production ./bin/rake unicorn:start
```

After starting unicorn application, you needs to create default group. If your domain is survey.example.com. you need to insert data to groups table.

```sql
insert into groups (
  name, description, created_at, updated_at
) values (
  'survey', 'default group', now(), now()
);
```

If your not using groups or access by IP, you can simply set name to blank.

```sql
insert into groups (
  name, description, created_at, updated_at
) values (
  '', 'default group', now(), now()
);
```

# Settings

By default, storage is Amazon S3. But you can change storage to local disk.

Survey uses S3 storage so you need to set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environments.

```shell
export AWS_ACCESS_KEY_ID=[AWS access key]
export AWS_SECRET_ACCESS_KEY=[AWS secret key]
export RAILS_ENV=production
```

#### config/initializers/carrierwave.rb

```ruby
config.fog_credentials = {
  provider: 'AWS',
  aws_access_key_id: Rails.application.secrets.aws_access_key_id,
  aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
  region: 'ap-northeast-1'
}
```

Doesn't matter which storage you use, you have to set nginx or something to able to access images. You can use nginx+small_light docker image to do that. Just set Amazon S3 url to image.conf and build image and start.

#### image_server/nginx/conf.d/image.conf
```
server {
    listen 80 default_server;

    access_log  /var/log/nginx/survey.image.access.log main;
    root   /opt/survey/public;

    small_light on;

    location ~ ^/resize/w/(.+)/h/(.+?)/(.+)$ {
        set $width $1;
        set $height $2;
        set $file $3;
        set $engine "imagemagick";
        proxy_pass http://127.0.0.1/small_light(dw=$width,dh=$height,e=$engine)/images/$file;
    }

    location ~ small_light[^/]*/(.+)$ {
        set $file $1;
        rewrite ^ /$file;
    }

    location /images/ {
        proxy_pass https://s3-ap-northeast-1.amazonaws.com/[bucket name]/;
    }
}
```

If you are using docker-compose, just start docker image by following command.

```shell
docker-compose up -d
```

# Getting Started

Access to survey with your domain and create new survey.  
e.g.  
http://survey.example.com

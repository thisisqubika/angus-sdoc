# angus-sdoc

Used to read the documentation of a service built in angus (but also is able to read any kind of documentation that follow
the angus structure), and generate an object representation of that documentation.

## Requirements

* Ruby >= 2.5

The gem has no runtime dependencies. It is consumed by services running very different
stacks, from Ruby 2.6 and JRuby 9.3 up to Ruby 3.4 and JRuby 9.4, and **every version those
services run in production is tested by the CI matrix** on every pull request:

| Runtime | Versions tested | Used by |
|---------|-----------------|---------|
| MRI     | 2.5, 2.6, 2.7, 3.0, 3.1, 3.2, 3.3, 3.4 | angus and the services |
| JRuby   | 9.3.14.0 | billing, external-commerce |
| JRuby   | 9.4.1.0  | auth-service, billing-public-proxy, epos-service, epos-public-proxy, infonet-cobranzas, vpos-service |
| JRuby   | 9.4.5.0  | audit, commerce, commerces-app, notification-service, pix-service |

The mapping from JRuby version to services is also in `.github/workflows/config.yml`.

## Branches

`master` is the only branch of this gem. Point your Gemfile at the repository without a
`branch:` option and Bundler follows it:

``` ruby
gem 'angus-sdoc', git: 'git@github.com:thisisqubika/angus-sdoc.git'
```

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'angus-sdoc', '~> 1.0.0'
```

And then execute:

``` sh
$ bundle
```

Or install it yourself as:

``` sh
$ gem install angus-sdoc
```

## Usage

You should have a definitions directory with the following structure (users directory is just a resource example,
it could be anything that has an operations.yml inside of it).

```
└── definitions
    ├── service.yml
    ├── messages.yml
    ├── representations.yml
    └── users (plural resource name)
        └── operations.yml
```

### File examples

service.yml

```yml
service:   'Angus API'
code_name: 'angus-api'
version:   '1.0'
```

messages.yml

```yml
ResourceNotFound:
  status_code: 404
  level: error
  description: 'We could not found that resource'
```

representations.yml

```yml
user_profile:
  - field: id
    description: User identifier
    required: true
    type: integer
  - field: first_name
    description: First name of the user.
    required: false
    type: string
```

users/operations.yml

```yml
show:
  name: Show a user
  description: |
    Shows the id and first name of the user.

  path: /users/:user_id/show
  method: get
  uri:
    - element: user_id
      description: 'Id of the user to show'

  response:
    - element: profile
      description: 'Profile of the user to show'
      required: true         # This means that the response must include this element
      type: user_profile     # This name should exists as a key on representations.yml file.

  messages:
    - key: ResourceNotFound
      description: 'We could not found a user with that id'
```

### Usage examples

``` ruby
require 'angus-sdoc' # Unless you had added the angus-sdoc to your Gemfile and used Bundler.require

service = Angus::SDoc::DefinitionsReader.service_definition('definitions')

# All of this attributes will be obtained from service.yml file.
# All values of in the service.yml are required due are shown on the generated documentation.

service.name          # The name of the service.
service.code_name     # An internal identifier of the service.
service.version       # The version of the service.

# The documentation can be exported to html or json.

# To export the documentation to html you just need to run the following:

Angus::SDoc::HtmlFormatter.format_service(service)

```

## Development

There is no committed `Gemfile.lock`: this is a gem, so each environment resolves its own
dependencies.

### Using Local Ruby

``` sh
bundle install
bundle exec rspec
```

### Using Docker

`bin/run` builds the image for one Ruby and opens a shell with `lib/` and `spec/` mounted
(`RUBY_VERSION` selects the Ruby, 3.4 by default). The lockfile and the gems stay the ones
resolved inside the image. Without the script:

``` sh
RUBY_VERSION=2.5 bin/run

# or, to just run the specs on Ruby 3.4
docker build --build-arg RUBY_VERSION=3.4 -t angus-sdoc .
docker run --rm angus-sdoc bundle exec rspec
```

The CI also uploads the coverage report as an artifact (`coverage-report`) for Ruby 3.4.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Note:

Please, include tests for all new features or bug fixes you work on.

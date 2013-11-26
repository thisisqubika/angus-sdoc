# Angus::Sdoc

Used to read the documentation of a service built in angus (but also is able to read any kind of documentation that follow
the angus structure), and generate an object representation of that documentation.

## Requirements

* Ruby >= 1.9

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

``` ruby
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Note:

Please, include tests for all new features or bug fixes you work on.

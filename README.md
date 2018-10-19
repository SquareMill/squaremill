= SquareMill - A static site generator

We needed a static site generator for a project and although we've used Jekyll several times in the past
we found ourselves extremely frustrated by both the liquid language and the handling of collections.

Squaremill is different in that it:

- Uses straight ERB as the templating language
- Allows collections to reference other collections
- Has some image processing baked in

== Directory Structure of static site for squaremill

== Usage

Squaremill requires ruby

````
    gem install squaremill
    cd /static_site
    squaremill --new-project
````

== Directory structure
  app/views/
    - All templates go here
  app/data/
    - All collections go here
  app/helpers/
    - All helper code goes here
  deploy/

== Notes
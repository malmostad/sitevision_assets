# Sitevision Assets

This repo contains the source for asset files used in the CMS Sitevision at www.malmo.se. Utilities for development and build are also included in this repo. The asset files, specific for this service, are used in addition to the [Global Assets](https://github.com/malmostad/global_assets) used on all our external web services.

## tl;dr
If you’re familiar with management of asset files using Grunt or other commonly used tools such as Rake or Sprockets, this is the short story:

    $ git clone git@github.com:malmostad/sitevision_assets.git
    $ cd sitevision_assets
    $ npm install

    $ grunt watch         # watches src and generates to public
    $ coffee app.coffee   # Serves files locally from the public dir on port 3000

    $ grunt dist          # generates files for deployment to dist
    $ grunt dist --war    # generates a servlet for deployment to dist

If you’re not, read the rest of the page.


## Directory Structure
Configuration files used during development and build are in the project root. None of those files will be deployed to a server.

The `src` directory structure contains the source files for Sass/CSS and CoffeeScript. Will not be deployed to a server.

The contents of `public` and `dist` are excluded from the Git repository by the `.gitignore` file. Those are used as output directories for generated asset files during development and build distribution respectively. They are automatically cleaned when running tasks and can also be be clean manually with the `grunt clean` task.

`vendor` contains Sass utilities shared with our other applications. They are checked in to this repository to ensure that all developers working with this system have the same version. See *Shared Sass Utilities* below.


## Development Setup
Checkout the source code to your workspace:

    $ git clone git@github.com:malmostad/sitevision_assets.git

After cloning the repository, install the required Node.js dependencies for the project. Be sure to have [Node.js](http://nodejs.org) installed on your machine. Run:

    $ npm install

The dependencies defined in `package.json` will be installed in `node_modules`i the projects root. That directory is excluded in the `.gitignore` file from being committed with Git so you need to run the `npm install` command again if you switch to another local machine. To update the dependencies later, run `npm update`.


## Development

During development, you want the asset files to be re-compiled automatically when you make changes to the source code. Use the Grunt `watch` task available in the project:

    $ grunt watch

The Sass and CoffeeScript files in the `src` directory will be compiled to the `public` directory as soon as they are changed and at the startup of the `watch` task. The `public` directory is automatically cleaned when you run the task.

If you want to have source maps generated for debugging of stylesheets and JavaScript, add the ` --sourcemaps` argument:

    $ grunt watch --sourcemaps

If you for some reason want to generate the files in `public` once without having the watcher running, run one of the following:

    $ grunt build
    $ grunt build --sourcemaps

Files generated to `public` directory must not be used for deployment to production, `dist` is used for that (see below).


## Build for Deployment
Do not use the files in the `public` directory when you deploy to a test or production server. To generate minified versions of the asset files, run:

    $ grunt dist

A new version will be compiled for deployment in the `dist` directory. The directory will be cleaned before the new files are generated.

To generate a Java servlet for deployment in the Tomcat server that Sitevision is running in, add the `--war` argument to the command:

    $ grunt dist --war

A Java servlet named `local-assets-v4` will be compiled to the `dist` directory.

## Deploy

The proven way is to deploy the assets as a servlet in Tomcat. Manually uploading in the CMS GUI is not recommended. In Sitevsion 3.x, servlets are deployed in `sitevision/tomcat/webapps`. Copy the war file to that directory and it will automatically be deployed if hot deployment is active.


### Add and Remove Sass Files
Sass source files are in the `src/stylesheets/ directory. If you add or remove Sass files, edit the `src/stylesheets/application.scss` file. Note that `@import` is a Sass directive executed during compilation, not the regular CSS equivalent that import files on the client side. When you run `grunt watch` or `grunt dist`, the `application.css` file concatenates the `@import` files in the given order. Regular CSS files can also be added as long as they have the `.scss` suffix.

To add an individual Sass file, like the `ie7.scss` one, that should not be concatenated to the `application.css` file, just add it to the `src/stylesheets` directory.


### Add and Remove CoffeeScript Files
CoffeeScript source files are in the `src/javascripts/ directory. Unlike Sass files, you need to edit the `Gruntfile.coffee` file to add or remove files from the compilation tasks. The `coffee:` task configuration block in the file has a `files` object that looks like this:

```coffeescript
files:
  '<%= forDist ? "dist" : "public" %>/application.js': [
    # Files to compile and concatenate in given order
    'src/javascripts/contact_us.coffee'
    'src/javascripts/feedback.coffee'
  ]
```

The key is the path and filename that will be generated and the array contains files to be compiled and concatenated. Add new files to the array. You can also add more key/value pairs with the pattern `to: from` if you need individual output files to serve with IE conditionals e.g.

## Shared Sass Utilities
Sass utilities from our [shared_assets](https://github.com/malmostad/shared_assets) repository are attached to this repository. See the *Gettings Started* and *Grids and Responsive Design* sections of the [Web Application Guidelines](http://malmostad.github.io/wag-external-v4) for usage.

To update the Sass utilities for this project, if you e.g. need a fresh version of the `variables.scss` file, run:

    $ bower update

Be sure to commit the changes if any files were updated.


## Run a Local Asset Server
The easiest way to serve the assets on your own machine during development is to fire up a lightweight server and have the `watch` Grunt task running. The project is configured with two alternatives that works in the same way.

### Using Express
You have already Express installed if you ran `npm install` in the setup step above. To serve the assets locally on your machine with [Express](http://expressjs.com/), run:

    $ coffee app.coffee
    $ grunt watch

The assets are now available for your local web browser at e.g. `http://localhost:3000/application.css`. Express is reading static files from the `public` directory. Be sure to have the `watch` Grunt task running to have those files compiled whenever a source code file is changed.


### Using Sinatra
The project is also configured to use [Sinatra](http://www.sinatrarb.com/) to serve the assets locally during development. Be sure to have Ruby installed on your machine and run the following command on your machine to enable Sinatra:

    $ gem install sinatra

Start the local asset server:

    $ rackup
    $ grunt watch

The assets are now available in your local web browser at e.g. `http://localhost:9292/application.css`. Sinatra is reading static files from the `public` directory.  Be sure to have the `watch` Grunt task running to have those files compiled whenever a source code file is changed.

### Load in Tomcat
A third way to serve the assets locally is by using Sitevisions bundled Tomcat server if you have Sitevision running locally. Follow the instructions for deploying the assets as a servlet below, but perform it on your local machine. After the servlet is loaded once, you can symlink the servlet's directory to the `public` directory in your workspace.


### Release

    $ npm version patch
    $ npm version minor
    $ npm version major

    $ git push

    $ git tag
    $ git tag v4.0.1
    $ git push tags

## License
Released under AGPL version 3.

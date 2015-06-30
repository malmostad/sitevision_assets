# Sitevision Assets

This repository contains the source for asset files used in the CMS Sitevision at www.malmo.se and the intranet at komin.malmo.se. Utilities for development and build are also included in this repo. The asset files, specific for this service, are used in addition to the [Global Assets](https://github.com/malmostad/global_assets) used on all our external web services.

## tl;dr
If you’re impatient and familiar with management of asset files using Grunt or other commonly used tools such as Rake or Sprockets, this is the short story:

```bash
# Setup
$ git clone git@github.com:malmostad/sitevision_assets.git
$ cd sitevision_assets
$ npm install

# During development
$ grunt watch          # watch `src` and generate to `public`
$ coffee app.coffee    # serve files from `public` on port 3000

# Build for deployment

# External website
$ grunt dist                        # generate files to `dist` for deployment
$ grunt dist --war                  # generate a servlet to `dist` for deployment
$ grunt dist --sourcemaps --war     # generate a servlet to `dist` for deployment in test with sourcemaps

# Intranet 
$ grunt dist-intra 
$ grunt dist-intra --war 
$ grunt dist-intra --sourcemaps --war 
```

If you’re not, read the rest of the instructions.


## Directory Structure
Configuration files used during development and build are in the project root. None of those files will be deployed to a server.

The `src` directory structure contains the source files for Sass/CSS and CoffeeScript. Will not be deployed to a server.

The contents of `public` and `dist` are excluded from the Git repository by the `.gitignore` file. Those are used as output directories for generated asset files during development and build distribution respectively. They are automatically cleaned when running tasks and can also be be clean manually with the `grunt clean` task.

`vendor` contains Sass utilities shared with our other applications. See *Shared Sass Utilities* below.


## Development Setup
Checkout the source code to your workspace:

    $ git clone git@github.com:malmostad/sitevision_assets.git
    $ cd sitevision_assets

After cloning the repository, install the dependencies for the project. Be sure to have [Node.js](http://nodejs.org) installed on your machine. Run:

    $ npm install

The dependencies defined in `package.json` will be installed in `node_modules`i the projects root. That directory is excluded in the `.gitignore` file from being committed with Git so you need to run the `npm install` command again if you switch to another local machine. To update the dependencies later, run `npm update`.


## Development
During development, it is in the `src` directory you are working. You want the asset files to be re-compiled automatically whenever you make changes to the source code. Use the Grunt `watch` task available in the project:

    $ grunt watch

The Sass and CoffeeScript files in the `src` directory will be compiled to the `public` directory as soon as they are changed as well as at the startup of the `watch` task. The `public` directory is automatically cleaned when you run the task.

If you want to have source maps generated for debugging of stylesheets and JavaScripts, add the ` --sourcemaps` argument:

    $ grunt watch --sourcemaps

If you for some reason want to generate the files in `public` once without having the watcher running, run one of the following:

```bash
    # External website
    $ grunt build
    $ grunt build --sourcemaps

    # Intranet
    $ grunt build-intra
    $ grunt build-intra --sourcemaps
```

Files generated to `public` directory must not be used for deployment to production, `dist` is used for that (see *Build for Deployment* below).


### Add and Remove Sass Files
Sass source files are in the `src/stylesheets/` directory. If you add or remove Sass files, edit the `src/stylesheets/application.scss` to have them compiled. Note that `@import` is a Sass directive executed during compilation, not the regular CSS equivalent that import files on the client side. When you run `grunt watch` or `grunt dist`, the `application.css` file concatenates the `@import` files in the given order. Regular CSS files can also be added as long as they have the `.scss` suffix.

To add a Sass file that should not be concatenated with the rest of the files, like the `ie7.scss` one, just add it to the `src/stylesheets` directory and it will be compiled to `public` and `dist` respectively.


### Add and Remove CoffeeScript Files
CoffeeScript source files are in the `src/javascripts/` directory. Unlike Sass files, you need to edit the `Gruntfile.coffee` file to add or remove files from compilation. The `coffee` task configuration block in the `Gruntfile.coffee` has a `files` object used for that. See the readme for [Grunt Coffee](https://github.com/gruntjs/grunt-contrib-coffee) for instructions and examples.


### Shared Sass Utilities
Sass utilities from our [shared_assets](https://github.com/malmostad/shared_assets) repository are attached to this repository. See the *Gettings Started* and *Grids and Responsive Design* sections of the [Web Application Guidelines v4](http://malmostad.github.io/wag-external-v4) for usage.

To update the Sass utilities for this project, if you e.g. need a fresh version of the `variables.scss` file, run:

    $ bower update

The updated files must be committed (to this repository) to ensure that all developers—working with this system—have the very same versions.


## Run a Lightweight Local Asset Server
The easiest way to serve the assets on your own machine during development is to fire up a lightweight server and have the `watch` task running. The project is configured with two alternatives that works in the same way.

Pro tip: If you don't want to run a development version of Sitevision on your own machine—which might be wise—and instead are running it on a development server in your network, you can still point the local assets `src/href`’s to `http://localhost/` as long as your co-developers are doing the same. And of course, this must not be the same server as other project members are visiting to review and test the solution.


### Using Express
You have already [Express](http://expressjs.com/) installed if you ran `npm install` in the setup step above. To serve the assets locally on your machine with Express, run:

    $ coffee app.coffee

The assets are now available for your local web browser at e.g. `http://localhost:3000/application.css`. Express is reading static files from the `public` directory. Be sure to have the `watch` task running to have those files compiled whenever a source code file is changed.


### Using Sinatra
The project is also configured to use [Sinatra](http://www.sinatrarb.com/) to serve the assets locally during development, if that is your preference. Be sure to have Ruby installed on your machine and run the following to enable Sinatra:

    $ gem install sinatra

Start the local asset server:

    $ rackup

The assets are now available in your local web browser at e.g. `http://localhost:9292/application.css`. Sinatra is reading static files from the `public` directory. Be sure to have the `watch` task running to have those files compiled whenever a source code file is changed.


## Build for Deployment
Before deploying, you must generate minified versions of the asset files, run:

```bash
    # External website
    $ grunt dist

    # Intranet
    $ grunt dist-intra
```

A new version will be compiled for deployment in the `dist` directory. The directory will be cleaned before the new files are generated.

To generate a Java servlet for deployment, add the `--war` argument to the command:

```bash
    # External website
    $ grunt dist --war

    # Intranet
    $ grunt dist-intra --war
```

A Java servlet named `local-assets-v4.war` ready for deployment will be created in the `dist` directory.


## Deploy
Deploying the Java servlet in the same Tomcat server as Sitevision is running in, is done in one step. Copy the `war` file to `/opt/sitevision/tomcat/webapps/` on the server and it will automatically be deployed and replace the previous version with the same name.


## License
Released under AGPL version 3.

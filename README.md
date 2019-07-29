# build-scripts-bash
Collection of bash scripts for building js/ts with different builders/transpilers/minifiers, for use in the browser or in specific web platforms

---

### [typescript-parcel-optimizely](./typescript-parcel-optimizely.sh)

Script to build typescript files in `./src` using [Parcel](http://parceljs.org) bundler. Each file in the top level inside `./src` will be treated independently and will be built individually. This allows having separate files for each page that you need to use in Optimizely and work with modules and such.

If a `project-javascript.js` file is present, the script copies it to the `./dist` folder with the bundled files. This file remains untouched.

Typescript files are compiled to JS and then bundled by Parcel. It should respect any configs in `tsconfig.json`, but it will not add polyfills if your es6 code requires them.

---

### [parcel-optimizely](./parcel-optimizely.sh)

Like typescript-parcel-optimizely, but with JS.

---

### [babel-parcel-global](./babel-parcel-global.sh)

Transpiles files in `./src` using [Babel](https://babeljs.io/) and appends & prepends:
1. An auto-executable function wrapper.
2. A cheap-ass ES6-only browser validator, by checking if `window.Promise` exists (This should be optional by arguments, it is in the to-do list)
3. A `window.$FILENAME = $FILENAME` statement. It adds a property with the file name to window. This assumes that your code will have a global variable with the same name as the filename.

The script also uses [Uglify.js](https://github.com/mishoo/UglifyJS2) to minify the transpiled files.

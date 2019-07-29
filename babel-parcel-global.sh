# Transpiles and minifies files in ./src, adds an es6 only condition and creates a global variable with the file's name

echo -e '\n\n👀  \033[0;32mStarting build process ...\033[0m'
echo -e '\n\n👀  \033[0;32mRunning Babel ...\033[0m'

# Requires Babel
for filename in src/*.js; do
  # Handle non existing files
  [ -e "$filename" ] || continue
  cp $filename lib/
  base=$(basename "$filename" | cut -f 1 -d '.')
  # Prepend es6 only condition
  echo "'use strict';
(function () {
  if (!window.Promise) {
    console.warn('Browser does not support ES6, not loading \"$base\"');
    return;
  }" | cat - lib/$(basename "$filename") > /tmp/out && mv /tmp/out lib/$(basename "$filename")
  sleep 0.05
  # Append global export and es6 only closing brackets
  echo -e "\n  window.${base^} = ${base^};\n})();\n" >> lib/$(basename "$filename")
  sleep 0.05
  # Transpile
  babel lib/$(basename "$filename") -d lib
done

echo -e '\n\n✅  \033[0;32mBabel done, minifying files ... \033[0m'

# For each transpiled file
for filename in lib/*.js; do
  # Handle non existing files
  [ -e "$filename" ] || continue
  # Handle already minified files
  if [[ $filename != *".min.js"* ]]; then
    base=$(basename "$filename" | cut -f 1 -d '.')
    minified=$base.min.js
    # Minify
    uglifyjs --compress --mangle --output lib/$minified -- $filename
  fi
done

echo -e '\n\n✅  \033[0;32mDone!\033[0m'

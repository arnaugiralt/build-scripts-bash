#!/bin/bash

# Script to build files in ./src and append & prepend code to make it work seamlessly in optimizely

for filename in src/*.ts; do
  parcel build $filename --no-minify
done

if test -r src/project-javascript.js; then
  cp src/project-javascript.js dist/project-javascript.js
  echo -e '\n\n✅  \033[0;32m"src/project-javascript.js" was copied to "dist/project-javascript.js"\033[0m'
fi

echo -n -e "Getting things ready for optimizely ."
for bundled in dist/*.js;do
  base=$(basename "$bundled")
  echo -ne "\b."
  sleep 0.05
  sed -i "s/\.default/['default']/g;" $bundled
  sleep 0.05
  sed -i "s/], null)/], null);/g" $bundled
  echo -ne "\b.."
  sleep 0.05
  if [ "$base" != "project-javascript.js" ]; then
    echo "function jsFunction() {" | cat - $bundled > /tmp/out && mv /tmp/out $bundled
    sleep 0.05
    echo -e "\n}" >> $bundled
  else
    sleep 0.05
  fi
  echo -ne "\b..."
  sleep 0.05
done
echo -ne -e"\b \033[0;32m✅ Done!\033[0m"

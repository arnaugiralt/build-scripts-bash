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
  echo -ne "\b.  "
  sleep 0.05
  sed -i "s/\.default/['default']/g;" $bundled # Swap reserved .default for ['default']
  sleep 0.05
  echo -ne "\b. ."
  sed -i "s/], null)/], null);/g" $bundled # Add semicolon
  sleep 0.05
  echo -ne "\b. ."
  sed -i '/^$/d' $bundled # Remove empty lines
  echo -ne "\b. ."
  sleep 0.05
  sed -i '/^[ \t]*\/\//d' $bundled # Remove inline comments preceded by whitespace
  echo -ne "\b. ."
  sleep 0.05
  if [ "$base" != "project-javascript.js" ]; then # Add stuff for opti & cheap-ass ES6 condition & wait for utils loaded event to trigger
    echo "function jsFunction() {

  if (!window.Promise) return false;
  else window.Promise = window.Promise || {};

  jQuery(document).on('perso_utils_loaded', function (ev, data) {
    if (data === true) {
" | cat - $bundled > /tmp/out && mv /tmp/out $bundled
    sleep 0.05
    echo -ne "\b. ."
    echo -e "\n    }\n  });\n}" >> $bundled
    sleep 0.05
    echo -ne "\b. ."
  else
    sleep 0.05
  fi
  echo -ne "\b. ."
  sleep 0.05
done
echo -ne -e"\b \033[0;32m✅ Done!\033[0m"

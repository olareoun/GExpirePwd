#!/bin/bash

function minimizejs {
    echo "minimizing js..."
    JS_DIR=./web/public/
    MIN_JS=app.js
    APP_JS=app-dev.js
    #SOURCE_MAP=app.js.map
    SOURCES=`cat ./build_tools/sources.list`
    TEST_FILE="(.*)/test/(.*)"

    for file in ${SOURCES} ; do
        if [[ $file =~ $TEST_FILE ]]; then
            echo "ignorado fichero " $file
        else
            cat $JS_DIR$file >> $APP_JS ;
        fi
    done

    java -jar ./build_tools/compiler.jar --js $APP_JS \
         --js_output_file $MIN_JS
    #     --create_source_map $SOURCE_MAP \
    #     --source_map_format=V3\
    #     --js_output_file $MIN_JS

    #enabled webkit to load source maps
    # echo "//@ sourceMappingURL=${SOURCE_MAP}" >> $MIN_JS

    rm $APP_JS
    mv $MIN_JS  -t $JS_DIR/js
    echo ".. js minimized"
}



echo "creating brach and deploying to notebook2reveal"
git checkout master
git pull origin master
git branch -D deploy
git checkout -b deploy
#minimizejs
git add -f web/public/js/app.js
git rm -r web/public/js/test
git commit -m "minified"
git push -f heroku deploy:master
git reset --hard
git checkout master
git branch -D deploy

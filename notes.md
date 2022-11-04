## install husky
yarn remove husky

yarn add -D husky@4

yarn add -D husky

npm set-script prepare "husky install" && yarn prepare

npx husky add .husky/pre-commit "yarn lint-staged"

git commit -m "added husky and lint-stagged" // here you will notice the lint-staged checking the files with help of husky
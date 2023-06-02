# 使用偏好 test

1、vscode 代码片段添加

###

test release 01


update 01
update 02

-----

### changelog

 - [changelog] 
    - https://github.com/CookPete/auto-changelog
    - npm install auto-changelog --save-dev
    ```
    // package.json
      "scripts": {
            "version": "auto-changelog -p && git add CHANGELOG.md"
        }
    ```
     - npm run version
     - npm version patch | minor | major

# 使用偏好 test
1
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


  - [增加仓库node版本、包管理器使用限制]
    ```
      pnpm install -D only-allow // 安装限制包依赖
      "preinstall": "npx -y only-allow pnpm" // package.json 增加包命令验证
      "engines": { // 增加node版本、包管理器版本限制
        "node": "16.x",
        "pnpm": "8.x"
      },
      .npmrc // 增加文件 强制 （engine-strict = true）
    ```
    - corepack enable // 项目路径下执行
    - "packageManager": "pnpm@8.6.0", // 强制包版本

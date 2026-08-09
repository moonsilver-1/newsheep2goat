# HDU Wiki · 知识库

杭电（HDU）学生协作知识库，一个内容，三端触达。

## 项目结构

```
newsheep2goat/
├── hdu-wiki-frontend/   # 网站（内容源）— Next.js，部署在 Vercel
├── desktop-app/         # 电脑客户端 — Electron，加载线上网站 + 桌面增强
└── dudu-app/            # 手机 App「dudu百科」— Expo React Native，内容离线打包
```

## 三端关系

| | 网站 | 桌面 App | 手机 App |
|---|---|---|---|
| **仓库** | [hdu-wiki-frontend](https://github.com/moonsilver-1/hdu-wiki-frontend) | [hdu-wiki-desktop](https://github.com/moonsilver-1/hdu-wiki-desktop) | [dudu-app](https://github.com/moonsilver-1/dudu-app) |
| **技术栈** | Next.js 16 + pnpm | Electron + Next.js | Expo RN 52 |
| **内容来源** | 实时（content/*.md） | 实时（加载线上网站） | 离线打包进 APK（构建期渲染） |
| **分发** | hdu-wiki.cn | GitHub Release (.exe/.dmg) | GitHub Release (.apk) |
| **在线/离线** | 在线 | 在线（已读页面有缓存） | 完全离线 |

## 各端特色

### 🌐 网站（hdu-wiki-frontend）
- 内容源：所有 markdown 在 `content/` 下，三端共用
- 部署：Vercel 自动部署（push main 即触发）
- 本地开发：`pnpm install && pnpm dev`

### 💻 桌面 App（desktop-app）
- 在线壳：加载 hdu-wiki.cn，桌面端增强
- 功能：启动动画、收藏、检查更新、断网提示、预加载下一篇
- 隐藏网页里的"下载"入口（桌面端不需要自己下载自己）
- 打包：`pnpm package:win`（Windows）/ `package:mac`（macOS）

### 📱 手机 App「dudu百科」（dudu-app）
- 完全离线：131+ 篇文章 + KaTeX 公式 + 代码高亮全打包进 APK
- 功能：收藏、阅读进度、搜索高亮、阅读设置、夜间自动、分享卡片、检查更新
- 内容更新：`npm run build:content` 重新生成 + `npm run release` 出包
- 签名：`android/dudu.keystore`（别丢，丢了新版别人装不上）

## 内容更新流程

网站 `content/*.md` 有改动后：
1. **网站**：push 到 main，Vercel 自动部署
2. **桌面 App**：无需改动（加载线上网站，自动同步）
3. **手机 App**：`cd dudu-app && npm run build:content && npm run release`，出新 APK

## 工作区说明

本目录（`newsheep2goat/`）是**本地工作区**，不是 Git 仓库。
每个子项目有自己独立的 Git 仓库和 GitHub 远程，各自独立提交、独立发布 Release。

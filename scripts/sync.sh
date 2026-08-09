#!/usr/bin/env bash
# HDU Wiki 多端工作区 helper 脚本
#
# 用法（在根目录运行）：
#   ./scripts/sync.sh status    查看三端 git 状态（最常用）
#   ./scripts/sync.sh pull      拉取所有子项目最新代码
#   ./scripts/sync.sh push      子项目有新提交后，更新根仓库引用并推送
#   ./scripts/sync.sh push -m "xxx"  同上，附带提交信息

set -e
cd "$(dirname "$0")/.."

SUBMODULES=(hdu-wiki-frontend desktop-app dudu-app)

# 颜色
G='\033[0;32m'; Y='\033[0;33m'; B='\033[0;34m'; N='\033[0m'

case "${1:-status}" in

  # ─── status: 看三端状态 ─────────────────────────────────
  status)
    echo -e "${B}=== 三端 git 状态 ===${N}"
    for sub in "${SUBMODULES[@]}"; do
      echo ""
      echo -e "${B}[$sub]${N}"
      cd "$sub" 2>/dev/null || { echo "  跳过（不存在）"; continue; }
      branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?")
      ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
      behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
      dirty=$(git status --porcelain 2>/dev/null | wc -l)
      echo "  分支: $branch | 领先远程: $ahead | 落后远程: $behind | 未提交: $dirty"
      if [ "$dirty" -gt 0 ]; then
        git status --short | head -5 | sed 's/^/    /'
      fi
      cd ..
    done
    echo ""
    echo -e "${B}[根仓库 newsheep2goat]${N}"
    branch=$(git rev-parse --abbrev-ref HEAD)
    echo "  分支: $branch"
    git submodule status | sed 's/^/  /'
    ;;

  # ─── pull: 拉取所有子项目最新 ───────────────────────────
  pull)
    echo -e "${G}拉取所有子项目...${N}"
    git submodule update --remote --merge
    echo -e "${G}✓ 子项目已更新到各自最新${N}"
    echo -e "${Y}提示：如果子项目有新提交，根仓库的引用也变了，运行 ./scripts/sync.sh push 同步${N}"
    ;;

  # ─── push: 更新根仓库引用并推送 ─────────────────────────
  push)
    msg="${3:-update submodule references}"
    # 确保所有子项目的改动已提交
    for sub in "${SUBMODULES[@]}"; do
      cd "$sub"
      if [ -n "$(git status --porcelain)" ]; then
        echo -e "${Y}⚠ $sub 有未提交改动，先提交子项目：cd $sub && git add -A && git commit${N}"
        exit 1
      fi
      cd ..
    done
    # stage 子模块引用变化
    git add "${SUBMODULES[@]}"
    if git diff --cached --quiet; then
      echo -e "${G}根仓库引用无变化（子项目没新提交）${N}"
    else
      git commit -m "$msg"
      git push
      echo -e "${G}✓ 根仓库已推送${N}"
    fi
    ;;

  *)
    echo "用法: $0 {status|pull|push}"
    echo "  status          查看三端 git 状态"
    echo "  pull            拉取所有子项目最新代码"
    echo "  push [-m msg]   更新根仓库引用并推送"
    exit 1
    ;;
esac

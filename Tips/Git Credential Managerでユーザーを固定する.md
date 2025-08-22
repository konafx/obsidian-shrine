#git 

Git GUIでインストールできるGit Credential Managerを使うと、https経由でtoken管理を意識せずにユーザー認証できる（雑な説明）

複数ユーザーでログインしているとき、git push/pull/fetchのタイミングで「どのユーザーで認証しますか？」な画面が出てくる。
fetch を勝手にしてくれるエディターなどでprivate repositoryを開くと都度都度認証ユーザーを聞いてきて鬱陶しい。

これを解消したい

## 解決先
```gitconfig
[credential "https://github.com"]
	username = hoge
```
でユーザーを指定する

### 気になる
```gitconfig
[github]
	username = hoge
```
はどういう設定？
→ghqが解釈する設定だった。credential helperで解釈してくれると勘違いしていた。

## できないこと
ユーザーは切り替わってくれるけど、認証情報まではgh auth switchを自動でしないため重い。
https://zenn.dev/herp_inc/articles/switch-gh-accounts-automatically
このスクリプトをローカルに設定してなんとかしたいですね

これよさそう
https://blog.shukebeta.com/2025/08/19/github-cli-multi-account-auto-switcher-zero-config-solution/
## Ref
- [git-credential-manager/docs/multiple-users.md at main · git-ecosystem/git-credential-manager · GitHub](https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/multiple-users.md)
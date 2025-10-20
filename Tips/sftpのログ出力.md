[rsyslog](https://www.rsyslog.com)を使う
ファシリティを使う方法と、unix socket を使う方法の２つがある。
ファシリティを使う方法の方が簡単だったのでこっちについて説明する。
unix socket を使う方法はなんかいいことあるんですかね。実際ログの中身は変わらなかったです。
rsyslog 側でログ形式をいじれたりするんかな。詳しくないのでわからないです

## rsyslog
`/etc/rsyslog.conf`に以下を追記し、rsyslog で LOCAL5 に出力されたログをキャッチ？する
```rsyslog.conf
local5.* /var/log/sftp
```
[rsyslog.confの文法 - Qiita](https://qiita.com/11ohina017/items/087b1b7c4411c3b3195a)

うまくいってるか確認したいときは`logger -p local5.info "test log"`とか打って、`tail -f /var/log/sftp`すればいいと思う

## sshd
`/etc/ssh/sshd_config`を以下のようにいじる
LOCAL5 に向かってログを出力し、その粒度は VERBOSE という設定にしている
SSH のログの場合は `LogLevel` をいじればいいと思う（やってない）
```sshd_config
SyslogFacility LOCAL5
# ↓は ForceCommand 書いてるならいらないかも？
Subsystem sftp	internal-sftp -l VERBOSE

Match Group hoge
    # SFTP強制にしたい場合は ForceCommand にも`-l VERBOSE` を書く
 	ForceCommand internal-sftp -l VERBOSE
```
ぐぐると`SyslogFacility`について言及せず、`Subsystem sftp internal-sftp -f LOCAL5 -l VERBOSE`と書いてる人が多いが、今回その方法でやってみて一切ログを出力してくれなかった。環境によるのか。
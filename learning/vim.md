#vim 

## `:buffers`のリストをquickfixに投げる
vim-jpの転載
> [teramako 11:28](https://vim-jp.slack.com/archives/CJMV3MSLR/p1658888880430969)
> `:buffers` のリストをquickfix へ書き込むことって簡単にできるでしょうか？ `:buffers | cw` みたいな感じで。

>[rbtnn 12:03](https://vim-jp.slack.com/archives/CJMV3MSLR/p1658890990232779)
> `call setqflist(getbufinfo({ 'buflisted': 1 }))`
> これだけでいけそう 

`:call setqflist(getbufinfo({ 'buflisted': 1} })) | cw`
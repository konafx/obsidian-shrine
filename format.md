# Neovim Lint/Format 設定

## 1. Formatter/Linterのインストール設定

**ファイル**: `dot_config/nvim/lua/plugins.lua:146-164`

```lua
{
  'jay-babu/mason-null-ls.nvim',
  lazy = false,
  dependencies = {
    'nvimtools/none-ls.nvim',
  },
  config = function()
    require('mason-null-ls').setup({
      ensure_installed = { 'prettier', 'stylua' },  -- ここでツールを指定
      automatic_installation = false,
      automatic_setup = true,
    })
    require('null-ls').setup({
      capabilities = vim.lsp.protocol.make_client_capabilities(),
    })
  end,
},
```

インストールされているツール

- prettier: JavaScript/TypeScript/CSS/HTML等のフォーマッタ
- stylua: Luaフォーマッタ

## 2. フォーマット実行コマンド

ファイル: dot_config/nvim/after/plugin/lsp.rc.lua:93-95

```
vim.keymap.set('n', ']F', function()
  vim.lsp.buf.format({ async = true })
end)
```

キーマップ: ]F (ノーマルモード)

## 3. ESLint設定

ファイル: dot_config/nvim/lsp/eslint.lua:1-5
```
return {
  settings = {
    format = { enable = true }
  }
}
```

ESLintによるフォーマットが有効化されています。

## 4. 補足情報

- dot_config/nvim/after/plugin/null-ls.rc.lua は現在全てコメントアウトされています
- 設定は plugins.lua で直接管理されています
- Mason経由でツールが自動管理されます

使用方法

1. フォーマット実行: ノーマルモードで ]F を入力
2. ツール追加: plugins.lua の ensure_installed 配列にツール名を追加
3. 設定確認: :Mason コマンドでインストール済みツールを確認
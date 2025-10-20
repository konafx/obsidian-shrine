## satisfies
version 4.9から
```typescript
import type { RouteObject } from "react-router-dom"
const routes = [
	{
		path: "/",
	    element: <HomePage />,
	},
] as const as satisfies RouteObject[]
```

これが一番分かった
[TS 4.9 satisfies operator を使って React Router のナビゲーションを型安全にしてみる - Mobile Factory Tech Blog](https://tech.mobilefactory.jp/entry/2022/12/01/000000)
他の記事だと`Record<>`とcolorの例ばっかで、元から何が悲しいのか分かってなかったので、何がうれしいのかよくわからなかった。
具象に型を与えることが思ってたよりだるいということが分かった。

型制約は与えるけど具象の宣言を尊重する。か？

> ルーティングオブジェクトの宣言に `RouteObject[]` 型の制約を課すために形注釈をつけると
```typescript:test.ts
import type { RouteObject } from "react-router-dom"
const routes: RouteObject[] = [
	{
		path: "/",
	    element: <HomePage />,
	},
]
```
> 制約は課すことができますが、routes は `RouteObject[]` 型に解決されてしまうので、具体的なルーティング(`/`) を型情報から拾うことができません

型定義は具体的な値（`{path: "/", element: <HomePage />}`）の宣言による情報を持たない。
型の制約を与えると具体的な宣言の情報が抜けてしまう。

これが
>・宣言に型の制約を課しつつ
>・型自体は宣言から具体な型に解決させる
>はちょっと実現が面倒です

と書かれていたこと

> 宣言に合わせた型を拾いたいなら注釈をつけずに `as const` を使うのが有効です
```typescript:test2.ts
const routes = [
	{
		path: "/",
		element: <HomePage />,
	},
] as const
```
 > ただし、今度は routes に `RouteObject[]` な制約をかけられていません
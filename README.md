A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.
# rich_text_converter

## このリポジトリとは？
- リッチテキストで取得したコードをシンプルテキストに変換する。
  - `<br />`で表現されている場合は、` \n`に差し替える。
  - `<blockquote>`で表現されている場合は、`\t`に差し替える。
  - それ以外は文字だけを取得できるようにする。

## 注意事項
- ネストした場合の考慮が必要

## Packages
https://pub.dev/packages/html

## 参考文献

https://zenn.dev/tris/articles/9705b93a02425f

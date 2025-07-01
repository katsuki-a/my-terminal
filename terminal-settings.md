# ターミナルの設定手順

前提

- シェルがzshであること
- brewがインストールされていること

1. homebrewでiterm2をインストールする
2. https://github.com/Arc0re/Iceberg-iTerm2/blob/master/README.md の手順に従ってIcebergテーマをインストールし、適用する
3. https://github.com/sorin-ionescu/prezto/blob/master/README.md の手順に従ってPreztoをインストールする
4. zstyle ':prezto:module:prompt' theme 'sorin' の theme の箇所を pure にする
5. `zstyle ':prezto:load' pmodule` に `syntax-highlighting`, `autosuggestions` を追加する(`prompt` よりも前に設定する)

# iTerm2 + zsh + Prezto 環境構築手順

macOS向けのモダンなターミナル環境を構築するための手順書です。
`setup.sh`スクリプトを実行することで、これらの設定を自動的に適用できます。

## 特徴

- **iTerm2**: macOS標準のターミナルよりも高機能なターミナルエミュレータ
- **zsh**: 現在のmacOSでデフォルトの強力なシェル
- **Prezto**: zshを使いやすくするための設定フレームワーク
- **Iceberg**: 目に優しいダークなカラーテーマ
- **Pure**: シンプルで美しいプロンプトテーマ
- **Syntax Highlighting**: コマンドの構文をハイライト
- **Autosuggestions**: コマンド履歴に基づいて入力候補を提示

## 前提条件

- macOS環境であること
- [Homebrew](https://brew.sh/ja/)がインストール済みであること
- シェルが`zsh`であること（macOS Catalina以降のデフォルト）

## 自動セットアップ

1.  リポジトリをクローンまたはダウンロードします。
2.  ターミナルでリポジトリのディレクトリに移動します。
3.  以下のコマンドを実行して、セットアップスクリプトに実行権限を付与します。

    ```bash
    chmod +x setup.sh
    ```

4.  スクリプトを実行します。

    ```bash
    ./setup.sh
    ```

5.  スクリプトの指示に従ってください。Icebergテーマの適用など、一部手動での操作が必要です。
6.  完了後、ターミナルを再起動するか、以下のコマンドを実行すると設定が反映されます。

    ```bash
    source ~/.zshrc
    ```

## 手動での設定内容

`setup.sh`は以下の手順を自動化したものです。

1.  **iTerm2のインストール**
    ```bash
    brew install --cask iterm2
    ```

2.  **Icebergテーマのインストールと適用**
    - [Iceberg for iTerm2](https://github.com/Arc0re/Iceberg-iTerm2)の指示に従い、テーマファイルをダウンロードしてiTerm2に設定します。

3.  **Preztoのインストール**
    - [Prezto](https://github.com/sorin-ionescu/prezto)の公式手順に従ってインストールします。

4.  **Preztoプロンプトテーマの変更**
    - `~/.zpreztorc`ファイルを開き、プロンプトのテーマを`sorin`から`pure`に変更します。
      ```zsh
      zstyle ':prezto:module:prompt' theme 'pure'
      ```

5.  **Preztoモジュールの追加**
    - `~/.zpreztorc`ファイルを開き、`pmodule`のリストに`syntax-highlighting`と`autosuggestions`を追加します。これらは`prompt`モジュールよりも前に読み込む必要があります。
      ```zsh
      zstyle ':prezto:load' pmodule \
        'syntax-highlighting' \
        'autosuggestions' \
        ...
      ```

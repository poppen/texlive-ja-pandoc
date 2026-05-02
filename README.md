# texlive-ja-pandoc

[`paperist/texlive-ja:latest`](https://hub.docker.com/r/paperist/texlive-ja)（日本語TeXLive入りのDebianベースイメージ）に最新の [pandoc](https://github.com/jgm/pandoc) を載せた Docker イメージです。Markdown → PDF（LuaLaTeX 経由）変換などを 1 コンテナで完結させます。

- ベースイメージ: `paperist/texlive-ja:latest`（Debian 13.4-slim、`linux/amd64` + `linux/arm64`）
- 同梱: pandoc 公式 `.deb`、`make`、`fonts-noto-cjk` / `fonts-noto-cjk-extra`
- 公開先: `ghcr.io/poppen/texlive-ja-pandoc`

## 使い方

```sh
# 最新版を取得
docker pull ghcr.io/poppen/texlive-ja-pandoc:latest

# pandoc が動くか確認
docker run --rm ghcr.io/poppen/texlive-ja-pandoc:latest pandoc --version

# Markdown → HTML（カレントディレクトリをマウント）
docker run --rm -v "$PWD:/workdir" ghcr.io/poppen/texlive-ja-pandoc:latest \
  pandoc -f markdown -t html -o out.html input.md

# Markdown → PDF（LuaLaTeX 経由、日本語対応）
docker run --rm -v "$PWD:/workdir" ghcr.io/poppen/texlive-ja-pandoc:latest \
  pandoc --pdf-engine=lualatex -V documentclass=ltjsarticle -o out.pdf input.md
```

## タグ

| タグ | 内容 |
|------|------|
| `latest` | 直近 `main` の HEAD でビルドしたイメージ |
| `pandoc-<version>` | 当該 pandoc バージョンでビルドしたイメージ（例: `pandoc-3.9.0.2`） |
| `sha-<short>` | コミット単位の固定タグ |

## ローカルでビルドする

```sh
# amd64 のみローカルにロード
docker buildx build --platform linux/amd64 --load -t texlive-ja-pandoc:dev .

# pandoc バージョンを指定したい場合
docker buildx build --build-arg PANDOC_VERSION=3.9.0.2 --load -t texlive-ja-pandoc:dev .
```

## 自動更新の仕組み（GitHub Actions）

3 つのワークフローでベースイメージと pandoc 双方の追随を自動化しています。

| ワークフロー | トリガー | 役割 |
|--------------|----------|------|
| [`build.yml`](.github/workflows/build.yml) | `main` への push / PR / 他ワークフローからの呼び出し | マルチアーチビルド検証と `ghcr.io` への push |
| [`rebuild-on-base.yml`](.github/workflows/rebuild-on-base.yml) | 毎日 03:17 UTC | `paperist/texlive-ja:latest` の digest が変化したら `build.yml` を呼んで再ビルド |
| [`update-pandoc.yml`](.github/workflows/update-pandoc.yml) | 毎日 05:23 UTC | `jgm/pandoc` の最新リリースを確認し、`Dockerfile` の `ARG PANDOC_VERSION` を書き換える PR を自動作成 |

ベースイメージは `latest` タグを上書き運用（datestamp タグ無し）のため、digest 比較で変化を検出します。pandoc は `ARG` で固定 → 自動 PR 経由でバージョンを上げる構成にしているので、変更履歴がコミットとして残ります。

## ライセンス

MIT。ただし base image・pandoc・TeXLive 各々のライセンスはそれぞれの配布元に従います。

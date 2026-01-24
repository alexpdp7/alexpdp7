# `blog_v2`

## Migration

```
rm -rf target && uv run blog migrate ../blog/ target/migrated && uv run blog build target/migrated/ target/built/ && rsync -r target/built/ /home/alex/public_html/ --delete-after
```

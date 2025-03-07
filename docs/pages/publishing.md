# Publishing

Be sure all **tests** pass!

```bash
bundle exec rake test
```

Also check the **linter**:

```bash
bundle exec rubocop
```

Update the version in `lib/unisec/version.rb`.

Update the documentation, at least:

- `README.md`
- `docs/CHANGELOG.md`
- `docs/pages/usage.md`

On new release don't forget to rebuild the **library documentation**:

```bash
bundle exec yard doc
```

Create an **annotated git tag**:

```bash
git tag -a v1.5.0
```

Push the changes including the tags:

```bash
git push --follow-tags
```

Build the **gem**:

```bash
gem build unisec.gemspec
# or
bundle exec rake build
```

Push the new gem release on **RubyGems** See https://guides.rubygems.org/publishing/.

```bash
gem push unisec-1.5.0.gem
```

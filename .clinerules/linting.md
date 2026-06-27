# Linting

Linting ensure the syntax and formatting consistency.

# Check for violation

- The command `bundle exec rubocop` can used to check if any violation exist.

## Autocorrection

- `bundle exec rubocop -a` autocorrects offenses safely
- `bundle exec rubocop -A` autocorrects offenses for more rules but can introduce breaking changes (to avoid)

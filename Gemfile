# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in .gemspec
gemspec

# Needed for the CLI only
group :runtime, :cli do
  gem 'dry-cli', '~> 1.3' # for arg parsing
  gem 'paint', '~> 2.3' # for colorized ouput
end

# Needed for the CLI & library
group :runtime, :all do
  gem 'ctf-party', '~> 4.0' # string conversion
  gem 'twitter_cldr', '~> 6.13' # ICU / CLDR
  gem 'unicode-confusable', '~> 1.13' # confusable chars
end

# Workaround waiting for upstream bug fixes
group :runtime, :fixes do
  gem 'bigdecimal', '~> 3.3' # https://github.com/twitter/twitter-cldr-rb/pull/277
end

# Needed to install dependencies
group :development, :install do
  gem 'bundler', '~> 2.1'
end

# Needed to run tests
group :development, :test do
  gem 'minitest', '~> 5.27'
  gem 'minitest-skip', '~> 0.0' # skip dummy tests
  gem 'rake', '~> 13.3'
end

# Needed for linting
group :development, :lint do
  gem 'rubocop', '~> 1.82'
end

group :development, :docs do
  gem 'commonmarker', '~> 2.0' # for markdown support in YARD
  gem 'webrick', '~> 1.9' # for yard server
  # gem 'yard', ['>= 0.9.27', '< 0.10']
  # https://github.com/lsegal/yard/issues/1528
  gem 'yard', github: 'ParadoxV5/yard', ref: '9e869c940859570b07b81c5eadd6070e76f6291e', branch: 'commonmarker-1.0'
  gem 'yard-coderay', '~> 0.1' # for syntax highlight support in YARD
end

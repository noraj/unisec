# frozen_string_literal: true

require 'rake/testtask'
require 'bundler/gem_tasks'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/test_*.rb']
end

desc 'Run tests'
task default: :test

desc 'Update Unicode Data files'
task :ucd do
  require 'net/http'
  DerivedName = 'https://www.unicode.org/Public/UCD/latest/ucd/extracted/DerivedName.txt'
  files = [DerivedName]

  files.each do |file|
    filename = File.basename(URI(file).path)
    download(DerivedName, File.join(__dir__, "data/#{filename}"))
    puts "[+] Updated data/#{filename}"
  end
end

## Utils ##

def download(url, dest_path)
  uri = URI.parse(url)

  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
    request = Net::HTTP::Get.new(uri)

    http.request(request) do |response|
      raise "Failed (#{response.code})" unless response.is_a?(Net::HTTPSuccess)

      # Open the destination file in write‑binary mode.
      # This truncates the file if it already exists, effectively overwriting it.
      File.open(dest_path, 'wb') do |file|
        response.read_body do |chunk|
          file.write(chunk)
        end
      end
    end
  end
end

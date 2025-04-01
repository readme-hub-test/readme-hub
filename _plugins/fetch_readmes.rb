require 'net/http'
require 'json'
require 'uri'

module Jekyll
  class FetchReadmes < Generator
    safe true

    def generate(site)
      org_name = "readme-hub-test"
      github_api_url = "https://api.github.com/orgs/#{org_name}/repos"
      uri = URI(github_api_url)

      response = Net::HTTP.get(uri)
      repos = JSON.parse(response)

      site.data["readmes"] = []

      repos.each do |repo|
        repo_name = repo["name"]
        readme_url = "https://raw.githubusercontent.com/#{org_name}/#{repo_name}/main/README.md"

        begin
          readme_content = Net::HTTP.get(URI(readme_url))
          site.data["readmes"] << { "name" => repo_name, "content" => readme_content }
        rescue
          Jekyll.logger.warn "Couldn't call README for #{repo_name}"
        end
      end
    end
  end
end

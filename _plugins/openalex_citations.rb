# frozen_string_literal: true

# Fetches citation counts from OpenAlex (https://openalex.org) at build time
# for every entry in the bibliography that has a DOI, and exposes them as
#
#   site.data["openalex_citations"]["10.1109/tcad.2020.3012240"]
#     => { "count" => 19, "id" => "W3046157311" }
#
# The counts are baked into the static HTML, so visitors never contact a third
# party. _layouts/bib.liquid renders a "Cited by N" button when N > 0.
#
# Config (_config.yml):
#   openalex_citations:
#     enabled: true
#
# Set OPENALEX_API_KEY (free key, https://openalex.org/settings/api) in the
# build environment; without it requests share a small per-IP daily budget.
# If OpenAlex is unreachable or refuses, the build continues without counts.

require "json"
require "net/http"
require "uri"

module OpenAlexCitations
  API = "https://api.openalex.org/works"
  CACHE_TTL = 6 * 60 * 60 # seconds; avoids refetching on every `jekyll serve` rebuild

  class Generator < Jekyll::Generator
    safe true
    priority :highest

    @cache = nil
    @cached_at = nil

    class << self
      attr_accessor :cache, :cached_at
    end

    def generate(site)
      config = site.config["openalex_citations"] || {}
      return unless config["enabled"]

      dois = collect_dois(site)
      return if dois.empty?

      klass = self.class
      if klass.cache.nil? || klass.cached_at.nil? || Time.now - klass.cached_at > CACHE_TTL
        fetched = fetch(dois)
        if fetched
          klass.cache = fetched
          klass.cached_at = Time.now
        end
      end

      site.data["openalex_citations"] = klass.cache || {}
    end

    private

    def collect_dois(site)
      scholar = site.config["scholar"] || {}
      source = scholar["source"] || "/_bibliography/"
      files = Array(scholar["bibliography"] || "references.bib")

      files.flat_map do |name|
        path = File.join(site.source, source, name)
        next [] unless File.exist?(path)

        File.read(path, encoding: "UTF-8")
            .scan(/^\s*doi\s*=\s*[{"]\s*([^}"\s]+)\s*[}"]/i)
            .flatten
            .map(&:downcase)
            .select { |doi| doi.match?(%r{\A10\.\d{4,9}/\S+\z}) && !doi.include?("...") }
      end.uniq
    end

    # One lookup per DOI (/works/doi:...): the filter endpoint misses some
    # DOIs (e.g. the TU Wien thesis), single lookups resolve them reliably.
    def fetch(dois)
      api_key = ENV["OPENALEX_API_KEY"].to_s.strip
      result = {}

      dois.each do |doi|
        uri = URI("#{API}/doi:#{doi}")
        uri.query = URI.encode_www_form(select: "id,cited_by_count")

        # Net::HTTP's own :ENV lookup only reads http_proxy; honour https_proxy too.
        proxy = uri.find_proxy
        http_args = [uri.host, uri.port]
        http_args += [proxy.host, proxy.port, proxy.user, proxy.password] if proxy

        response = Net::HTTP.start(*http_args, use_ssl: true, open_timeout: 10, read_timeout: 20) do |http|
          request = Net::HTTP::Get.new(uri)
          request["User-Agent"] = "jekyll-openalex-citations"
          request["Authorization"] = "Bearer #{api_key}" unless api_key.empty?
          http.request(request)
        end

        next if response.is_a?(Net::HTTPNotFound) # not indexed (yet)

        unless response.is_a?(Net::HTTPSuccess)
          hint = api_key.empty? ? " (no OPENALEX_API_KEY set)" : ""
          Jekyll.logger.warn "OpenAlex:", "HTTP #{response.code}#{hint}, building without citation counts"
          return nil
        end

        work = JSON.parse(response.body)
        result[doi] = { "count" => work["cited_by_count"].to_i, "id" => work["id"].to_s.split("/").last }
      end

      Jekyll.logger.info "OpenAlex:", "citation counts for #{result.size}/#{dois.size} DOIs"
      result
    rescue StandardError => e
      Jekyll.logger.warn "OpenAlex:", "#{e.class}: #{e.message} (building without citation counts)"
      nil
    end
  end
end

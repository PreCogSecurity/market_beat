# Copyright (c) 2011-12 Michael Dvorkin
#
# Market Beat is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'rexml/document'
require 'net/http'
require 'uri'
require 'yaml'

module MarketBeat
  class Google
    URL = 'http://www.google.com/ig/api?stock='.freeze
    REAL_TIME_URL = 'http://finance.google.com/finance/info?client=ig&q='.freeze

    class << self
      metrics = YAML.load_file(File.dirname(__FILE__) + '/google.yml')
      metrics.each do |key, value|
        if value.to_s !~ /real_time$/
          define_method value do |ticker|
            from_xml fetch(ticker), key
          end
        else
          define_method value do |ticker|
            from_json fetch(ticker, :real_time), key
          end
        end
      end

      private
      def fetch(ticker, real_time = false)
        uri = URI.parse("#{real_time ? REAL_TIME_URL : URL}#{ticker}")
        response = Net::HTTP.get_response(uri)
        response.body
      rescue StandardError => e
        raise FetchError, "Failed to fetch Google finance data for #{ticker}: #{e.message}"
      end

      def from_xml(xml, metric)
        doc = REXML::Document.new(xml)
        elem = doc.elements["//finance/#{metric}"]
        return nil unless elem && elem.attributes
        data = elem.attributes['data']
        data.empty? ? nil : data
      rescue StandardError => e
        raise ParseError, "Failed to parse Google XML response for metric #{metric}: #{e.message}"
      end

      def from_json(json, metric)
        json =~ /"#{metric}"\s*\:\s*"(.+?)"/ ? $1 : nil
      rescue StandardError => e
        raise ParseError, "Failed to parse Google JSON response for metric #{metric}: #{e.message}"
      end
    end
  end
end

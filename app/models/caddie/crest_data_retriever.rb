require 'pp'

module Caddie
  module CrestDataRetriever

    CREST_BASE_URL='https://crest-tq.eveonline.com/'

    def get_markets( region_id, type_id, thread_log_file: nil )

      debug = ENV[ 'EBS_DEBUG_MODE' ] && ENV[ 'EBS_DEBUG_MODE' ].downcase == 'true'
      output = thread_log_file ? thread_log_file : STDERR

      type_url = "https://crest-tq.eveonline.com/inventory/types/#{type_id}"
      items, connections_count = get_multipage_data( "market/#{region_id}/history/?type=#{type_url}", debug, thread_log_file: thread_log_file )

      [ items, connections_count ]
    end

    private

    def get_crest_url( rest )
      "#{CREST_BASE_URL}/#{rest}/"
    end

    def get_multipage_data( rest, debug_request = false, thread_log_file: nil )

      output = thread_log_file ? thread_log_file : STDOUT

      next_url = get_crest_url( rest )
      items = []
      connections_count = 0
      begin

        output.puts "Fetching : #{next_url}" if debug_request

        @start_time ||= Time.now
        @hit_count ||= 0
        @hit_count += 1

        json_result = open( next_url ).read
        connections_count += 1
        parsed_json = JSON.parse( json_result )

        next_url = nil

        items += parsed_json['items']
        next_url_hash = parsed_json['next']
        next_url = next_url_hash['href'] if next_url_hash

      end while next_url

      output.puts "Retrieved items.count = #{items.count}" if debug_request

      [ items, connections_count ]
    end

  end
end

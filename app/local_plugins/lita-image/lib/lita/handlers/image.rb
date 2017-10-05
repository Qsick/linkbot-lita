require 'open-uri'
require 'image_size'
require 'uri'
require 'cgi'
require 'hpricot'
require 'pp'

module Lita
  module Handlers
    class Image < Handler
      extend Lita::Handler::ChatRouter
      $last_message = {}
      route(/^image(?: (.+))?/, :image, help: { "!image [searchity search] " => "Return a relevant picture" })
      route(/[^image](.*)/, :last_message)

      def last_message(response)
        $last_message[response.room.id] = response.message.body.length > 140 ?
          "#{response.message.body[0...140]}" :
          response.message.body

        pp $last_message
      end

      def image(response)
        images = []

        searchterm = response.matches[0][0]
        if searchterm.nil?
          if $last_message[response.room.id].nil?
            doc = Hpricot(open("http://www.randomword.net").read)
            searchterm = doc.search("#word h2").text.strip
          else
            searchterm = $last_message[response.room.id]
          end
        end
        puts "Getting image for #{searchterm}"

        searchterm = URI.encode(searchterm)
        searchurl = "https://www.google.com/search?tbm=isch&q=#{searchterm}&safe=active"
        useragent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7"

        begin
          Timeout::timeout(4) do
            images = open(searchurl, "User-Agent" => useragent)
          end
        rescue Timeout::Error
          return "Google is slow!  No images for you."
        end

        # pull image URLs out of the page
        images = images.read.scan(/var u='(.*?)'/).flatten

        # unescape google octal escapes
        images = images.map do |url|
          url.gsub(/\\(\d{2})/) do |escape|
            # given an octal escape like '\\75':
            #
            # 1. strip the leading slash
            # 2. convert to an integer
            # 3. convert to a hex string (url escaped)
            "%#{escape[1..-1].to_i(8).to_s(16)}"
          end
        end

        #funnyjunk sucks
        images.reject! {|x| x =~ /fjcdn\.com/}

        url = images.sample
        response.reply "No images found. Lame." if images.empty?
        response.reply url
      end

      Lita.register_handler(self)
    end
  end
end

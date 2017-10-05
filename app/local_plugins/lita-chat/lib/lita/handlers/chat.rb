module Lita
  module Handlers
    class Chat < Handler
      # insert handler code here
      route(/^(hi|hello)$/i, :hello, help: { 'hi' => "replies with Hello!" })
      route(/good morning/i, :good_morning)
      route(/wtf/i, :disapproval, help: { 'wtf' => "This is an office you know" })

      def disapproval(response)
        response.reply ":disapproval:"
      end

      def good_morning(response)
        response.reply "Good morning, #{response.user.mention_name}!"
      end

      def hello(response)
        response.reply "Hello, #{response.user.mention_name}!"
      end

      Lita.register_handler(self)
    end
  end
end

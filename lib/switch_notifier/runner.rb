# frozen_string_literal: true

require "slack-notifier"
require "switch_notifier/crawlers"

module SwitchNotifier
  class Runner
    attr_reader :slack_webhook_url, :slack_channel

    def initialize(slack_webhook_url, slack_channel)
      @slack_webhook_url = slack_webhook_url
      @slack_channel = slack_channel
      @exit_status = 0
    end

    def run
      SwitchNotifier::Crawlers.constants.each do |c|
        next if c == :Base
        check(c)
      end
      exit @exit_status
    end

    private

    def check(crawler_name)
      crawler = SwitchNotifier::Crawlers.const_get(crawler_name).new
      crawler.run
      notify(crawler) if crawler.in_stock?
    rescue => e
      $stderr.puts "#{e.class}, #{e.message}, #{e.backtrace.join("\n")}"
      @exit_status = 1
      notify_error(e)
    end

    def notifier
      @notifier ||=
        Slack::Notifier.new(
          slack_webhook_url,
          channel: slack_channel,
          username: "Switch在庫チェッカー",
          icon_emoji: ":rotating_light:"
        )
    end

    def notify(crawler)
      notifier.ping(
        "Switchの在庫が復活しました at #{crawler.to_s}"
      )
    end

    def notify_error(e)
      notifier.ping("#{e.class}, #{e.message}, #{e.backtrace}")
    end
  end
end

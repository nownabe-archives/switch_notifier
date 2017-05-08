# frozen_string_literal: true

require "switch_notifier/crawlers/base"

module SwitchNotifier
  module Crawlers
    class NintendoMyStore < Base
      def check
        elem = driver.find_element(css: "div.customize_price__priceInner p.stock")
        return true unless elem.text == "SOLD OUT"
        false
      end

      def to_s
        "Nintendo My Store"
      end

      private

      def url
        "https://store.nintendo.co.jp/customize.html"
      end
    end
  end
end

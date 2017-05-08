# frozen_string_literal: true

require "selenium/webdriver"

module SwitchNotifier
  module Crawlers
    class Base
      def initialize
        @in_stock = false
      end

      def in_stock?
        @in_stock
      end

      def run
        driver.navigate.to(url)
        @in_stock = check
      end

      def to_s
        self.class.to_s
      end

      private

      def check
        raise NotImplementedError, "You must implement #{__method__}"
      end

      def driver
        @driver ||= Selenium::WebDriver.for(:phantomjs)
      end

      def url
        raise NotImplementedError, "You must implement #{__method__}"
      end
    end
  end
end

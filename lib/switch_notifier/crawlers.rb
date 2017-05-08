# frozen_string_literal: true

Dir[File.expand_path("../crawlers/*.rb", __FILE__)].each { |f| require f }

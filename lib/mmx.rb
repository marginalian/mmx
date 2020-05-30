$LOAD_PATH.unshift __dir__

# stdlib
require 'date'
require 'erb'
require 'fileutils'
require 'forwardable'
require 'ostruct'
require 'yaml'

module Mmx
  SITE_PATH = "#{__dir__}/../../site".freeze
  TEMPLATES_PATH = "#{__dir__}/templates".freeze
  CORE_PATH = "#{__dir__}/../../index.html".freeze
  STYLESHEET = "#{__dir__}/../styles/main.css".freeze
  IMAGES_PATH = "#{__dir__}/../../images".freeze

  require 'mmx/mixins/composable'
  require 'mmx/mixins/renderable'

  require 'mmx/chapter'

  require 'mmx/fret'

  require 'mmx/leaf'
  require 'mmx/leaf/config_extractor'
  require 'mmx/leaf/emender'
  require 'mmx/leaf/html_builder'
  require 'mmx/leaf/index_page'
  require 'mmx/leaf/syntax_tree'

  require 'mmx/notecard'
  require 'mmx/notecards'

  require 'mmx/renderer'
  require 'mmx/renderer/helpers'
  require 'mmx/renderer/uber_binding'

  require 'mmx/site'

  require 'mmx/utils'

  require 'mmx/wiki'
  require 'mmx/wiki/stats'
end


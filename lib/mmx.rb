$LOAD_PATH.unshift __dir__

# stdlib
require 'date'
require 'erb'
require 'fileutils'
require 'forwardable'
require 'ostruct'
require 'yaml'

module Mmx
  require 'mmx/mixins/composable'
  require 'mmx/mixins/renderable'

  require 'mmx/chapter'

  require 'mmx/fret'

  require 'mmx/leaf'
  require 'mmx/leaf/all_pages_index'
  require 'mmx/leaf/config_extractor'
  require 'mmx/leaf/emender'
  require 'mmx/leaf/html_builder'
  require 'mmx/leaf/index_page'
  require 'mmx/leaf/syntax_tree'
  require 'mmx/leaf/syntax_tree/list'

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


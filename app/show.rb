require 'opal'
require 'browser/interval'      # gives us wrappers on javascript methods such as setTimer and setInterval
require 'browser/delay'
require 'jquery'
require 'opal-jquery'  # gives us a nice wrapper on jQuery which we will use mainly for HTTP calls
require "json"         # json conversions
require 'reactive-ruby'   # and the whole reason we are gathered here today!
require 'react-router'
require 'reactive-router'
require 'basics'
require 'reuse'
require 'items'
require 'rerendering'
require 'dbmon'
require 'magic_move_buddy_list'
require 'albums'

class Show

  include React::Router

  backtrace :on

  routes(path: "/") do
    route(path: "basics", name: "basics", handler: Basics)
    route(path: "dbmon", name: "dbmon", handler: DBMon)
    route(path: "albums", name: "albums", handler: Albums)
    route(path: "magic_move", name: "magic_move", handler: MagicMoveBuddyList)
    route(path: "reuse", name: "reuse", handler: Reuse)
    route(path: "rerendering", name: "rerendering", handler: Rerendering)
    redirect(from: "/", to: "albums")
  end

  def show
    puts "mounted the show method"
    div do
      div do
        # link(to: "basics") { "Basics" }; br
        link(to: "magic_move") { "Magic Move" }; br
        # link(to: "reuse") { "Reusable Components" }; br
        # link(to: "rerendering") { "Rerendering Test" }; br
        link(to: "dbmon") { "DBMon" }; br
        link(to: "albums") { "Albums" }; br
      end
    route_handler
    end
  end

end

Document.ready? do

  React.render(React.create_element(Show), Element['#content'])

end

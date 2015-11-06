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


class Database
  include React::Component

  params do
    requires :name, type: String
    requires :samples, type: Array
  end

  def render
    stuff = %w( one two three four)
    count_classname = if samples.size >= 20
                        'label-important'
                      elsif samples.size >= 10
                        'label-warning'
                      else
                        'label-success'
                      end
    tr( key: name) {
      td(class: 'dbname') { name }
      td(class: "query-count") {
        span(class: "label #{count_classname}") {
          samples.size.to_s
        }

      }

      samples[0..4].each { |sample|
        td { sprintf("%.2f", sample[:elapsed])}
      }
      if samples.size < 5
        (5 - samples.size).times {
          td { ''}
        }
      end
    }
  end
end

class DBMon

  include React::Component

  define_state( :dbs ) { Hash.new }

  ROWS = 10
  def get_data
    databases = {}
    0.upto(ROWS) { |i|
      databases["cluster#{i}"] = { queries: []}
      databases["cluster#{i}slave"] = { queries: []}
    }
    databases.each { |dbname, hash|
      r = rand(10) + 1
      0.upto(r) { |i|
        q = {
          elapsed: rand * 15,
          query: 'SELECT blah FROM something',
          waiting: rand < 0.5
        }
        q[:query] = '<IDLE> in transaction' if rand < 0.2
        q[:query] = 'vacuum' if rand < 0.1
        hash[:queries] << q
      }
      hash[:queries] = hash[:queries].sort { |a, b| b[:elapsed] <=> a[:elapsed] }
    }
    dbs! databases
    after(0.1) { get_data}
    databases
  end

  before_mount do
    get_data
  end

  def render
    div {
      table(class: 'table table-striped latest-data') {
        tbody {
          dbs.each { |name, hash|
            Database(name: name, samples: hash[:queries])
          }
        }
      }
    }

  end
end

=begin
Document.ready? do

  React.render(React.create_element(DBMon), Element['#content'])

end
=end

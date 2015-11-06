require 'magic_move_wrapper'

class MagicMoveBuddyList
  include React::Component
  define_state :buddies, type: Array
  before_mount do
    buddies! [ { name: 'Michelle', online: true },
               { name: 'Ethan', online: false },
               { name: 'David', online: true },
               { name: 'Shawn', online: false },
               { name: 'Sara', online: true }
             ]
  end

  after_mount do
    every(3) {
      buddies.each { |buddy|
        buddy[:online] = rand > 0.5
      }
      buddies! buddies
    }
  end

  def render_buddy(buddy)
    div(class: 'Buddy', key: buddy[:name]) {
      span(class: "status #{buddy[:online] ? 'online' : 'offline' }")
      buddy[:name]
    }
  end

  def render_online
    begin
      buddies.select { |buddy| buddy[:online] }.sort { |a, b| a[:name] <=> b[:name] }.each { |buddy|
        render_buddy buddy
      }
    rescue Exception => e
      p e
    end

  end
  def render_offline
    buddies.select { |buddy| !buddy[:online] }.sort { |a, b| a[:name] <=> b[:name] }.each { |buddy|
      render_buddy buddy
    }
  end
  def render
    div {
      MagicMoveWrapper.MagicMove {
        render_online
        hr(key: 'hr')
        render_offline
      }

    }

  end

end

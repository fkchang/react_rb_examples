require 'ostruct'
class Album
  include React:Component
  define_state :height, type: Integer, { 20 }

  def render

    bg = 'red'
    fg = 'blue'
    styles = {
      background: bg,
      color: fg,
      height: height,
      transition: 'all 500ms ease',
      overflow: 'hidden'
    }
    release = OpenStruct.new( title: 'A title',
                              tracklist: [ OpenStruct.new(title: 'Song 1', duration: '12:20'),
                                           OpenStruct.new(title: 'Song 2', duration: '3:33'),
                                         ]
                            )
    div(style: styles) {
      div(ref: :container, style: {padding: 20}) {
        h2(style: { margin: '0 0 10px 0'}) ~lease.tracklist.each_with_index { |track, index|
              li(key: index) { "#{track.title} #{track.duration}"}
            }
          }
        }
      }
    }
  end

end

class Release

  def initialize
    @hash = {}
  end

  def get(id)
    promise = Promise.new
    if @hash[id]
      puts "cached #{id} results"
      promise.resolve @hash[id]
    else
      puts "getting #[id} from web"
      HTTP.get "https://api.discogs.com/releases/#{id}" do |response|
        @hash[id] = response.json
        promise.resolve @hash[id]
      end

    end
    promise
  end
end

class Album
  include React::Component
  required_param :album_id, type: Integer
  define_state :info

  def self.release_lookup(id)
    @release ||= Release.new
    @release.get(id)
  end

  after_mount do
    # animate
  end

  def animate
    # height = `#{refs[:container]}.getDOMNode().offsetHeight`
    alert refs[:container]
  end

  def render
    Album.release_lookup(Albums.current_album).then { |json|
      info! json
    }

    styles = {
      transition: 'all 500ms ease',
      overflow: 'hidden'
    }
    div(style: styles) {
      div(ref: :container, style: {padding: 20}) {
        h2(style: {margin: '0 0 10 px 0'}) { info[:title]}
        div(style: {WebkitColumnCount: 2}) {
          ol(style: {margin: 0}) {
            info[:tracklist].each_with_index { |track, i|
              li(key: i) { "#{track[:title]} #{track[:duration]}"}
            }
          }
        }
      }
    }
  end
end

class Albums
  include React::Router
  # include React::Component
  IMAGE_SIZE = 100
  IMAGE_MARGIN = 10

  define_state :current_album
  export_state :current_album

  routes('/album') do
    route(path: ':album_id', name: 'album', handler: Album)
  end

  router_param :album_id do |album_id|
    album_id
  end

  define_state viewport_width: `window.innerWidth`
  define_state :last_child_id

  before_receive_props do |new_props|
    last_child_id! new_props[:params][:album_id]
    current_album! new_props[:params][:album_id]
  end

  def calc_albums_per_row
    full_width = IMAGE_SIZE + (IMAGE_MARGIN * 2)
    (viewport_width/full_width).floor
  end

  def bob_hash
    @bob_hash ||= Hash.new(`BOB`)
  end

  def calc_rows
    albums_per_row = calc_albums_per_row
    rows = []
    bob_hash.each_with_index { |pair, i|
      rows.push([]) if i % albums_per_row == 0
      rows[-1] << { id: pair[0], file: pair[1] }
    }
    rows
  end

  def render_album(album)
    album_styles = {
      display: 'inline-block',
      margin: IMAGE_MARGIN
    }
    div(style: album_styles) {
      link(to: "album", params: { album_id: album[:id]}) {
        img(style: {height: IMAGE_SIZE, width: IMAGE_SIZE}, src: album[:file])
      }
    }
  end

  def render_row(row, index)
    has_current = row.any? { |album| album[:id] == current_album }
    div(key: index) {
      row.each { |album|
        render_album(album)
      }
      route_handler if has_current
    }
  end

  def render
    div {
      calc_rows.each_with_index { |row, i|
        render_row(row, i)
      }
    }
  end
end

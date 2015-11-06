class Album
  include React::Component
  required_param :album_id, type: Integer

  def render
    h1 {"Album #{album_id}"}
  end
end

class AlbumRoute
  include React::Component
  def render
    AlbumRoute(album_id: Albums.current_album)
  end
end


class Albums
  include React::Router
  # include React::Component
  IMAGE_SIZE = 100
  IMAGE_MARGIN = 10

  define_state :current_album
  export_state :current_album

  routes('/') do
    route(path: 'album/:album_id', name: 'album', handler: Album)
  end

  router_param :album_id do |album_id|
    album_id
  end

  define_state viewport_width: `window.innerWidth`
  define_state :last_child_id

=begin
  before_receive_props do |new_props|
    # alert new_props
    # last_child_id!
  end
=end
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

    div(key: index) {
      row.each { |album|
        render_album(album)
      }
      route_handler
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

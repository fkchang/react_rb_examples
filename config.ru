# config.ru
require 'bundler'
Bundler.require

Opal::Processor.source_map_enabled = true

opal = Opal::Server.new {|s|
  s.append_path './app'
  s.main = 'example'
  s.debug = true
}
helpers do
  def create_bob_index
    bob = {}
    Dir['public/bob/*'].each { |filename|
      filename =~ /R-(\d+)-/
      bob[$1] = "#{filename.sub('public/', '')}"
    }
    bob.to_json
  end

end

map opal.source_maps.prefix do
  run opal.source_maps
end rescue nil

set :public_folder, File.dirname(__FILE__) + '/public'
map '/assets' do
  run opal.sprockets
end

get '/*' do
  example = "show"

  <<-HTML
    <!doctype html>
    <html>
      <head>
        <title>Example: #{example}.rb</title>
        <link href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet" type="text/css">
        <script src="/assets/#{example}.js"></script>
        <script>#{Opal::Processor.load_asset_code(opal.sprockets, example+".js")}</script>
        <style>
body {
  font-family: "Helvetica Neue", Arial;
  font-weight: 200;
}

.Buddy, h2, hr {
  margin: 0;
  transition: all 1250ms ease;
  box-sizing: border-box;
  font-size: 50px;
}

.system {
  margin: 0;
  transition: all 1250ms ease;
  box-sizing: border-box;
  font-size: 200%;
}

.status {
  display: inline-block;
  box-sizing: border-box;
  width: 30px;
  height: 30px;
  transition: all 1250ms ease;
  margin-right: 15px;
  margin-bottom: 4px;
  border-radius: 50%;
  background-color: hsl(100, 50%, 50%);
}

.offline {
  background-color: hsl(0, 50%, 50%);
}


        </style>
        <script>
          var BOB = #{create_bob_index}
        </script>
      </head>
      <body>
        <div id="content"></div>
      </body>
    </html>
  HTML
end

run Sinatra::Application

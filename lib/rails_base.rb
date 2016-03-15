# Gemをホスト側アプリに読み込ませる
Gem.loaded_specs['rails_base'].dependencies.each do |d|
  begin
    require d.name
  rescue LoadError
    raise
  end
end

require "rails_base/engine"

Dir.glob("#{RailsBase::Engine.root}/lib/rails_base/**/*.rb").each do |file|
  require file
end

ActiveSupport.on_load(:action_controller) do
  include RailsBase::Controllers::ControllerFilter
end

module RailsBase
end

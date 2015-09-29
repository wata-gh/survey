module ActionView
  module Helpers
    module AssetTagHelper
      def image_tag_resize src, opt = {}
        path = src.url.gsub Survey::Application.config.image_asset_host, ''
        opt[:src] = File.join Survey::Application.config.image_asset_host, "/resize/w/#{opt[:dw]}/h/#{opt[:dh]}/", path
        opt.delete :dw
        opt.delete :dh
        tag("img", opt)
      end
    end
  end
end

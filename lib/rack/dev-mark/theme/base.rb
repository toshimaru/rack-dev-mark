module Rack
  module DevMark
    module Theme
      class Base
        attr_reader :env, :revision

        def initialize(*args)
          raise RuntimeError, 'Abstract class can not be instantiated' if self.class == Rack::DevMark::Theme::Base
        end

        def setup(env, revision)
          @env = env
          @revision = revision
        end

        def insert_into(html)

        end

        private

        def stylesheet_link_tag(path)
          %Q~<style>#{::File.open(::File.join(::File.dirname(__FILE__), '../../../../vendor/assets/stylesheets', path)).read}</style>~
        end

        def gsub_tag_content(html, name, &block)
          String.new(html).gsub(%r{(<#{name}\s*[^>]*>)([^<]*)(</#{name}>)}i) do
            "#{$1}#{block.call($2)}#{$3}"
          end
        end

        def gsub_tag_attribute(html, name, attr, &block)
          String.new(html).gsub %r{(<#{name}\s*)([^>]*)(>)}i do
            s1, s2, s3 = $1, $2, $3
            s2.gsub! %r{(#{attr}=')([^']*)(')} do
              "#{$1}#{block.call($2)}#{$3}"
            end
            s2.gsub! %r{(#{attr}=")([^"]*)(")} do
              "#{$1}#{block.call($2)}#{$3}"
            end
            "#{s1}#{s2}#{s3}"
          end
        end
      end
    end
  end
end

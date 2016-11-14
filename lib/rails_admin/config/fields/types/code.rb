module RailsAdmin
  module Config
    module Fields
      module Types
        class Code < RailsAdmin::Config::Fields::Types::CodeMirror

          register_instance_option :pretty_value do
            code = JSON.pretty_generate(value) rescue value
            if bindings[:view].instance_variable_get(:@action).is_a?(RailsAdmin::Config::Actions::Index)
              code = code.lines[0, 4].join
              if code.length > 50
                code = "#{code.to(50)}..."
              end
            end
            "<pre><code class='#{mode_file}'>#{code}</code></pre>".html_safe
          end

          register_instance_option :js_location do
            bindings[:view].asset_path('codemirror.js')
          end

          register_instance_option :css_location do
            bindings[:view].asset_path('codemirror.css')
          end

          register_instance_option :assets do
            {
              mode: bindings[:view].asset_path("codemirror/modes/#{mode_file}.js"),
              theme: bindings[:view].asset_path("codemirror/themes/#{config[:theme]}.css")
            }
          end

          register_instance_option :config do
            default_config.merge(code_config)
          end

          register_instance_option :default_config do
            {
              lineNumbers: true,
              theme: (theme = User.current.code_theme).present? ? theme : (Cenit.default_code_theme || 'monokai')
            }
          end

          register_instance_option :code_config do
            {
            }
          end

          register_instance_option :mode_file do
            {
              'application/json': 'javascript',
              'application/ld+json': 'javascript',
              'application/x-ejs': 'htmlembedded',
              'application/x-erb': 'htmlembedded',
              'application/xml': 'xml',

              'text/apl': 'apl',
              'text/html': 'xml',
              'text/plain': 'javascript',
              'text/x-ruby': 'ruby',
              'text/x-yaml': 'yaml',
              '': 'javascript'
            }[config[:mode].to_s.to_sym] || config[:mode].to_sym
          end
        end
      end
    end
  end
end

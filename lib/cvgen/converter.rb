require 'kramdown'
require 'prawn'

module CVGen

  class Converter < Kramdown::Converter::Pdf

    HEADER_SIZES = [nil, 24, 16, 16, 12, 12, 12]
    HEADER_TOP_PADDING = [nil, 0, 10, 10, 0, 0, 0]
    HEADER_BOTTOM_PADDING = [nil, 4, 4, 6, 0, 0, 0]

    def initialize(root, options)
      @current_padding = 0
      super
    end

    def root_options(root, opts)
      super.update(:font => "Helvetica", :leading => 1, :kerning => true, :header_font => @options[:'header-font'])
    end

    def header_options(el, opts)
      h = super
      h[:font] = opts[:header_font] if opts[:header_font]
      h.update({
        :size => HEADER_SIZES[el.options[:level]],
        :styles => [],
        :bottom_padding => HEADER_BOTTOM_PADDING[el.options[:level]],
        :top_padding => HEADER_TOP_PADDING[el.options[:level]]})
    end

    def render_header(el, opts)
      if el.options['date']
        @pdf.float do
          with_block_padding(el, opts, true) do
            @pdf.formatted_text [opts.merge(:text =>el.options['date'])], :align => :right
          end
        end
      end
      super
      if el.options[:level] == 2
        @pdf.stroke_horizontal_rule
        @pdf.move_down 12
        @current_padding += 12
      end
    end

    def ul_options(el, opts)
      {}
    end

    def render_ul(el, opts)
      @pdf.indent(15) { super }
    end

    def dt_options(el, opts)
      super.update(:styles => [:italic])
    end

    def p_options(el, opts)
      {:bottom_padding => 0}
    end

    def document_options(root)
      h = super.update(:margin => 72)
      h[:info][:Creator] = 'cvgen (using kramdown PDF converter)'
      h[:info].update(@options[:'document-info']) if @options[:'document-info']
      h
    end

    def with_block_padding(el, opts, floated = false)
      
      if opts.has_key?(:top_padding)
        top = opts[:top_padding]
        if top > @current_padding
          @pdf.move_down(top - @current_padding)
        end
      end
      @current_padding = 0 unless floated
      yield
      if opts.has_key?(:bottom_padding)
        @pdf.move_down(opts[:bottom_padding])
        @current_padding = opts[:bottom_padding] unless floated
      end
    end

  end
end

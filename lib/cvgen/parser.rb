require 'kramdown'

module CVGen
  
  class Parser < Kramdown::Parser::Kramdown

    HEADER_DETAILS = /(\S.*)\n(?:(\S.*)\n)?/

    def parse_atx_header
      rval = super

      if rval && @src.check(HEADER_DETAILS)
        date, title = @src[1], @src[2]
        @tree.children.last.options['date'] = date

        if title
          @tree.children.last.children << Element.new(:br, nil, nil, :location => @src.current_line_number)
          add_text(title, @tree.children.last)
        end
        @src.pos += @src.matched_size
      end

      rval
    end

    def handle_extension name, *args
      return super unless name == 'pgbr'
      @tree.children << Element.new(:pgbr, nil, nil, :location => @src.current_line_number)
      true
    end

  end

end

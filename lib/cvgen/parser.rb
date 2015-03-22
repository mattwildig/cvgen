require 'kramdown'

module CVGen
  
  class Parser < Kramdown::Parser::Kramdown
    Kramdown::Parser::Kramdown.send :remove_const, :ATX_HEADER_MATCH
    Kramdown::Parser::Kramdown::ATX_HEADER_MATCH = /^(\#{1,6})(.+?(?:\\#)?)\s*?#*#{HEADER_ID}\s*?\n(?:(?:(\S.*)\s*?\n)(?:(\S.*)[ \t]*\n)?)?/

    def parse_atx_header
      rval = super

      if rval
        @tree.children.last.options['date'] = @src[4]
        if @src[5]
          @tree.children.last.children << Element.new(:br, nil, nil, :location => @src.current_line_number)
          add_text(@src[5], @tree.children.last) 
        end
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

require 'kramdown'

module CVGen
  
  class Parser < Kramdown::Parser::Kramdown
    Kramdown::Parser::Kramdown.send :remove_const, :ATX_HEADER_MATCH
    Kramdown::Parser::Kramdown::ATX_HEADER_MATCH = /^(\#{1,6})(.+?(?:\\#)?)\s*?#*#{HEADER_ID}\s*?\n(?:(?:(\S.*)\s*?\n)(?:(\S.*)[ \t]*\n)?)?/

    # def parse_atx_header
    #   return false if !after_block_boundary?

    #   start_line_number = @src.current_line_number
    #   @src.check(ATX_HEADER_MATCH)
    #   level, text, id = @src[1], @src[2].to_s.strip, @src[3]
    #   return false if text.empty?

    #   @src.pos += @src.matched_size
    #   el = new_block_el(:header, nil, nil, :level => level.length, :raw_text => text, :location => start_line_number)
    #   add_text(text, el)
    #   el.attr['id'] = id if id
    #   @tree.children << el
    #   true
    # end

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
  end

end
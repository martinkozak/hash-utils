# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

##
# Array extension.
#

class Array

    ##
    # Moves selected values outside the array, so returns them.
    #
    # Works similar to +Hash#reject!+, but returns removed items instead 
    # of remaining items.
    #
    # @param [Proc] block selecting block
    # @return [Array] removed values
    # @since 0.3.0
    #
    
    def remove!(&block)
        result = [ ]
        self.reject! do |v|
            if block.call(v)
                result << v
                true
            else
                false
            end
        end
        
        return result
    end

    ##
    # Checks, all values follow condition expressed in block.
    # Block must return Boolean.
    #
    # If it's empty, returns +true+.
    #
    # @param [Proc] block checking block
    # @return [Boolean] 'true' if yes, 'false' in otherwise
    # @since 0.2.0
    #
    
    def all?(&block)
        if self.empty?
            return true
        end
        
        self.each do |v|
            if block.call(v) == false
                return false
            end
        end
        
        return true
    end

    ##
    # Checks, at least one value follows condition expressed in 
    # block. Block must return Boolean.
    #
    # @param [Proc] block checking block
    # @return [Boolean] 'true' if yes, 'false' in otherwise
    # @since 0.2.0
    #
    
    def some?(&block)
        self.each do |v|
            if block.call(v) == true
                return true
            end
        end
        
        return false
    end
    
    ##
    # Converts array to hash.
    #
    # Works as alias for +Hash#[]+ method. If you specify the +:flat+ 
    # mode, array items will be treaten as arguments to +Hash#[]+ 
    # method.
    #
    # Should be noted, it cannot be named +#to_hash+, because #to_hash 
    # is called by the +Hash#[]+ itself. Reasons why it's absolutely 
    # undocumented call are unknown.
	#
    # @example Equivalent calls
    #   [["aa", "bb"], ["bb", "aa"]].to_h
    #   ["aa", "bb", "bb", "aa"].to_h(:flat)
    #
    # @param [Symbol] mode flat mode switch, can be +:flat+ or +nil+
    # @return Hash new hash
    # @see http://www.ruby-doc.org/core/classes/Hash.html#M000716
    # @since 0.4.0
    #
    
    def to_h(mode = nil)
		if mode == :flat
			Hash[*self]
		else
			Hash[self]
		end
    end
    
end

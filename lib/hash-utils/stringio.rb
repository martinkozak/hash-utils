# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

##
# StringIO extension.
#

class StringIO < Data

    ##
    # Indicates, object is IO, so +IO+ or +StringIO+ class.
    #
    # @return [Boolean] +true+ if yes, +false+ in otherwise
    # @since 0.14.0
    #
    
    def io?
        true
    end
    
end

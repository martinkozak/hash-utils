# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

class Symbol
    ##
    # Indicates symbol is in some object which supports #include?.
    #
    
    def in?(range)
        range.include? self
    end
end

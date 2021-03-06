# encoding: utf-8
# (c) 2011-2012 Martin Kozák (martinkozak@martinkozak.net)

require "hash-utils/object"

##
# Numeric extension.
# @since 0.16.0
#

class Numeric

    ##
    # Compares numbers. Returns 1 if this is higher, 0 if they are the 
    # same and -1 if it's lower.
    #
    # @param [Numeric] number number for comparsion
    # @return [Integer] comparsion result, see above
    # @deprecated (since 0.19.0) Use the +#<=>+ operator instead.
    # @since 0.16.0
    #
    
    if not self.__hash_utils_instance_respond_to? :compare
        def compare(number)
            self <=> number
        end
    end
    
    ##
    # Indicates, number is positive, so higher than 0.
    #
    # @return [Boolean] +true+ it it is
    # @since 0.16.0
    #
    
    if not self.__hash_utils_instance_respond_to? :positive?
        def positive?
            self > 0
        end
    end
    
    if not self.__hash_utils_instance_respond_to? :positive 
        alias :positive :positive?
    end
    
    ##
    # Indicates, number is negative, so lower than 0.
    #
    # @return [Boolean] +true+ it it is
    # @since 0.16.0
    #
    
    if not self.__hash_utils_instance_respond_to? :negative?
        def negative?
            self < 0
        end
    end
    
    if not self.__hash_utils_instance_respond_to? :negative
        alias :negative :negative?
    end
    
    ##
    # Sets the positivity to +false+, so negates the number. +0+ will 
    # be kept.
    #
    # @example
    #   1.negative!   # will return -1
    #
    # @return [Numeric] negative number
    # @since 0.16.0
    #
    
    if not self.__hash_utils_instance_respond_to? :negative!
        def negative!
            -self.positive!
        end
    end
    
    if not self.__hash_utils_instance_respond_to? :negate!
        alias :negate! :negative!
    end
    
    ##
    # Sets the positivity to +true+, so makes number positive. +0+ will 
    # be kept.
    #
    # @example
    #   -1.positive!   # will return 1
    #
    # @return [Numeric] positive number
    # @since 0.16.0
    #
    
    alias :"positive!" :abs    
    
    ##
    # Indicates, object is +Numeric+.
    #
    # @return [Boolean] +true+ if yes, +false+ in otherwise
    # @since 0.17.0
    #
    
    def number?
        true
    end

    
end

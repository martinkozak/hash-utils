# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)


##
# Hash extension.
#

class Hash

    ##
    # Defines hash by setting the default value or an +Proc+ 
    # and content.
    #
    # @param [Hash] values  initial values
    # @param [Object] default  default value
    # @param [Proc] block  default block
    # @return [Hash] new hash
    # @since 0.3.0
    #
    
    def self.define(values = { }, default = nil, &block) 
        hash = self[values]
        self::create(default, hash, &block)
    end
    
    ##
    # Creates hash by setting default settings in one call.
    #
    # @param [Hash] values  initial values
    # @param [Object] default  default value
    # @param [Proc] block  default block
    # @return [Hash] new hash
    # @since 0.3.0
    #
    
    def self.create(default = nil, hash = { }, &block)
        hash.default = default
        
        if not block.nil?
            hash.default_proc = block
        end
        
        return hash        
    end

    ##
    # Recreates the hash, so creates empty one and assigns
    # the same default values.
    #
    # @return [Hash] new hash
    # @since 0.3.0
    #
    
    def recreate
        self.class::create(self.default, &self.default_proc)
    end
    
    ##
    # Recreates the hash in place, so creates empty one, assigns
    # the same default values and replaces the old one.
    #
    # @return [Hash] new hash
    # @since 0.3.0
    #
    
    def recreate!
        self.replace(self.recreate)
    end

    ##
    # Moves selected pairs outside the hash, so returns them.
    # Output hash has the same default settings.
    #
    # @param [Proc] block selecting block
    # @return [Hash] removed selected pairs
    # @since 0.3.0
    #
    
    def remove!(&block)
        result = self.recreate
        delete = [ ]
        
        self.each_pair do |k, v|
            if block.call(k, v)
                result[k] = v
                delete << k
            end
        end
        
        delete.each do |k|
            self.delete(k)
        end
        
        return result
    end

    ##
    # Returns a copy of +self+ with all +nil+ elements removed.
    #
    # @return [Hash] new hash
    # @since 0.1.0
    #

    def compact
        self.reject { |k, v| v.nil? }
    end
    
    ##
    # Removes +nil+ elements from the hash. Returns +nil+ 
    # if no changes were made, otherwise returns +self+.
    #
    # @return [Hash] new hash
    # @since 0.1.0
    #
    
    def compact!
        self.reject! { |k, v| v.nil? }
    end
    
    ##
    # Returns a new hash with the results of running block once for 
    # every pair in +self+.
    #
    # @param [Proc] block evaluating block
    # @return [Hash] new hash
    # @since 0.1.0
    # 
    
    def map_pairs(&block)
        new = self.recreate
        
        self.each_pair do |k, v|
            new_k, new_v = block.call(k, v)
            new[new_k] = new_v
        end
        
        return new
    end
    
    alias :collect_pairs :map_pairs
    
    ##
    # Emulates {#map_pairs} on place. In fact, replaces old hash by 
    # new one.
    #
    # @param [Proc] block evaluating block
    # @return [Hash] new hash
    # @since 0.1.0
    #
    
    def map_pairs!(&block)
        self.replace(self.map_pairs(&block))
    end
    
    alias :collect_pairs! :map_pairs!
    
    ##
    # Returns a new hash with the results of running block once for 
    # every key in +self+.
    #
    # @param [Proc] block evaluating block
    # @return [Hash] new hash
    # @since 0.1.0
    #
    
    def map_keys(&block)
        self.map_pairs do |k, v|
            [block.call(k), v]
        end
    end
    
    alias :collect_keys :map_keys
    
    ##
    # Emulates {#map_keys} on place. In fact, replaces old hash by 
    # new one.
    #
    # @param [Proc] block evaluating block
    # @return [Hash] new hash
    # @since 0.1.0
    #
    
    def map_keys!(&block)
        self.replace(self.map_keys(&block))
    end
    
    alias :collect_keys! :map_keys!
    
    ##
    # Converts all keys to symbols.
    #
    # @return [Hash] new hash
    # @since 0.1.0
    #
    
    def keys_to_sym
        self.map_keys { |k| k.to_sym }
    end
    
    ##
    # Emulates {#keys_to_sym} on place. In fact, replaces old hash by 
    # new one.
    #
    # @return [Hash] new hash
    # @since 0.1.0
    #
    
    def keys_to_sym!
        self.replace(self.keys_to_sym)
    end
    
    ##
    # Checks, all elements values follow condition expressed in block.
    # Block must return boolean.
    #
    # If it's empty, returns +true+.
    #
    # @param [Proc] block checking block
    # @return [Boolean] +true+ if yes, +false+ in otherwise 
    # @since 0.2.0
    #
    
    def all?(&block)
        if self.empty?
            return true
        end
        
        self.each_value do |v|
            if block.call(v) == false
                return false
            end
        end
        
        return true
    end
        
    ##
    # Checks, all elements follow condition expressed in block.
    # Block must return boolean.
    #
    # If it's empty, returns +true+.
    #
    # @param [Proc] block checking block
    # @return [Boolean] +true+ if yes, +false+ in otherwise 
    # @since 0.2.0
    #
    
    def all_pairs?(&block)
        if self.empty?
            return true
        end
        
        self.each_pair do |k, v|
            if block.call(k, v) == false
                return false
            end
        end
        
        return true
    end
    
    ##
    # Checks, at least one element value follows condition expressed in 
    # block. Block must return boolean.
    #
    # @param [Proc] block checking block
    # @return [Boolean] +true+ if yes, +false+ in otherwise 
    # @since 0.2.0
    #
    
    def some?(&block)
        self.each_value do |v|
            if block.call(v) == true
                return true
            end
        end
        
        return false
    end

    ##
    # Checks, at least one element follows condition expressed in 
    # block. Block must return boolean.
    #
    # @param [Proc] block checking block
    # @return [Boolean] +true+ if yes, +false+ in otherwise 
    # @since 0.2.0
    #
        
    def some_pairs?(&block)
        self.each_pair do |k, v|
            if block.call(k, v) == true
                return true
            end
        end
        
        return false
    end
    
    ##
    # Compatibility method with {Array#to_h}. Returns itself.
    #
    # @return [Hash] itself
    # @since 0.4.0
    #
    
    def to_h(mode = nil)
        self
    end
    
    ##
    # Simulates sorting in place. In fact, replaces old one by new one.
    #
    # @param [Proc] block comparing block (see similar for #sort method)
    # @return [Hash] new sorted hash
    # @since 0.5.0
    #
    
    def sort!(&block)
        self.replace(Hash[self.sort(&block)])
    end
    
    ##
    # Sorts hash according to keys. It's equivalent of PHP ksort().
    #
    # Be warn, this method have sense in Ruby 1.9 only. Ruby 1.8 doesn't
    # maintain pair order in Hashes.
    #
    # @param [Proc] block comparing block (see similar for #sort method)
    # @return [Hash] new sorted hash
    # @see http://www.igvita.com/2009/02/04/ruby-19-internals-ordered-hash/
    # @see http://www.php.net/ksort
    # @since 0.5.0
    #
    
    def ksort(&block)
        if block.nil?
           block =  Proc::new { |a, b| a <=> b }
        end
        Hash[self.sort { |a, b| block.call(a[0], b[0]) }]
    end
    
    ##
    # Sorts hash according to keys, replaces the original one.
    # 
    # @param [Proc] block comparing block (see similar for #sort method)
    # @return [Hash] new sorted hash
    # @see #ksort
    # @since 0.5.0
    #

    def ksort!(&block)
        self.replace(self.ksort(&block))
    end
    
    ##
    # Sorts hash according to values. Keeps key associations.
    # It's equivalent of PHP asort().
    #
    # Be warn, this method have sense in Ruby 1.9 only. Ruby 1.8 doesn't
    # maintain pair order in Hashes. 
    #
    # @param [Proc] block comparing block (see similar for #sort method)
    # @return [Hash] new sorted hash
    # @see http://www.igvita.com/2009/02/04/ruby-19-internals-ordered-hash/
    # @see http://www.php.net/asort
    # @since 0.5.0
    #
    
    def asort(&block)
        if block.nil?
           block =  Proc::new { |a, b| a <=> b }
        end
        Hash[self.sort { |a, b| block.call(a[1], b[1]) }]
    end
    
    ##
    # Sorts hash according to values, replaces the original one.
    # 
    # @param [Proc] block comparing block (see similar for #sort method)
    # @return [Hash] reversed hash
    # @see #asort
    # @since 0.5.0
    #
    
    def asort!(&block)
        self.replace(self.asort(&block))
    end
    
    ##
    # Reverses order of the hash pairs.
    #
    # Be warn, this method have sense in Ruby 1.9 only. Ruby 1.8 doesn't
    # maintain pair order in Hashes.
    #
    # @return [Hash] reversed hash
    # @since 0.5.0
    #
    
    def reverse
        Hash[self.to_a.reverse]
    end
    
    ##
    # Reverses order of the hash pairs, replaces the original one.
    #
    # @return [Hash] reversed hash
    # @since 0.5.0
    #
    
    def reverse!
        self.replace(self.reverse)
    end
    
    ##
    # Indicates, some keys are available in Hash.
    #
    # @param [Array] keys objects for checking
    # @return [Boolean] +true+ if yes, +false+ in otherwise
    # @since 0.8.1
    #
    
    def has_keys?(keys)
        keys.each do |key|
            if not self.has_key? key
                return false
            end
        end
        
        return true
    end
    
end

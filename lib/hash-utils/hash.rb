# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

class Hash

    ##
    # Defines hash by setting the default value or Proc and content.
    #
    
    def self.define(values = { }, default = nil, &block) 
        hash = self[values]
        self::create(default, hash, &block)
    end
    
    ##
    # Creates hash by setting default settings in one call.
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
    
    def recreate
        self.class::create(self.default, &self.default_proc)
    end
    
    ##
    # Recreates the hash in place, so creates empty one, assigns
    # the same default values and replaces the old one.
    #
    
    def recreate!
        self.replace(self.recreate)
    end

    ##
    # Moves selected pairs outside the hash, so returns them.
    # Output hash has the same default settings.
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
    # Returns a copy of <tt>self</tt> with all <tt>nil</tt> 
    # elements removed.
    #

    def compact
        self.reject { |k, v| v.nil? }
    end
    
    ##
    # Removes <tt>nil</tt> elements from the hash. Returns <tt>nil</tt> 
    # if no changes were made, otherwise returns <tt>self</self>.
    #
    
    def compact!
        self.reject! { |k, v| v.nil? }
    end
    
    ##
    # Returns a new hash with the results of running block once for 
    # every pair in <tt>self</tt>.
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
    # Emulates #map_pairs on place. In fact, replaces old hash by 
    # new one.
    #
    
    def map_pairs!(&block)
        self.replace(self.map_pairs(&block))
    end
    
    alias :"collect_pairs!" :"map_pairs!"
    
    ##
    # Returns a new hash with the results of running block once for 
    # every key in <tt>self</tt>.
    #
    
    def map_keys(&block)
        self.map_pairs do |k, v|
            [block.call(k), v]
        end
    end
    
    alias :collect_keys :map_keys
    
    ##
    # Emulates #map_keys on place. In fact, replaces old hash by 
    # new one.
    #
    
    def map_keys!(&block)
        self.replace(self.map_keys(&block))
    end
    
    alias :"collect_keys!" :"map_keys!"
    
    ##
    # Converts all keys to symbols.
    #
    
    def keys_to_sym
        self.map_keys { |k| k.to_sym }
    end
    
    ##
    # Emulates #keys_to_sym on place. In fact, replaces old hash by 
    # new one.
    #
    
    def keys_to_sym!
        self.replace(self.keys_to_sym)
    end
    
    ##
    # Checks, all elements values follow condition expressed in block.
    # Block must return Boolean.
    #
    # If it's empty, returns <tt>true</tt>.
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
    # Block must return Boolean.
    #
    # If it's empty, returns <tt>true</tt>.
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
    # block. Block must return Boolean.
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
    # block. Block must return Boolean.
    #
        
    def some_pairs?(&block)
        self.each_pair do |k, v|
            if block.call(k, v) == true
                return true
            end
        end
        
        return false
    end
end
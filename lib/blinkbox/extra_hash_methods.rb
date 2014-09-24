module Blinkbox
  module ExtraHashMethods
    # Turns a deep/nested hash into a shallow one by concatenating nested key names.
    #
    # @example: Removing nesting
    #   hash = {
    #     "a" => {
    #       "1" => 'will be a.1'
    #     },
    #     "b" => 'will be b'
    #   }
    #   hash.extend(ExtraHashMethods).shallow!
    #   # => true
    #   p hash
    #   # => { "a.1" => 'will be a.1', "b" => 'will be b' }
    #
    # @example: Removing nesting - custom join string
    #   hash = {
    #     "a" => {
    #       "1" => 'will be merged down'
    #     },
    #     "b" => 'will be the same'
    #   }
    #   hash.extend(ExtraHashMethods).shallow!("~")
    #   # => true
    #   p hash
    #   # => { "a~1" => 'will be merged down', "b" => 'will be the same' }
    #
    # @example: No removal needed
    #   hash = {
    #     "a" => 'no deep keys here'
    #   }
    #   hash.extend(ExtraHashMethods).shallow!
    #   # => false
    #   p hash
    #   # => { "a" => 'no deep keys here' }
    #
    # @example: Conflicting key names
    #   hash = {
    #     "a" => {
    #       "1" => 'will be a.1'
    #     },
    #     "a.1" => 'will be lost!'
    #   }
    #   hash.extend(ExtraHashMethods).shallow!
    #   # => ["a.1"]
    #   p hash
    #   # => { "a.1" => 'will be a.1' }
    #
    # @param [String] join The string to use to join keys.
    # @return [Boolean] Whether any keys were changed
    def shallow!(join = ".")
      shallowed = false
      self.keys.each do |k|
        if self[k].is_a?(Hash)
          shallowed = shallowed || true
          v = self.delete(k)
          v.each do |sub_k, sub_v|
            new_key = [k, sub_k].join(join)
            if self.has_key?(new_key)
              shallowed = [] unless shallowed.is_a?(Array)
              shallowed.push(new_key)
            end
            self[new_key] = if sub_v.is_a?(Hash)
              sub_v.extend(ExtraHashMethods)
              sub_v.shallow!(join)
            else
              sub_v
            end
          end
        end
      end
      shallowed
    end
  end
end
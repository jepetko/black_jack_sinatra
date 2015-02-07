module ObjectToHashSerializationSupport

  private
  def is_primitive(val)
    val.is_a?(String) || val.is_a?(Fixnum) || val == true || val == false
  end

  def as_hash
    if is_a?(Array)
      hash = []
      each_with_index do |element,idx|
        hash[idx] = element.as_hash
      end
      return hash
    else
      if respond_to?(:instance_variables)
        hash = {}
        instance_variables.each do |var|
          key = var.to_s.delete('@').to_sym
          val = instance_variable_get var
          if is_primitive(val)
            hash[key] = val
          else
            hash[key] = val.as_hash
          end
        end
        return hash
      end
    end
    nil
  end
end

class BasicObject
  def method_missing(method_name,*args)
    if method_name == :as_hash
      class << self
        include ObjectToHashSerializationSupport
      end
      send(:as_hash, *args)
    end
  end
end


module HABMC

  class Model

    def initialize(json)
      json.each do |key, value|
        instance_variable_set("@#{key}", value)

        self.define_singleton_method(key) do
          instance_variable_get("@#{key}")
        end
      end
    end

  end

end

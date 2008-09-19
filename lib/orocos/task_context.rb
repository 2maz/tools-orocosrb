module Orocos
    class Port
        attr_reader :name

        def pretty_print(pp)
            pp.text "#{self.class.name} #{name}"

            if read? then pp.text "[R]"
            elsif write? then pp.text "[W]"
            else pp.text "[RW]"
            end
        end
    end

    class TaskContext
        # The name of this task context
        attr_reader :name

        def pretty_print(pp)
            states_description = TaskContext.constants.grep(/^STATE_/).
                inject([]) do |map, name|
                    map[TaskContext.const_get(name)] = name.gsub /^STATE_/, ''
                    map
                end

            pp.text "Component #{name}"
            pp.text "  state: #{states_description[state]}"

            ports = Hash.new
            each_port do |port|
                port.pretty_print(pp)
            end
        end
    end
end


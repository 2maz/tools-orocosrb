module Orocos
    module Test
        # Support for using ruby tasks in tests
        module RubyTasks
            def helpers_dir
                File.join(__dir__, 'helpers')
            end

            def setup
                @allocated_task_contexts = Array.new
                @started_external_ruby_task_contexts = Array.new
                super
            end

            def teardown
                super
                @allocated_task_contexts.each(&:dispose)
                @started_external_ruby_task_contexts.each do |pid|
                    begin Process.kill 'INT', pid
                    rescue Errno::ESRCH
                    end
                    _, status = Process.waitpid2 pid
                    if !status.success?
                        raise "subprocess #{pid} failed with #{status.inspect}"
                    end
                end
            end

            def register_allocated_ruby_tasks(*tasks)
                @allocated_task_contexts.concat(tasks)
            end

            def new_ruby_task_context(name, options = Hash.new, &block)
                task = Orocos::RubyTasks::TaskContext.new(name, options, &block)
                @allocated_task_contexts << task
                task
            end
            
            def new_external_ruby_task_context(
                name, typekits: ['std'], input_ports: [], output_ports: [], timeout: 2)

                typekits = typekits.map do |typekit_name|
                    "--typekit=#{typekit_name}"
                end
                output_ports = output_ports.map do |name, type|
                    "--output-port=#{name}::#{type}"
                end
                input_ports = input_ports.map do |name, type|
                    "--input-port=#{name}::#{type}"
                end
                pid = spawn(Gem.ruby, File.join(helpers_dir, 'ruby_task_spawner'),
                            name, *typekits, *input_ports, *output_ports)

                start_time = Time.now
                while (Time.now - start_time) < timeout
                    begin
                        return Orocos.get(name), pid
                    rescue Orocos::NotFound
                    end
                end
                flunk "failed to create ruby task context #{name}"
            end
        end
    end
end


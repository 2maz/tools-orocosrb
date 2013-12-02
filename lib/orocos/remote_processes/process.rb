module Orocos
    module RemoteProcesses
    # Representation of a remote process started with ProcessClient#start
    class Process < ProcessBase
        # The ProcessClient instance that gives us access to the remote process
        # server
        attr_reader :process_client
        # A string describing the host. It can be used to check if two processes
        # are running on the same host
        def host_id; process_client.host_id end
        # True if this process is located on the same machine than the ruby
        # interpreter
        def on_localhost?; process_client.host == 'localhost' end
        # The process ID of this process on the machine of the process server
        attr_reader :pid

        def initialize(name, deployment_name, process_client, pid)
            @process_client = process_client
            @pid = pid
            @alive = true
            model = process_client.load_orogen_deployment(deployment_name)
            super(name, model)
        end

        # Called to announce that this process has quit
        def dead!
            @alive = false
        end

        # Returns the task context object for the process' task that has this
        # name
        def task(task_name)
            process_client.name_service.get(task_name)
        end

        # Stops the process
        def kill(wait = true)
            raise ArgumentError, "cannot call RemoteProcess#kill(true)" if wait
            process_client.stop(name)
        end

        # Wait for the 
        def join
            raise NotImplementedError, "RemoteProcess#join is not implemented"
        end

        # True if the process is running. This is an alias for running?
        def alive?; @alive end
        # True if the process is running. This is an alias for alive?
        def running?; @alive end

        # Waits for the deployment to be ready. +timeout+ is the number of
        # milliseconds we should wait. If it is nil, will wait indefinitely
	def wait_running(timeout = nil)
            Orocos::Process.wait_running(self, timeout)
	end
    end
    end
end


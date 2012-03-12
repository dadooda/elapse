module Elapse
  # An instance of the system.
  class Instance
    # Stacked stopwatches.
    attr_accessor :stack

    # Named stopwatches.
    attr_accessor :stopwatches

    def initialize(attrs = {})
      clear
      attrs.each {|k, v| send("#{k}=", v)}
    end

    # Clear everything.
    def clear
      @stack = []
      @stopwatches = {}
      self    # By convention.
    end

    # Return sum of all measurements made by the stopwatch.
    #
    # See Elapse::cumulative.
    def cumulative(sw_key)
      sw = find_stopwatch(sw_key)

      begin
        sw.cumulative
      rescue RuntimeError => e
        # Append stopwatch name.
        raise "#{e.message}: #{sw_key.inspect}"
      end
    end

    # Reset the named stopwatch.
    #
    # See Elapse::reset.
    def reset(sw_key)
      # Let's be strict.
      find_stopwatch(sw_key).reset
    end

    # Start the stopwatch. Return Time::now.
    #
    # See Elapse::start.
    def start(sw_key = nil)
      sw = if sw_key
        # Named mode.
        @stopwatches[sw_key] ||= Stopwatch.new
      else
        # Stacked mode.
        Stopwatch.new
      end

      begin
        out = sw.start
      rescue RuntimeError => e
        # Append stopwatch name.
        raise "#{e.message}: #{sw_key.inspect}"
      end

      if not sw_key
        # Stacked mode.
        @stack.push(sw)
      end

      out
    end

    # Stop the stopwatch. Return Time::now.
    #
    # See Elapse::stop.
    def stop(sw_key = nil)
      fetch_stopwatch(sw_key).stop
    end

    # Return time of the last stopwatch measurement. If the stopwatch is running, stop it.
    #
    # See Elapse::took.
    def took(sw_key = nil, &block)
      if block
        start(sw_key)
        yield
        return took(sw_key)
      end

      fetch_stopwatch(sw_key).took
    end

    private

    # Find or pop stopwatch for the given <tt>sw_key</tt>.
    def fetch_stopwatch(sw_key)
      if sw_key
        # Named mode.
        find_stopwatch(sw_key)
      else
        # Stacked mode.
        @stack.pop or raise "Stopwatch stack underflow (you called `stop` more times than `start`)"
      end
    end

    def find_stopwatch(sw_key)
      # NOTES:
      #
      # * Message looks okay.
      # * Error is actually more `RuntimeError` than `ArgumentError`.
      @stopwatches[sw_key] or raise "Stopwatch not found: #{sw_key.inspect}"
    end
  end
end

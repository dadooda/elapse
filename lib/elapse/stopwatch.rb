module Elapse
  # Our stopwatch class.
  class Stopwatch
    attr_reader :started_at

    def initialize
      clear
    end

    # Clear object.
    def clear
      @cumulative = nil
      @started_at = nil
      @took = nil
      self    # By convention.
    end

    # Stop the stopwatch and return cumulative time.
    def cumulative
      stop
      @cumulative
    end

    # Reset stopwatch.
    def reset
      clear
      nil
    end

    # Return true if the stopwatch is running.
    def running?
      !!@started_at
    end

    # Start the stopwatch. Return Time::now.
    def start
      raise "Stopwatch already started" if @started_at
      @started_at = Time.now
    end

    # Stop the stopwatch. Return Time::now.
    def stop
      now = Time.now

      # We can stop multiple times. We cannot stop if never started.
      if @started_at
        @cumulative ||= 0.0
        @took = now - @started_at
        @cumulative += @took
        @started_at = nil
      elsif not @cumulative
        raise "Stopwatch was never started"
      end

      now
    end

    # Stop the stopwatch and return the last measurement.
    #
    #   start
    #   sleep 0.1
    #   took      # => 0.100393978
    def took
      stop
      @took
    end
  end # Stopwatch
end

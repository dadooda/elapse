
# Load all stuff.
[
  "elapse/**/*.rb",
].each do |fmask|
  Dir[File.expand_path("../#{fmask}", __FILE__)].each do |fn|
    require fn
  end
end

# == Elapsed time measurement tool
#
# See {rubydoc documentation}[http://rubydoc.info/github/dadooda/elapse/master/frames] for basic usage examples.
module Elapse
  # Clear everything.
  def self.clear
    instance.clear
    nil
  end

  # Return sum of all measurements made by the stopwatch.
  #
  #   Elapse.start(:mytime); sleep 0.01; Elapse.stop(:mytime)
  #   Elapse.cumulative(:mytime)   # => 0.01
  #   Elapse.start(:mytime); sleep 0.02; Elapse.stop(:mytime)
  #   Elapse.cumulative(:mytime)   # => 0.03
  def self.cumulative(sw_key)
    instance.cumulative(sw_key)
  end

  # Reset the named stopwatch.
  #
  #   Elapse.reset(:mytime)
  def self.reset(sw_key)
    instance.reset(sw_key)
  end

  # Start the stopwatch. Return Time::now.
  #
  #   start             # Stacked mode.
  #   start(:mytime)    # Named mode.
  def self.start(sw_key = nil)
    instance.start(sw_key)
  end

  # Stop the stopwatch. Return Time::now.
  #
  #   stop            # Stacked mode.
  #   stop(:mytime)   # Named mode.
  def self.stop(sw_key = nil)
    instance.stop(sw_key)
  end

  # Return time of the last stopwatch measurement. If the stopwatch is running, stop it.
  #
  # Stacked mode:
  #
  #   start
  #   sleep 0.01
  #   took        # => 0.01
  #
  # Named mode:
  #
  #   start(:mytime)
  #   sleep 0.01
  #   took(:mytime)   # => 0.01
  #
  # Block execution, stacked mode:
  #
  #   took {sleep 0.01}    # => 0.01
  #
  # Block execution, named mode:
  #
  #   took(:mytime) {sleep 0.01}    # => 0.01
  def self.took(sw_key = nil, &block)
    instance.took(sw_key, &block)
  end

  class << self
    private

    # Return Elapse::Instance.
    def instance
      # We need not publish the instance object. Everything should be made via the API methods.
      @instance ||= Instance.new
    end
  end # class << self
end

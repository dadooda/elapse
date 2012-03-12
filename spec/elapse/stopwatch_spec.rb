require File.expand_path("../spec_helper", __FILE__)

describe Elapse::Stopwatch do
  before :each do
    @r = described_class.new
  end

  it "should generally work" do
    @r.start
    sleep 0.01
    ("%.2f" % @r.took).should == "0.01"

    @r.start
    sleep 0.01
    @r.stop
    ("%.2f" % @r.took).should == "0.01"

    @r.start
    @r.reset
    lambda do
      @r.stop
    end.should raise_error RuntimeError
  end

  describe "#cumulative" do
    it "should generally work" do
      @r.start; sleep 0.01; @r.stop
      @r.start; sleep 0.02; @r.stop
      ("%.2f" % @r.cumulative).should == "0.03"
    end

    it "should stop the timer" do
      @r.start
      @r.cumulative
      @r.running?.should == false
    end

    it "should allow multimple invocations and retain the last value" do
      @r.start
      sleep 0.01
      took1 = @r.cumulative
      sleep 0.02
      took2 = @r.cumulative
      took1.should == took2
    end
  end

  describe "#start" do
    it "should return a Time object" do
      @r.start.should be_a Time
    end

    it "should raise if already started" do
      lambda do
        @r.start
        @r.start
      end.should raise_error RuntimeError
    end
  end

  describe "#stop" do
    it "should return a Time object" do
      @r.start
      @r.stop.should be_a Time
    end

    it "should raise if never started" do
      lambda do
        @r.stop
      end.should raise_error RuntimeError
    end

    it "should not raise if called more than once" do
      lambda do
        @r.start
        @r.stop
        @r.stop
      end.should_not raise_error
    end
  end

  describe "#took" do
    it "should stop the timer" do
      @r.start
      @r.took
      @r.running?.should == false
    end

    it "should allow multimple invocations and retain the last value" do
      @r.start
      sleep 0.01
      took1 = @r.took
      sleep 0.01
      took2 = @r.took
      took1.should == took2
    end

    it "should raise if never started" do
      lambda do
        @r.took
      end.should raise_error RuntimeError
    end
  end
end

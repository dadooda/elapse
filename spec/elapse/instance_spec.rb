require File.expand_path("../spec_helper", __FILE__)

describe Elapse::Instance do
  before :each do
    @r = described_class.new
  end

  # Shared examples.
  it_behaves_like Elapse::Instance

  describe "#took block mode" do
    it "should work stacked" do
      took = @r.took {sleep 0.01}
      @r.stack.should be_empty
    end
  end

  describe "stacked mode" do
    describe "#start" do
      it "should add a stopwatch to the stack" do
        @r.stack.size.should == 0
        @r.start
        @r.stack.size.should == 1
        @r.start
        @r.stack.size.should == 2
      end
    end
  end
end

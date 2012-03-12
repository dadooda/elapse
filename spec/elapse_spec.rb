require File.expand_path("../spec_helper", __FILE__)

describe Elapse do
  before :each do
    @r = described_class
    @r.instance_eval {@instance = nil}
  end

  # Shared examples.
  it_behaves_like Elapse::Instance

  it "should generally work" do
  end
end

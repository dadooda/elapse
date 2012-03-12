shared_examples_for Elapse::Instance do
  describe "#took block mode" do
    it "should work stacked" do
      took = @r.took {sleep 0.01}
      ("%.2f" % took).should == "0.01"

      took = @r.took {sleep 0.01; @r.took {sleep 0.02}}
      ("%.2f" % took).should == "0.03"
    end

    it "should work named" do
      @r.took(:mytime) {sleep 0.01}
      ("%.2f" % @r.took(:mytime)).should == "0.01"
      @r.took(:mytime) {sleep 0.02}
      ("%.2f" % @r.took(:mytime)).should == "0.02"
      ("%.2f" % @r.cumulative(:mytime)).should == "0.03"
    end
  end

  describe "named mode" do
    it "should generally work" do
      @r.start(:mytime)
      sleep 0.01
      ("%.2f" % @r.took(:mytime)).should == "0.01"

      # Overlapping stopwatches.
      @r.start(:sw1)
      sleep 0.01
      @r.start(:sw2)
      sleep 0.02
      ("%.2f" % @r.took(:sw1)).should == "0.03"
      ("%.2f" % @r.took(:sw2)).should == "0.02"
    end

    describe "#cumulative" do
      it "should generally work" do
        @r.start(:mytime); sleep 0.01; @r.stop(:mytime)
        @r.took(:mytime) {sleep 0.02}
        ("%.2f" % @r.cumulative(:mytime)).should == "0.03"

        @r.reset(:mytime)
        lambda do
          @r.cumulative(:mytime)
        end.should raise_error RuntimeError   # "Stopwatch was never started"

        message = @r.cumulative(:mytime) rescue $!.message
        message.should be_a String
        message.should match /\s*:mytime\s*/
      end

      it "should validate presence" do
        lambda do
          @r.cumulative(:mytime)
        end.should raise_error RuntimeError
      end

      it "should report name in exception message" do
        message = @r.cumulative(:mytime) rescue $!.message
        message.should be_a String
        message.should match /\s*:mytime\s*/
      end
    end

    describe "#reset" do
      it "should validate presence" do
        lambda do
          @r.reset(:mytime)
        end.should raise_error RuntimeError
      end

      it "should report name in exception message" do
        message = @r.reset(:mytime) rescue $!.message
        message.should be_a String
        message.should match /\s*:mytime\s*/
      end
    end

    describe "#start" do
      it "should raise if already started" do
        @r.start(:mytime)
        lambda do
          @r.start(:mytime)
        end.should raise_error RuntimeError
      end

      it "should report name in exception message" do
        @r.start(:mytime)
        message = @r.start(:mytime) rescue $!.message
        message.should be_a String
        message.should match /\s*:mytime\s*/
      end

      it "should return a Time object" do
        @r.start(:mytime).should be_a Time
      end
    end

    describe "#stop" do
      it "should return a Time object" do
        @r.start(:mytime)
        @r.stop(:mytime).should be_a Time
      end

      it "should validate presence" do
        lambda do
          @r.stop(:mytime)
        end.should raise_error RuntimeError
      end

      it "should report name in exception message" do
        message = @r.stop(:mytime) rescue $!.message
        message.should be_a String
        message.should match /\s*:mytime\s*/
      end
    end
  end # describe "named mode"

  describe "stacked mode" do
    it "should generally work" do
      @r.start
      sleep 0.01
      ("%.2f" % @r.took).should == "0.01"

      @r.start
      sleep 0.01
        @r.start
        sleep 0.02
        ("%.2f" % @r.took).should == "0.02"
      ("%.2f" % @r.took).should == "0.03"
    end

    describe "#start" do
      it "should return a Time object" do
        @r.start.should be_a Time
      end
    end

    describe "#stop" do
      it "should return a Time object" do
        @r.start
        @r.stop.should be_a Time
      end

      it "should raise if stack underflow" do
        lambda do
          @r.stop
        end.should raise_error RuntimeError

        lambda do
          2.times {@r.start}
          3.times {@r.stop}
        end.should raise_error RuntimeError
      end
    end

    describe "#took" do
      it "should raise if stack underflow" do
        lambda do
          @r.took
        end.should raise_error RuntimeError

        lambda do
          2.times {@r.start}
          3.times {@r.took}
        end.should raise_error RuntimeError
      end
    end
  end # describe "stacked mode"
end # shared_examples_for Elapse::Instance

# Copyright (c) 2011-12 Michael Dvorkin
#
# Market Beat is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MarketBeat Method Dispatch and Error Hierarchy" do
  it "defines MarketBeat::Error, FetchError, and ParseError" do
    MarketBeat::Error.ancestors.should include(StandardError)
    MarketBeat::FetchError.ancestors.should include(MarketBeat::Error)
    MarketBeat::ParseError.ancestors.should include(MarketBeat::Error)
  end

  it "routes Google methods correctly via method_missing" do
    MarketBeat::Google.should_receive(:opening_price).with(:ibm).once.and_return("171.70")
    MarketBeat.opening_price(:ibm).should == "171.70"
  end

  it "routes Historical quotes correctly via method_missing" do
    MarketBeat::Historical.should_receive(:quotes).with(:aapl, "2011-12-21", "2011-12-23").once.and_return([])
    MarketBeat.quotes(:aapl, "2011-12-21", "2011-12-23").should == []
  end

  it "responds to registered metrics" do
    MarketBeat.respond_to?(:opening_price).should == true
    MarketBeat.respond_to?(:quotes).should == true
    MarketBeat.respond_to?(:non_existent_method_xyz).should == false
  end
end

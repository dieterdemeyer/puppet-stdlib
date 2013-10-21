#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the generate_sha256 function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("generate_sha256").should == "function_generate_sha256"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    lambda { scope.function_generate_sha256([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there is more than 2 argument" do
    expect { scope.function_generate_sha256(['foo', 'bar', 'baz']) }.to( raise_error(Puppet::ParseError) )
  end

  it "should raise a ParseError if you pass a non-string password" do
    expect { scope.function_generate_sha256([1234]) }.to( raise_error(Puppet::ParseError) )
  end

  it "should generate a valid password" do
    password_hash = scope.function_generate_sha256(["password", "test"])
    salt = password_hash.split('$')[2]
    password = password_hash.split('$')[3]

    salt.should == "test"
  end
end

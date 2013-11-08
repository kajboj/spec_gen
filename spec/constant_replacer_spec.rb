require_relative '../constant_replacer'

describe ConstantReplacer do
  subject { ConstantReplacer.new(input) }

  let(:input) do
    "
      Some::Kind::Of::Thing.new(thing)
      Hello.new(other_thing)
    "
  end 

  let(:expected_output) do
    "
      M.new('Some::Kind::Of::Thing').new(thing)
      M.new('Hello').new(other_thing)
    "
  end 

  its(:result) { should == expected_output }
end
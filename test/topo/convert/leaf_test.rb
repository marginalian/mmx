require "minitest/spec"
require "minitest/autorun"

require_relative "../../../lib/mmx/topo"

class Mmx::Topo::Convert::LeafTest < Minitest::Spec

  subject { Mmx::Topo::Convert::Leaf.(syntax_tree, []) }

  let(:syntax_tree) { Mmx::Topo.new("#{__dir__}/../../files/valid.topo", []).syntax_tree }
  let(:expected_output) { File.read("#{__dir__}/../../files/valid.leaf") }

  describe "#call" do
    it "converts to leaf" do
      File.write("#{__dir__}/output.leaf", subject)

      assert_equal expected_output, subject
    end
  end
end

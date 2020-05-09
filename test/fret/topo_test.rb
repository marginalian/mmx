require "minitest/spec"
require "minitest/autorun"

require_relative "../../lib/mmx/fret"

class TopoTest < Minitest::Spec
  subject { Mmx::Fret::Topo.call(path, report: false) }

  describe "malformed topo file" do
    # create path that is relative to this file, not current process
    let(:path) { "#{__dir__}/../files/bad.topo" }

    it "is not valid" do
      assert_equal subject.valid, false
    end

    it "reports double newlines" do
      assert_includes subject.errors, "line 3 is a double space line"
    end

    it "flags lines that contain too many spaces" do
      assert_includes subject.errors, "line 5 contains a malformed prefix"
    end

    it "flags lines that contain too few spaces" do
      assert_includes subject.errors, "line 6 contains a malformed prefix"
    end

    it "flags lines whose prefix is unknown" do
      assert_includes subject.errors, "line 8 contains a malformed prefix"
    end
  end
end


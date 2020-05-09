require "minitest/spec"
require "minitest/autorun"

require_relative "../lib/mmx/emender"

class EmenderTest < Minitest::Spec
  subject { Mmx::Emender.new('(mult-str "1")', []) }

  describe "#tokenize" do
    it "works with standard lisp" do
      tokens = subject.tokenize("(func arg1 arg2)")
      assert_equal tokens, ["(", "func", "arg1", "arg2", ")"]
    end

    it "works with strings" do
      tokens = subject.tokenize('(func "arg1 str" arg2)')
      assert_equal tokens, ["(", "func", "\"arg1 str\"", "arg2", ")"]
    end

    it "works with nesting" do
      tokens = subject.tokenize('(func arg1 (func2 arg2))')
      assert_equal tokens, ["(", "func", "arg1", "(", "func2", "arg2", ")", ")"]
    end
  end

  describe "#parenthesize" do
    it "returns the correct abstract syntax tree" do
      tokens = ["(", "func", "arg1", "arg2", ")"]
      expected = [{:type=>"identifier", :value=>"func"}, {:type=>"identifier", :value=>"arg1"}, {:type=>"identifier", :value=>"arg2"}]
      assert_equal subject.parenthesize(tokens), expected
    end

    it "works with string args" do
      tokens = ["(", "func", "\"arg1 str\"", "arg2", ")"]
      expected = [{:type=>"identifier", :value=>"func"}, {:type=>"string", :value=>"arg1 str"}, {:type=>"identifier", :value=>"arg2"}]
      assert_equal subject.parenthesize(tokens), expected
    end

    it "works with nesting" do
      tokens = ["(", "func", "arg1", "(", "func2", "arg2", ")", ")"]
      expected = [{:type=>"identifier", :value=>"func"}, {:type=>"identifier", :value=>"arg1"}, [{:type=>"identifier", :value=>"func2"}, {:type=>"identifier", :value=>"arg2"}]]
      assert_equal subject.parenthesize(tokens), expected
    end
  end

  describe "#interpret" do
    it "makes use of the library methods" do
      syntax_tree = [{:type=>"identifier", :value=>"mult_str"}, {:type=>"string", :value=>"1"}]

      stubbed_library = { mult_str: -> (str, context) { str * 2 } }
      subject.stub(:library, stubbed_library) do
        assert_equal subject.interpret(syntax_tree), "11"
      end
    end
  end

  describe "#call" do
    it "works" do
      stubbed_library = { 'mult-str': -> (str, context) { str * 2 } }

      subject.stub(:library, stubbed_library) do
        assert_equal subject.call, "11"
      end
    end
  end
end

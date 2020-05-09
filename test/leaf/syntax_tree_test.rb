require "minitest/spec"
require "minitest/autorun"

require_relative "../../lib/mmx/leaf"

class Mmx::Leaf::SyntaxTreeTest < Minitest::Spec
  subject { Mmx::Leaf::SyntaxTree.(file_content_lines) }
  let(:file_content_lines) do
    file_path = "#{__dir__}/../files/#{type}.leaf"
    Mmx::Leaf.new(file_path, []).file_content_lines
  end

  describe "paragraphs" do
    let(:type) { :paragraphs }

    it "squishes, strips and combines" do
      tree = [
        {
          type: :paragraph,
          arr: ["This is plain paragraph text."],
        },
        { type: :break, arr: ["___"] },
        {
          type: :paragraph,
          arr: ["This is a multiline block of paragraph text. It should be squished."],
        },
        {:type=>:space, :arr=>[]},
        {:type=>:paragraph, :arr=>["New paragraph"]},
      ]

      assert_equal tree, subject
    end
  end

  describe "headings" do
    let(:type) { :headings }

    it "distinguishes levels" do
      tree = [
        { type: :heading, arr: ["Heading 1"], lvl: 1 },
        {:type=>:space, :arr=>[]},
        { type: :heading, arr: ["Heading 2"], lvl: 2 },
        {:type=>:space, :arr=>[]},
        { type: :heading, arr: ["Heading 3"], lvl: 3 },
        {:type=>:space, :arr=>[]},
        { type: :heading, arr: ["Heading 4"], lvl: 4 },
        {:type=>:space, :arr=>[]},
        { type: :paragraph, arr: ["This is plain paragraph text."] },
      ]

      assert_equal tree, subject
    end
  end

  describe "lists" do
    let(:type) { :lists }

    it "groups list items" do
      tree = [
        { type: :paragraph, arr: ["The following is a list:"] },
        {:type=>:space, :arr=>[]},
        {
          type: :list,
          arr: [
            "list item 1",
            "list item 2 line 2",
            "list item 3",
          ],
        },
      ]

      assert_equal tree, subject
    end
  end

  describe "blockquotes" do
    let(:type) { :blockquotes }

    it "groups list items" do
      tree = [
        { type: :paragraph, arr: ["This is plain paragraph text."] },
        {:type=>:space, :arr=>[]},
        {
          type: :blockquote,
          arr: [
            "This is a multiline blockquote It should be squished.",
          ],
        },
      ]

      assert_equal tree, subject
    end
  end

  describe "code" do
    let(:type) { :code }

    it "groups list items" do
      tree = [
        { type: :paragraph, arr: ["This is plain paragraph text."] },
        {:type=>:space, :arr=>[]},
        {
          type: :code,
          arr: [
            "This is a multiline codeblock",
            "It should not be squished.",
          ],
        },
      ]

      assert_equal tree, subject
    end
  end

  describe "comments" do
    let(:type) { :comments }

    it "groups list items" do
      tree = [
        { type: :paragraph, arr: ["This is plain paragraph text."] },
        {:type=>:space, :arr=>[]},
        {
          type: :comment,
          arr: [
            "This is a multiline block of",
            "comment text. It should not be",
            "squished."
          ],
        },
      ]

      assert_equal tree, subject
    end
  end
end

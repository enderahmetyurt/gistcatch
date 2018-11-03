require "rails_helper"

describe Gist do
  it "validates presence for files" do
    subject = described_class.new files: nil

    expect(subject).not_to be_valid
    expect(subject.errors.added?(:files, :blank)).to eq true
  end

  describe "#valid?" do
    it "returns true if the gitst and its files are all valid" do
      subject = described_class.new description: "description", files: [
        Gist::File.new(filename: "test2.rb", content: "puts 'Hello'")
      ]

      expect(subject).to be_valid
    end

    it "also calls save for each file" do
      subject = described_class.new files: [
        Gist::File.new(filename: "test.rb", content: nil),
        Gist::File.new(filename: "test2.rb", content: "puts 'Hello'")
      ]

      subject.valid?

      expect(subject).not_to be_valid
      expect(subject.files[0]).not_to be_valid
      expect(subject.files[1]).to be_valid
    end
  end

  describe "#create_payload" do
    it "returns a hash" do
      subject = described_class.new description: "test", public: "1", files: []

      payload = subject.create_payload

      expect(payload[:description]).to eq "test"
      expect(payload[:public]).to eq true
      expect(payload[:files]).to be_empty
    end

    it "formats the :files key so in the expected format for the API" do
      subject = described_class.new files: [
        Gist::File.new(filename:  "test.rb", content: "puts 'Hello'")
      ]

      payload = subject.create_payload

      expect(payload[:files]).to have_key("test.rb")
      expect(payload[:files]["test.rb"]).to have_key(:content)
      expect(payload[:files]["test.rb"][:content]).to eq "puts 'Hello'"
    end
  end
end

describe Gist::File do
  it "validates presence for content" do
    subject = described_class.new content: nil

    expect(subject).not_to be_valid
    expect(subject.errors.added?(:content, :blank)).to eq true
  end
end

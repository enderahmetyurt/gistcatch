class Gist
  include ActiveModel::Model

  class File
    include ActiveModel::Model

    attr_accessor :filename, :content

    validates :content, presence: true
  end

  attr_accessor :description, :public, :files

  validates :description, presence: true

  def initialize(attributes = {})
    @files = []

    super
  end

  def files_attributes=(attributes)
    attributes.each do |index, file_params|
      @files.push Gist::File.new(file_params)
    end
  end

  def build_file(file_attributes = {})
    @files.push Gist::File.new(file_attributes)
  end

  def valid?
    super & files.map(&:valid?).reduce(&:&)
  end

  def create_payload
    {
      description: description,
      public: ActiveRecord::Type::Boolean.new.cast(public),
      files: format_files
    }
  end

  private

    def format_files
      files.reduce({}) do |memo, file|
        memo[file.filename] = file.content
        memo
      end
    end
end

class Gist
  include ActiveModel::Model

  class File
    include ActiveModel::Model

    attr_accessor :filename, :content
    validates :content, presence: true
  end

  attr_accessor :description, :public, :files

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
    is_valid = super & files.map(&:valid?).reduce(&:&)

    copy_files_errors_to_gist

    is_valid
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
        memo[file.filename] = { content: file.content }
        memo
      end
    end

    def copy_files_errors_to_gist
      files.each do |file|
        next if file.errors.empty?

        file.errors.full_messages.each do |message|
          errors.add(:files, message.downcase)
        end
      end
    end
end

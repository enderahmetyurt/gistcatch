class Gist
  include ActiveModel::Model

  class File
    include ActiveModel::Model

    attr_accessor :filename, :content

    validates :content, presence: true

    def new_record?
      true
    end

    def marked_for_destruction?
      false
    end

    def _destroy
      false
    end
  end

  attr_accessor :description, :public, :files

  validates :files, presence: true

  def files
    @files ||= []
  end

  def files_attributes=(attributes)
    @files = attributes.map do |_key, file_params|
      next nil if file_params[:content].blank?

      Gist::File.new(file_params)
    end.compact
  end

  def build_file(file_attributes = {})
    Gist::File.new(file_attributes)
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
      files.each.with_index.reduce({}) do |memo, (file, index)|
        file.filename = "gistfile#{index + 1}.txt" if file.filename.blank?

        memo[file.filename] = { content: file.content }

        memo
      end
    end
end

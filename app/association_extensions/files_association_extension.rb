# frozen_string_literal: true

# This adds the #with_contents function to an array that allows getting a file's
# contents easily.
module FilesAssociationExtension
  #
  # @return [Hash]
  #
  def with_contents
    map { |f| [f[:file], File.read(f.file.path)] }.to_h
  end
end

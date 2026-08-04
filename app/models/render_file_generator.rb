# frozen_string_literal: true

# This class serves as a generator for a RenderFile to take various data
# structures to write the new files to the database.
class RenderFileGenerator
  def self.from_files(files, user)
    return_files = []
    files.each do |file|
      content = File.read(file.file.file.path)
      name = file[:file]

      tfile = gen_file(name, content, user)

      tfile.save
      return_files.push tfile
    end

    return_files.map(&:id)
  end

  def self.from_data(name, content, user)
    tfile = gen_file(name, content, user)

    tfile.save

    tfile.id
  end

  class << self
    protected

      def gen_file(name, content, user)
        tfile = RenderFile.new

        tfile.expires = 1.day.from_now
        tfile.content = content
        tfile.name = name
        tfile.user = user

        tfile
      end
  end
end

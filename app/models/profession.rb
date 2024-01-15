require 'csv'

class Profession < ApplicationRecord
  has_many :characters

  def self.import(file_path: Rails.root.join('db','data','professions.csv'))
    raise IOError, 'No Professions File Found' unless File.exist?(file_path)
    CSV::Converters[:blank_to_nil] = ->(field) { field.blank? ? nil : field }
    CSV::Converters[:strip] = ->(field) { field.strip rescue field }

    CSV.foreach(file_path, headers: true, header_converters: :symbol, encoding: 'ISO-8859-1', converters: %i[strip blank_to_nil]) do |row|
      profession = Profession.find_or_create_by(name: row[:name])
      attributes_hash = { description: row[:discription]}
      profession.update(attributes_hash)
    end
  end
end

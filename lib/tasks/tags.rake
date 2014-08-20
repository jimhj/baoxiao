# coding: utf-8

require 'csv'
namespace :tags do
  desc "Import Muhua.com popular tags"
  task import: :environment do
    file = Rails.root.join('public/tags.csv')

    CSV.foreach file, :col_sep => "\t" do |row|
      name, description, keywords, seo_title = row[0], row[1], row[2], row[3]
      keywords = keywords.to_s.split(/,\s?|，\s?/).join(',')

      Rails.logger.info "-----------#{name}"

      ActsAsTaggableOn::Tag.find_or_create_by(name: name) do |tag|
        tag.description = description
        tag.keywords = keywords
        tag.seo_title = seo_title
      end
    end 

  end
end
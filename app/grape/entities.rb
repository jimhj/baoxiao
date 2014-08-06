module Baoxiao
  module APIEntities
    class User < Grape::Entity
      expose :id, :name, :email, :created_at, :voted_joke_ids
      expose :avatar_url do |model|
        model.avatar.thumb.url
      end
    end

    class Joke < Grape::Entity
      expose :id, :created_at, :anonymous, :up_votes_count, :down_votes_count

      expose :title do |model|
        model.title.blank? ? nil : model.title
      end

      expose :content do |model|
        model.content.blank? ? nil : model.content
      end      

      expose :picture_url do |model|
        if model.picture?        
          model.picture.small.url
        end
      end

      expose :bytes do |model|      
        (model.picture_meta_info["small"] || {})["size"]
      end

      expose :dimensions do |model|        
        {
          width: (model.picture_meta_info["small"] || {})["width"],
          height: (model.picture_meta_info["small"] || {})["height"]
        }
      end

      expose :user, :using => APIEntities::User
    end
  end
end
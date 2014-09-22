module Baoxiao
  module APIEntities
    class User < Grape::Entity
      expose :id, :name, :email, :created_at, :voted_joke_ids

      expose :avatar_url do |model|
        model.avatar.thumb.url
      end

      expose :private_token, if: { private_token: :show }
    end

    class Joke < Grape::Entity
      expose :id, :created_at, :up_votes_count, :down_votes_count, :comments_count

      expose :title do |model|
        model.title.blank? ? '' : model.title
      end

      expose :content do |model|
        if model.content.blank?
          ''
        else
          model.content.gsub(/<br\s*\/?>/, '\r\n')
        end
      end      

      expose :picture_url do |model|
        if model.picture?        
          model.picture.small.url
        else
          ''
        end
      end

      expose :bytes do |model|      
        (model.picture_meta_info["small"] || {})["size"] || ''
      end

      expose :dimensions do |model|        
        {
          width: (model.picture_meta_info["small"] || {})["width"] || '',
          height: (model.picture_meta_info["small"] || {})["height"] || ''
        }
      end

      expose :comments_count do |model|
        model.comments_count.to_i
      end

      expose :user, using: APIEntities::User, unless: lambda{ |joke, options| joke.anonymous? }
    end
  end
end
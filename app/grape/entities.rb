module Baoxiao
  module APIEntities
    class User < Grape::Entity
      expose :id, :name, :email, :created_at, :voted_joke_ids
      expose :avatar_url do |model|
        model.avatar.thumb.url
      end
    end

    class Joke < Grape::Entity
      expose :id, :title, :content, :created_at, :anonymous, :up_votes_count, :down_votes_count
      expose :picture_url do |model|
        if model.picture?
          model.picture.small.url
        end
      end
      expose :user, :using => APIEntities::User
    end
  end
end
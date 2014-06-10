class Joke < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  mount_uploader :picture, PictureUploader

  validates :title, uniqueness: true, length: { maximum: 40 }, allow_blank: true
  validates :content, presence: true, uniqueness: true, length: { minimum: 5, maximum: 200 }

  scope :recents, -> { where.not(title: nil).order('created_at DESC').limit(10) }
  scope :recent_pictures, -> { where.not(title: nil, picture: nil).order('created_at DESC').limit(6) }

  belongs_to :user

  HOT_WORDS = %w{伤不起 校园 围观 ML 美女 火星文 非主流 一句话不割 穿越 秒杀 萝莉 hold 腐女 TT 御姐 mm 正太 你懂的}

  def from
    case read_attribute(:from)
    when 'QB'; then '糗事百科';
    when 'MH'; then '快乐麻花';
    end
  end

  def prev
    Joke.where("id > ?", id).order("id ASC").first    
  end

  def next
    Joke.where("id < ?", id).order("id DESC").first    
  end

  def self.search_with_hightlight q
    highlight_opts = {
      "term_vector"     => "with_positions_offsets" 
    }

    search(
      query: {
        multi_match: {
          query: q.to_s,
          fields: ['title', 'content']
        }
      },

      highlight: {

        fields: {
          title: highlight_opts,
          content: highlight_opts
        }
      }
    )
  end
end

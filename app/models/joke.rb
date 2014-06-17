class Joke < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  acts_as_taggable

  mount_uploader :picture, PictureUploader

  validates :title, uniqueness: true, length: { maximum: 40 }, allow_blank: true
  validates :content, presence: true, uniqueness: { if: Proc.new { |joke| joke.picture.blank? } }, length: { minimum: 2, maximum: 300 }

  default_scope { where(status: Joke.statuses[:approved]) }

  scope :hot, -> { where.not(title: nil).order('hot DESC') }
  scope :hot_pictures, -> { hot.where.not(picture: nil) }
  scope :recents, -> { where.not(title: nil).order('created_at DESC') }
  scope :recent_pictures, -> { recents.where.not(picture: nil) }

  belongs_to :user

  after_create :update_hot
  after_touch :update_hot

  enum status: [ :pending, :approved, :rejected ]

  HOT_WORDS = %w{伤不起 校园 围观 ML 美女 火星文 非主流 一句话不割 穿越 秒杀 萝莉 hold 腐女 TT 御姐 mm 正太 你懂的}

  def self.random
    # See: http://stackoverflow.com/questions/8674718/best-way-to-select-random-rows-postgresql
    sql = <<-SQL
      select * from jokes where random() < 0.01 limit 1;
    SQL

    find_by_sql(sql).first
  end

  def self.recommends(total = 8)
    uncached do
      find_by_sql(
        <<-SQL
          SELECT * FROM jokes where recommended is true and status = 1 order by random() LIMIT #{total};
        SQL
      )
    end
  end

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

  # See https://gist.github.com/xdite/1391980
  def calculate_hot
    score = (up_votes_count - down_votes_count).abs
    order = Math.log10([score, 1].max)

    if score > 0
      sign = 1
    elsif score < 0
      sign = -1
    else
      sign = 0
    end

    seconds = created_at - DateTime.new(1970,1,1)
    long_num = order + sign * seconds / 45000
    (long_num * 10**7).round.to_f / (10**7)
  end

  def update_hot
    # reload because comments_count has been cache in associations
    reload
    update_attribute :hot, calculate_hot
  end

  def vote_by_anonymous flag
    flag.to_i > 0 ? increment!(:up_votes_count) : increment!(:down_votes_count)   
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

  def more_like_this
    Joke.search(
      query: {
        more_like_this: {
          fields: ['title', 'content'],
          like_text: "#{title}\n#{content}"
        }
      },

      filter: {
        bool: {
          must_not: {
            term: { id: id}
          },
          must: {
            exists: { field: 'title' }
          }
        }
      }
    ).records.limit(10) 
  end
end

# encoding: utf-8
class Joke < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include JokeCacheSweeper

  acts_as_taggable

  mount_uploader :picture, PictureUploader

  validates :title, uniqueness: true, length: { maximum: 40 }, allow_blank: true
  validates :content, presence: true, if: Proc.new { |joke| joke.title.blank? }
  # validates :content, presence: true, 
  #                     uniqueness: { if: Proc.new { |joke| joke.picture.blank? } }, 
  #                     length: { minimum: 2, maximum: 300 },
  #                     unless: Proc.new { |joke| joke.user.admin? }

  default_scope { where(status: Joke.statuses[:approved]) }

  scope :hot, -> { where.not("title is null or title = ''").order('hot DESC') }
  scope :hot_pictures, -> { hot.where.not(picture: nil) }
  scope :recents, -> { where.not("title is null or title = ''").order('created_at DESC') }
  scope :recent_pictures, -> { recents.where.not(picture: nil) }

  store :picture_meta_info, accessors: [:normal, :small, :thumb]

  belongs_to :user
  has_many :comments, dependent: :destroy

  after_create :update_hot, :store_picture_meta_info
  after_touch :update_hot

  before_create do
    if up_votes_count.blank? || up_votes_count.zero?
      self.up_votes_count = rand(1000)
      self.down_votes_count = self.up_votes_count * rand(50) / 100
    end
  end

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
    when "HH"; then '傲游哈哈';
    end
  end

  def picture_alt
    if title.blank?
      (content || "").split(/,|，/).last
    else
      title
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

  def store_picture_meta_info
    return if self.picture.nil?
    self.picture.versions.each do |version, uploader|
      next if uploader.path.blank?
      image = MiniMagick::Image.open uploader.path
      self.picture_meta_info[version.to_s] = {
        'size'      =>   uploader.size,
        'width'     =>   image[:width],
        'height'    =>   image[:height]
      }
      image.destroy!
    end
    self.save(validate: false)
  end

  handle_asynchronously :store_picture_meta_info, queue: 'store_picture_meta_info'

  def vote_by_anonymous flag
    flag.to_i > 0 ? increment!(:up_votes_count) : increment!(:down_votes_count)   
  end

  def newbee_comment
    comments.where('likes_count > 5').order('likes_count DESC, id DESC').first
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

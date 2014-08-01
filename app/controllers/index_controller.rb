class IndexController < ApplicationController
  caches_action :index, :cache_path => Proc.new { |c| c.params }, :expires_in => 1.hour

  def index
    @jokes = Joke.includes(:user).order('id DESC')
                                 .paginate(page: params[:page], per_page: 20, total_entries: 2000)

    set_seo_meta
  end
end
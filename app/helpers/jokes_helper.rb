module JokesHelper
  def sibling_joke_path(joke = nil)
    return if joke.nil?
    joke_path joke
  end
end
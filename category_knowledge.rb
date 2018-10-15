require 'yaml'

class CategoryKnowledge

  attr_reader :data

  def initialize
    @data = YAML.load_file('./categories.yml')
  end

  def classify(text)
    text_category = 'misc'
    data.each do |(category, keywords)|
      classified = text
        .upcase
        .split(' ')
        .select { |word| word.size > 1 || word.size > 2 }
        .any? do |word|
          exact_match(keywords, word)
        end
      text_category = category if classified
    end
    text_category
  end

  private

  def exact_match(keywords, word)
    keywords.upcase.split(' ').any? { |keyword| keyword == word }
  end

end

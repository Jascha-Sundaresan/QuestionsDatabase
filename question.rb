class Question
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM questions')
    results.map { |result| Question.new(result) }
  end

  attr_accessor :id, :title, :body, :user_id

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    query = <<-SQL
    SELECT * FROM questions WHERE id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, id)
    options.map { |result| Question.new(result) }.first
  end
  
  def self.find_by_title(title)
    query = <<-SQL
    SELECT * FROM questions WHERE title = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, title)
    options.map { |result| Question.new(result) }
  end
  
  def self.find_by_author_id(author_id)
    query = <<-SQL
    SELECT * FROM questions WHERE user_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, author_id)
    options.map { |result| Question.new(result) }
  end
  
  # def self.find_by_body(body)
  #   query = <<-SQL
  #   SELECT * FROM questions WHERE body LIKE ?
  #   SQL
  #   options = QuestionsDatabase.instance.execute(query, '"%' + body + '%"')
  #   options.map { |result| Question.new(result) }
  # end
  
  def author
    User.find_by_id(user_id)
  end
  
  def replies
    Reply.find_by_question_id(id)
  end
  
  def followers
    QuestionFollower.followers_for_question_id(id)
  end
  
  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end
  
  def likers
    QuestionLike.likers_for_question_id(id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end
  
  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end
  
end
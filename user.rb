class User
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM users')
    results.map { |result| User.new(result) }
  end

  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.find_by_id(id)
    query = <<-SQL
    SELECT * FROM users WHERE id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, id)
    # options.map { |result| User.new(result) }.first
    User.new(options.first)
    
  end
  
  def self.find_by_name(fname, lname)
    query = <<-SQL
    SELECT * FROM users WHERE fname = ? AND lname = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, fname, lname)
    # options.map { |result| User.new(result) }
    User.new(options.first)
  end
  
  def authored_questions
    Question.find_by_author_id(id)
  end
  
  def authored_replies
    Reply.find_by_user_id(id)
  end
  
  def followed_questions
    QuestionFollower.followed_questions_for_user_id(id)
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end
end
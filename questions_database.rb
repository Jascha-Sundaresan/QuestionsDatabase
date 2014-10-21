require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database

  include Singleton

  def initialize
    super('questions.db')

    self.results_as_hash = true
    self.type_translation = true
  end
end

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
    options.map{|result| User.new(result)}.first
  end
  
  def find_by_name(fname, lname)
    query = <<-SQL
    SELECT * FROM users WHERE fname = ? AND lname = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, fname, lname)
    User.new(options)
  end
end

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

  def find_by_id(id)
    query = <<-SQL
    SELECT * FROM questions WHERE id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, id)
    Question.new(options)
  end
  
  def find_by_title(title)
    query = <<-SQL
    SELECT * FROM questions WHERE title = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, title)
    Question.new(options)
  end
end

class QuestionFollower
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM question_followers')
    results.map { |result| QuestionFollower.new(result) }
  end

  attr_accessor :id, :user_id, :question_id

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def find_by_id(id)
    query = <<-SQL
    SELECT * FROM question_followers WHERE id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, id)
    QuestionFollower.new(options)
  end
  
  def find_by_user_id(user_id)
    query = <<-SQL
    SELECT * FROM question_followers WHERE user_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, user_id)
    QuestionFollower.new(options)
  end
  
  def find_by_question_id(question_id)
    options = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT 
      * 
    FROM 
      question_followers 
    WHERE 
      question_id = ?
    SQL
    
    QuestionFollower.new(options)
  end
end

class Reply
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM replies')
    results.map { |result| Reply.new(result) }
  end

  attr_accessor :id, :question_id, :parent_reply_id, :reply_user_id, :body

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @reply_user_id = options['reply_user_id']
    @body = options['body']
  end

  def find_by_id(id)
    query = <<-SQL
    SELECT * FROM replies WHERE id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, id)
    Reply.new(options)
  end
  
  def find_by_reply_user_id(reply_user_id)
    query = <<-SQL
    SELECT * FROM replies WHERE user_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, reply_user_id)
    Reply.new(options)
  end
  
  def find_by_question_id(question_id)
    query = <<-SQL
    SELECT * FROM replies WHERE question_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, question_id)
    Reply.new(options)
  end
  
  def find_by_parent_reply_id(parent_reply_id)
    query = <<-SQL
    SELECT * FROM replies WHERE parent_reply_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, parent_reply_id)
    Reply.new(options)
  end
end

class QuestionLike
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM question_likes')
    results.map { |result| QuestionLike.new(result) }
  end
  attr_accessor :id, :question_id, :user_id

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def find_by_id(id)
    query = <<-SQL
    SELECT * FROM question_likes WHERE id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, id)
    QuestionLike.new(options)
  end
  
  def find_by_user_id(user_id)
    query = <<-SQL
    SELECT * FROM question_likes WHERE user_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, user_id)
    QuestionLike.new(options)
  end
  
  def find_by_question_id(question_id)
    query = <<-SQL
    SELECT * FROM question_likes WHERE question_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, question_id)
    QuestionLike.new(options)
  end
  
end



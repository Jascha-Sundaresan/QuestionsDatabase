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

  def self.find_by_id(id)
    query = <<-SQL
    SELECT * FROM replies WHERE id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, id)
    options.map { |result| Reply.new(result) }.first
  end
  
  def self.find_by_user_id(user_id)
    query = <<-SQL
    SELECT * FROM replies WHERE reply_user_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, user_id)
    options.map { |result| Reply.new(result) }
  end
  
  def self.find_by_question_id(question_id)
    query = <<-SQL
    SELECT * FROM replies WHERE question_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, question_id)
    options.map { |result| Reply.new(result) }
  end
  
  def self.find_by_parent_reply_id(parent_reply_id)
    query = "SELECT * FROM replies WHERE parent_reply_id = ?"
    options = QuestionsDatabase.instance.execute(query, parent_reply_id)
    options.map { |result| Reply.new(result) }
  end
  
  def author
    User.find_by_id(reply_user_id)
  end
  
  def question
    Question.find_by_id(question_id)
  end
  
  def parent_reply
    raise "no parent" if parent_reply_id.nil?
    Reply.find_by_id(parent_reply_id)
  end
  
  def child_replies
    Reply.find_by_parent_reply_id(id) 
  end
  
  
end
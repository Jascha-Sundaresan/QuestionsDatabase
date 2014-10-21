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

  def self.find_by_id(id)
    query = <<-SQL
    SELECT * FROM question_likes WHERE id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, id)
    options.map { |result| QuestionLike.new(result) }.first
  end
  
  def self.find_by_user_id(user_id)
    query = <<-SQL
    SELECT * FROM question_likes WHERE user_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, user_id)
    options.map { |result| QuestionLike.new(result) }
  end
  
  def self.find_by_question_id(question_id)
    query = <<-SQL
    SELECT * FROM question_likes WHERE question_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, question_id)
    options.map { |result| QuestionLike.new(result) }
  end
  
  def self.likers_for_question_id(question_id)
    query = <<-SQL
    SELECT
      *
    FROM
      users
    JOIN
      question_likes ql
    ON
      ql.user_id = users.id
    WHERE
      question_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, question_id)
    options.map { |result| User.new(result) }
  end
  
  def self.num_likes_for_question_id(question_id)
    query = <<-SQL
    SELECT
      COUNT(user_id) AS count
    FROM
      question_likes
    WHERE
      question_id = ?
    SQL
    
    
    thing = QuestionsDatabase.instance.execute(query, question_id)[0]["count"]
    # debugger
    
    thing
  end
  
  def self.liked_questions_for_user_id(user_id)
    query = <<-SQL
    SELECT
      *
    FROM
      questions
    JOIN
      question_likes ql
    ON
      ql.question_id = questions.id
    WHERE
      user_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, user_id)
    options.map { |result| User.new(result) }
  end
  
  def self.most_liked_questions(n)
    query = <<-SQL
    SELECT
      *
    FROM
      questions
    JOIN
      question_likes ql
    ON  
      ql.question_id = questions.id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(ql.user_id) DESC
    LIMIT 
      ?
    SQL
    
    options = QuestionsDatabase.instance.execute(query, n)
    
    options.map { |result| Question.new(result) }  
  end
  
end

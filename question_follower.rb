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

  def self.find_by_id(id)
    query = <<-SQL
    SELECT * FROM question_followers WHERE id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, id)
    options.map { |result| QuestionFollower.new(result) }.first
  end
  
  def self.find_by_user_id(user_id)
    query = <<-SQL
    SELECT * FROM question_followers WHERE user_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, user_id)
    options.map { |result| QuestionFollower.new(result) }
  end
  
  def self.find_by_question_id(question_id)
    options = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT 
      * 
    FROM 
      question_followers 
    WHERE 
      question_id = ?
    SQL
    
    options.map { |result| QuestionFollower.new(result) }
  end
  
  def self.followers_for_question_id(question_id)
    query = <<-SQL
    SELECT
      *
    FROM
      users 
    JOIN
      question_followers qf
    ON
      qf.user_id = users.id
    WHERE
      question_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, question_id)
    options.map { |result| QuestionFollower.new(result) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    query = <<-SQL
    SELECT
      *
    FROM
      questions 
    JOIN
      question_followers qf
    ON
      qf.question_id = questions.id
    WHERE
      user_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, user_id)
    options.map { |result| QuestionFollower.new(result) }
  end
  
  def self.most_followed_questions(n)
    query = <<-SQL
    SELECT
      *
    FROM
      questions
    JOIN
      question_followers qf
    ON
      qf.question_id = questions.id 
    GROUP BY
      questions.id
    ORDER BY
      COUNT(qf.user_id) DESC
    LIMIT
      ?
    
    SQL
    
    options = QuestionsDatabase.instance.execute(query, n)
    
    options.map { |result| Question.new(result) }
  end
  
end
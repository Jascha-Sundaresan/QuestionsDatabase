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
  
  def average_karma
    query = <<-SQL
    SELECT
      CAST(COUNT(DISTINCT(questions.id)) as FLOAT) AS "count", 
      SUM(CASE WHEN ql.user_id is null THEN 0 ELSE 1 END) AS "sum"
    FROM
      questions
    LEFT OUTER JOIN
      question_likes ql
    ON
      ql.question_id = questions.id
    WHERE 
      questions.user_id = ?
    SQL
    options = QuestionsDatabase.instance.execute(query, id).first
    p options
    options["sum"] / options["count"]
  end
  
  # def save
#     if self.id.nil?
#       table_name =
#       column_names = "fname, lname"
#       question_marks = "?, ?"
#       QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
#         INSERT INTO
#           #{table_name} (#{column_names})
#         VALUES
#           (#{question_marks})
#       SQL
#
#       @id = QuestionsDatabase.instance.last_insert_row_id
#     else
#       QuestionsDatabase.instance.execute(<<-SQL, fname, lname, id)
#         UPDATE
#           users
#         SET
#          fname = ?, lname = ?
#         WHERE id = ?
#       SQL
#     end
#   end
  def universal_save
    table_name = self.class.tableize
    vars = self.instance_variables
    vars_without_id = []
    vars.each { |var| vars_without_id << var unless var == :@id } 
    if self.id.nil?
      column_names = vars_without_id.map do |var|
        var.to_s[1..-1]
      end.join(", ")
      question_mark_array = Array.new(vars_without_id.length) { "?" }
      question_marks = question_mark_array.join(", ")
      
      QuestionsDatabase.instance.execute(<<-SQL, *vars_without_id)
              INSERT INTO
                 #{table_name} (#{column_names})
               VALUES
                 (#{question_marks})
             SQL
    
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      
      set_string = vars_without_id.map do |var|
        var.to_s[1..-1] + " = ?"
      end.join(", ")
    
      QuestionsDatabase.instance.execute(<<-SQL, *vars_without_id, id)
        UPDATE
          #{table_name}
        SET
         #{set_string}
        WHERE id = ? 
      SQL
    end
  end

end





# instance_variables.each do |var|
#   next if var == nil
#   QuestionsDatabase.instance.execute(<<-SQL, var)
#     INSERT INTO
#       users (#{var})
#     VALUES
#       (?)
#   SQL
# end
  
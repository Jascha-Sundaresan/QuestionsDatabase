CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  reply_user_id INTEGER NOT NULL,
  body VARCHAR(255) NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (reply_user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Bill', "O'Reilly"), ("John", "Stewart");

INSERT INTO
  questions (title, body, user_id)
VALUES
  ("Why is the sky blue?", "Those are the colors of God's farts", 
    (SELECT id FROM users WHERE fname = 'John')),
  ("The agnostic", "Is HE really there?", 
    (SELECT id FROM users WHERE fname = "Bill"));
  
INSERT INTO
  question_followers (user_id, question_id)
VALUES
((SELECT id FROM users WHERE lname = "O'Reilly"),
  (SELECT id FROM questions WHERE title = "Why is the sky blue?"));
  
INSERT INTO
  replies(question_id, parent_reply_id, reply_user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = "Why is the sky blue?"), NULL,
  (SELECT id from users WHERE lname = "O'Reilly"), 
  "It's a liberal conspiracy!");
  
INSERT INTO
  question_likes (question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = "The agnostic"),
  (SELECT id FROM users WHERE lname = "Stewart"));


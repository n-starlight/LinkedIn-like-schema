---All the ALTER commands are executed before data insertion
---Haven't use ON CASCADE DELETE FOR posts as they will be deleted before user_deletion in batches in backend logic .


DROP TABLE IF EXISTS users;
CREATE TABLE users(
user_id BIGSERIAL PRIMARY KEY,
name VARCHAR(100) NOT NULL,
headline VARCHAR(300) NOT NULL,
summary TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
-- update functionality can be added in backend
deleted_at TIMESTAMP DEFAULT NULL --NULL means account is active
--(for soft deletes if user wants to hibernate their account 
-- and to allow for recovery time period if requested for deletion)
)
ALTER TABLE users
ADD COLUMN last_name VARCHAR(100) NOT NULL ;


DROP TABLE IF EXISTS education;
CREATE TABLE education(
education_id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL,
school VARCHAR(250),
degree VARCHAR(200),
field_of_study VARCHAR(100),
start_date DATE,
end_date DATE,
grade VARCHAR(12),
activities VARCHAR(300),
FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ;



DROP TABLE IF EXISTS contact_info;
CREATE TABLE contact_info(
contact_id BIGSERIAL PRIMARY KEY,
user_id BIGINT REFERENCES users(user_id) ON DELETE CASCADE,
email VARCHAR(50) UNIQUE NOT NULL,
phone_no VARCHAR(15),
address VARCHAR(70),
website VARCHAR(100)
);
ALTER TABLE contact_info
ALTER COLUMN user_id SET NOT NULL; 


---skills table was not used
-- CREATE TYPE skill_category AS ENUM ('All' , 'Industry' , 'Tools');
-- CREATE TABLE skills(
-- skill_id SERIAL PRIMARY KEY,
-- skill_name VARCHAR(40) NOT NULL UNIQUE,
-- category skill_category NOT NULL DEFAULT 'All'
-- );
-- ALTER TABLE skills
-- ALTER COLUMN category DROP NOT NULL ;
-- didn't use this table later , modified the later one with skill name.

DROP TABLE IF EXISTS user_skills;
CREATE TABLE user_skills(
user_skill_id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
skills_name VARCHAR(100) NOT NULL UNIQUE,
endorsements INT DEFAULT 0,
skill_order INT 
);

DROP TABLE IF EXISTS companies;
CREATE TABLE companies(
comp_id BIGSERIAL PRIMARY KEY,
comp_name VARCHAR(250) NOT NULL UNIQUE,
comp_location VARCHAR(100)
);

DROP TABLE IF EXISTS experiences;
CREATE TABLE experiences(
experience_id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
company_id BIGINT NOT NULL REFERENCES companies(comp_id) ON DELETE CASCADE
);
-- each user_id and company_id combination is unique

DROP TYPE IF EXISTS role_location
CREATE TYPE role_location AS ENUM ('Office', 'Remote', 'Hybrid');

DROP TABLE IF EXISTS positions;
CREATE TABLE positions(
position_id SERIAL PRIMARY KEY,
experience_id BIGINT NOT NULL REFERENCES experiences(experience_id) ON DELETE CASCADE,
role VARCHAR(100) NOT NULL,
role_location role_location DEFAULT 'Office' ,
start_date DATE NOT NULL,
end_date DATE
);
ALTER TABLE positions
ADD COLUMN role_desc VARCHAR(1500);

DROP TYPE IF EXISTS conn_status;
CREATE TYPE conn_status AS ENUM ('accepted','pending','withdrawn','rejected');

DROP TABLE IF EXISTS connections;
CREATE TABLE connections(
connection_id BIGSERIAL PRIMARY KEY,
sender_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
receiver_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
status conn_status NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS follows;
CREATE TABLE follows (
follows_id BIGSERIAL PRIMARY KEY,
follower_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
followed_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- for follows will add in backend logic to add connections by default
-- until they have not unfollowed 

DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
post_id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL REFERENCES users(user_id),
content TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS commentss;
CREATE TABLE commentss (
comment_id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
post_id BIGINT NOT NULL REFERENCES posts(post_id) ON DELETE CASCADE,
content TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
like_id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
post_id BIGINT NOT NULL REFERENCES posts(post_id) ON DELETE CASCADE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

---- unique constraint for connections and followers 
ALTER TABLE connections
ADD CONSTRAINT unique_sender_receiver UNIQUE(sender_id,receiver_id);
ALTER TABLE follows
ADD CONSTRAINT unique_follower_followed UNIQUE(follower_id,followed_id);
ALTER TABLE experiences
ADD CONSTRAINT unique_user_company UNIQUE(user_id,company_id);

---- creating indexes on foreign keys
CREATE INDEX IF NOT EXISTS idx_education_user_id ON education(user_id);
CREATE INDEX IF NOT EXISTS idx_contact_info_user_id ON contact_info(user_id);
CREATE INDEX IF NOT EXISTS idx_user_skills_user_id ON user_skills(user_id);
CREATE INDEX IF NOT EXISTS idx_experiences_user_id ON experiences(user_id);
CREATE INDEX IF NOT EXISTS idx_experiences_company_id ON experiences(company_id);
CREATE INDEX IF NOT EXISTS idx_positions_experience_id ON positions(experience_id);
CREATE INDEX IF NOT EXISTS idx_connections_sender_id ON connections(sender_id);
CREATE INDEX IF NOT EXISTS idx_connections_receiver_id ON connections(receiver_id);


CREATE INDEX IF NOT EXISTS idx_follows_follower_id ON follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_follows_followed_id ON follows(followed_id);
CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(user_id);
CREATE INDEX IF NOT EXISTS idx_commentss_user_id ON commentss(user_id);
CREATE INDEX IF NOT EXISTS idx_commentss_post_id ON commentss(post_id);
CREATE INDEX IF NOT EXISTS idx_likes_user_id ON likes(user_id);
CREATE INDEX IF NOT EXISTS idx_likes_post_id ON likes(post_id);





---All the ALTER commands are executed before data insertion(later just modified the tables not using alter commands)
---Haven't use ON CASCADE DELETE FOR posts as they will be deleted before user_deletion in batches in backend logic .

--Creating Schema and initial data insertion  follows idempotency 
--To ensure no errors of unique constraint violations AND no nuplicate data insertions while running the script again and again

ALTER TABLE connections
DROP CONSTRAINT IF EXISTS unique_sender_receiver;
ALTER TABLE follows
DROP CONSTRAINT IF EXISTS unique_follower_followed;
ALTER TABLE experiences
DROP CONSTRAINT IF EXISTS unique_user_company;
ALTER TABLE likes
DROP CONSTRAINT IF EXISTS unique_post_userlike;
ALTER TABLE posts
DROP CONSTRAINT IF EXISTS unique_post_time;
ALTER TABLE commentss
DROP CONSTRAINT IF EXISTS unique_comment_time;

ALTER TABLE education DROP CONSTRAINT IF EXISTS education_user_id_fkey;
ALTER TABLE contact_info DROP CONSTRAINT IF EXISTS contact_info_user_id_fkey;
ALTER TABLE user_skills DROP CONSTRAINT IF EXISTS user_skills_user_id_fkey;
ALTER TABLE experiences DROP CONSTRAINT IF EXISTS experiences_user_id_fkey;
ALTER TABLE experiences DROP CONSTRAINT IF EXISTS experiences_company_id_fkey;
ALTER TABLE positions DROP CONSTRAINT IF EXISTS positions_experience_id_fkey;
ALTER TABLE connections DROP CONSTRAINT IF EXISTS connections_sender_id_fkey;
ALTER TABLE connections DROP CONSTRAINT IF EXISTS connections_receiver_id_fkey;
ALTER TABLE follows DROP CONSTRAINT IF EXISTS follows_follower_id_fkey;
ALTER TABLE follows DROP CONSTRAINT IF EXISTS follows_followed_id_fkey;
ALTER TABLE posts DROP CONSTRAINT IF EXISTS posts_user_id_fkey;
ALTER TABLE commentss DROP CONSTRAINT IF EXISTS commentss_user_id_fkey;
ALTER TABLE commentss DROP CONSTRAINT IF EXISTS commentss_post_id_fkey;
ALTER TABLE likes DROP CONSTRAINT IF EXISTS likes_user_id_fkey;
ALTER TABLE likes DROP CONSTRAINT IF EXISTS likes_post_id_fkey;
ALTER TABLE education DROP CONSTRAINT IF EXISTS unique_school_degree; 
ALTER TABLE positions DROP CONSTRAINT IF EXISTS unique_role_start;

DROP TABLE IF EXISTS education;
DROP TABLE IF EXISTS contact_info;
DROP TABLE IF EXISTS user_skills;
DROP TABLE IF EXISTS positions;
DROP TABLE IF EXISTS experiences;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS connections;
DROP TABLE IF EXISTS follows;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS commentss;
DROP TABLE IF EXISTS likes;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
user_id BIGSERIAL PRIMARY KEY,
name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
signup_email VARCHAR(120) UNIQUE NOT NULL,
headline VARCHAR(300) NOT NULL,
summary TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
-- update functionality can be added via  trigger or in backend
deleted_at TIMESTAMP DEFAULT NULL --NULL means account is active
--(for soft deletes if user wants to hibernate their account 
-- and to allow for recovery time period if requested for deletion)
);
-- ALTER TABLE users
-- ADD COLUMN last_name VARCHAR(100) NOT NULL ;


-- DROP TABLE IF EXISTS education;
CREATE TABLE education(
education_id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL,
school VARCHAR(250) NOT NULL,
degree VARCHAR(200) NOT NULL,
field_of_study VARCHAR(100),
start_date DATE,
end_date DATE,
grade VARCHAR(12),
activities VARCHAR(300),
FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ;
-- degree can be null usually



-- DROP TABLE IF EXISTS contact_info;
CREATE TABLE contact_info(
contact_id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
email VARCHAR(50) UNIQUE NOT NULL,
phone_no VARCHAR(15),
address VARCHAR(70),
website VARCHAR(100)
);
-- ALTER TABLE contact_info
-- ALTER COLUMN user_id SET NOT NULL; 


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

-- DROP TABLE IF EXISTS user_skills;
CREATE TABLE user_skills(
user_skill_id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
skills_name VARCHAR(100) NOT NULL UNIQUE,
endorsements INT DEFAULT 0,
skill_order INT 
);

-- DROP TABLE IF EXISTS companies;
CREATE TABLE companies(
comp_id BIGSERIAL PRIMARY KEY,
comp_name VARCHAR(250) NOT NULL UNIQUE,
comp_location VARCHAR(100)
);

-- DROP TABLE IF EXISTS experiences;
CREATE TABLE experiences(
experience_id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
company_id BIGINT NOT NULL REFERENCES companies(comp_id) ON DELETE CASCADE
);
-- each user_id and company_id combination is unique

DROP TYPE IF EXISTS role_location;
CREATE TYPE role_location AS ENUM ('Office', 'Remote', 'Hybrid');

-- DROP TABLE IF EXISTS positions;
CREATE TABLE positions(
position_id SERIAL PRIMARY KEY,
experience_id BIGINT NOT NULL REFERENCES experiences(experience_id) ON DELETE CASCADE,
role VARCHAR(100) NOT NULL,
role_location role_location DEFAULT 'Office' ,
role_desc VARCHAR(1500),
start_date DATE NOT NULL,
end_date DATE
);
-- ALTER TABLE positions
-- ADD COLUMN role_desc VARCHAR(1500);

DROP TYPE IF EXISTS conn_status;
CREATE TYPE conn_status AS ENUM ('accepted','pending','withdrawn','rejected');

-- DROP TABLE IF EXISTS connections;
CREATE TABLE connections(
connection_id BIGSERIAL PRIMARY KEY,
sender_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
receiver_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
status conn_status NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DROP TABLE IF EXISTS follows;
CREATE TABLE follows (
follows_id BIGSERIAL PRIMARY KEY,
follower_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
followed_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- for follows will add in backend logic to add connections by default
-- until they have not unfollowed 

-- DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
post_id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL REFERENCES users(user_id),
content TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DROP TABLE IF EXISTS commentss;
CREATE TABLE commentss (
comment_id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
post_id BIGINT NOT NULL REFERENCES posts(post_id) ON DELETE CASCADE,
content TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
like_id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
post_id BIGINT NOT NULL REFERENCES posts(post_id) ON DELETE CASCADE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

---- unique constraint for combinations of foreign keys
ALTER TABLE connections
ADD CONSTRAINT unique_sender_receiver UNIQUE(sender_id, receiver_id);

ALTER TABLE follows
ADD CONSTRAINT unique_follower_followed UNIQUE(follower_id, followed_id);

ALTER TABLE experiences
ADD CONSTRAINT unique_user_company UNIQUE(user_id, company_id);

ALTER TABLE likes
ADD CONSTRAINT unique_post_userlike UNIQUE(user_id, post_id);

ALTER TABLE posts
ADD CONSTRAINT unique_post_time UNIQUE(user_id, created_at);

ALTER TABLE commentss
ADD CONSTRAINT unique_comment_time UNIQUE(user_id, created_at);

ALTER TABLE education
ADD CONSTRAINT unique_school_degree UNIQUE(school, degree);

ALTER TABLE positions
ADD CONSTRAINT unique_role_start UNIQUE(role, start_date);

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





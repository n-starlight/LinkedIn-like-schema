--Schema and initial data insertion seeding follows idempotency 
--To ensure no errors of unique constraint violations AND no nuplicate data insertions while running the script again and again

INSERT INTO users(name,last_name,headline,summary,signup_email)
VALUES
('Nisha','.','.',NULL,'nysssachoudhary@gmail.com'),
('Khushboo','Choudhary','ML Engineer',NULL,'khushboochoudhary@gmail.com'),
('Shivika', 'L.','.',NULL,'shivikal@gmail.com'),
('Kanchan','Rajput','Software Enginner II @ Parker Digital',NULL,'kanchanrajput@gmail.com')
ON CONFLICT (signup_email) DO NOTHING;


INSERT INTO education(user_id,school,degree,field_of_study,start_date,end_date,grade,activities)
VALUES
((SELECT user_id FROM users WHERE signup_email = 'nysssachoudhary@gmail.com'),'Vidyashram Public School,Pilani','6th-10th grades',NULL,NULL,NULL,'86%(10th)',
'Martial Arts, 
Athletics(Long Distance & Sprint Running, Long and high Jumps, Hurdles Running, Calisthenics ...), 
Gully Football, Gully Cricket'),
((SELECT user_id FROM users WHERE signup_email = 'nysssachoudhary@gmail.com' ),'Birla Balika Vidyapeeth, Pilani','12th Grade(BSV)(CBSE)','Physics, Mathematics, Chemistry',
'2014-06-01','2015-05-30','94%',NULL);

INSERT INTO contact_info(user_id,email,phone_no,address,website)
VALUES
((SELECT user_id FROM users WHERE signup_email = 'nysssachoudhary@gmail.com'),'playg1288@gmail.com','8114450120','Rajasthan',NULL)
ON CONFLICT(email) DO NOTHING ;

WITH (SELECT user_id FROM users WHERE signup_email = 'nysssachoudhary@gmail.com') AS curr_user 
INSERT INTO user_skills(user_id,skills_name)
VALUES
(curr_user.user_id,'Machine Learning'),(curr_user.user_id,'Python'),(curr_user.user_id,'DSA'),(curr_user.user_id,'Martial Arts'),
(curr_user.user_id,'Exploratory Data Analysis'),(curr_user.user_id,'Tableau'),(curr_user.user_id,'Power BI'),(curr_user.user_id,'Javascript'),
(curr_user.user_id,'SQL'),(curr_user.user_id,'Linear Algebra'),(curr_user.user_id,'Atheletics'),(curr_user.user_id,'Football'),
(curr_user.user_id,'Numpy'),(curr_user.user_id,'Matplotlib'),(curr_user.user_id,'Statistics'),(curr_user.user_id,'Web Development');
ON CONFLICT(skills_name) DO NOTHING ;


INSERT INTO companies (comp_name,comp_location)
VALUES
('Polymerize','Singapore'),
('Amazon','Telangana'),
('Spartificial','Bengaluru')
ON CONFLICT(comp_name) DO NOTHING ;


INSERT INTO experiences(user_id,company_id)
VALUES
((SELECT user_id FROM users WHERE signup_email = 'nysssachoudhary@gmail.com' ),(SELECT company_id FROM companies WHERE comp_name = 'Polymerize')),
((SELECT user_id FROM users WHERE signup_email = 'nysssachoudhary@gmail.com' ),(SELECT company_id FROM companies WHERE comp_name = 'Amazon')),
((SELECT user_id FROM users WHERE signup_email = 'nysssachoudhary@gmail.com' ),(SELECT company_id FROM companies WHERE comp_name = 'Spartificial'))
ON CONFLICT(user_id,company_id) DO NOTHING ;


INSERT INTO positions(experience_id,role,role_location,start_date,end_date,role_desc)
VALUES
((SELECT company_id FROM companies WHERE comp_name = 'Polymerize'),'Frontend Engineer','Remote','2022-09-01','2022-09-16',
'Couldnt continue due to family concerns and health issues'),
((SELECT company_id FROM companies WHERE comp_name = 'Amazon'),'Logistics Associate','Remote','2023-10-01','2024-08-30',NULL),
((SELECT company_id FROM companies WHERE comp_name = 'Spartificial'),'ML Intern','Remote','2023-08-01','2022-10-10',
'•Supervised Multilabel,multi class image  classification of different protein locations using images of different morphology cells with the location of protein relative to cellular structure per sample on human protein atlas dataset.
•Improved model performance metrics like precision, recall etc. by exploring and selecting good data augmentation .Train recall improved  by approx 12% and precision by approx 3.5% ,validation precision by 2.3%, recall by approx 2.4%. 
•Explored various state of art models and their workings.
•Improved  model performance trained using Resnet50V2 architecture by further tweaks on dropout and dense layer from earlier implementation. train recall improved  by approx 15% and precision by approx 5.5% ,validation precision by 7.6%, recall by approx 15%. Also improved other metrics used.
Precision ,Recall results for this architecture --- train_precision--0.9887 ,train_recall--0.9104 , val_precision--0.7548 , val_recall--0.6164 
•Inferences suggest that model predictions can be improved by oversampling using image augmentations or including more images from other data sources.
•Also compared my predictions with model predictions for few classes out of 28.
•Explored CNNs and also tried few CNN models without using any state of the art models architectures.')


INSERT INTO connections(sender_id,receiver_id,status)
VALUES
((SELECT user_id FROM users WHERE signup_email = 'nysssachoudhary@gmail.com' ),(SELECT user_id FROM users WHERE signup_email = 'khushboochoudhary@gmail.com' ),'accepted'),
((SELECT user_id FROM users WHERE signup_email = 'nysssachoudhary@gmail.com' ),(SELECT user_id FROM users WHERE signup_email = 'shivikal@gmail.com' ),'accepted'),
((SELECT user_id FROM users WHERE signup_email = 'nysssachoudhary@gmail.com' ),(SELECT user_id FROM users WHERE signup_email = 'kanchanrajput@gmail.com' ),'accepted');
ON CONFLICT(sender_id,receiver_id) DO NOTHING ;


INSERT INTO follows(follower_id,followed_id,created_at)
SELECT sender_id,receiver_id,created_at FROM connections
WHERE status ='accepted' 
ON CONFLICT(follower_id,followed_id) DO NOTHING ;


INSERT INTO follows(follower_id,followed_id,created_at)
SELECT receiver_id,sender_id,created_at FROM connections
WHERE status ='accepted' 
ON CONFLICT(follower_id,followed_id) DO NOTHING ;



-- 1) created at should be current timestamp in real cases with real interactions 
-- but to not add a new post evry time the script is run using static tiem here,
-- also if we directly want to use post_id can do 
-- 2) insert one post and then populate likes/comments for that post, insert another post and populate likes for that 
-- while returning on post_id 

-- 3) created_at will be same for all queries if whole script is run at once.
-- 4) But we can keep it default as it's not required here.

INSERT INTO posts (user_id,content,created_at)
VALUES
((SELECT user_id FROM users WHERE signup_email = 'khushboochoudhary@gmail.com' ),'I''m thrilled to share that I have successfully completed my summer internship at Synchrony as a Machine Learning Intern!

During my time at this innovative fintech company, I had the incredible opportunity to network with other interns, diving deep into cutting-edge technologies like PySpark, Hive, and cloud infrastructure. My work focused on optimizing complex machine-learning models, which was both challenging and rewarding.

A highlight of my internship was emerging as one of the top 3 finalists in the Best Business Innovation category across the entire UIUC research park. This recognition came as a result of my contributions to migrating our technology space from SAS to Python—a project that I''m immensely proud of.

None of this would have been possible without the unwavering support of my colleagues at Synchrony. I''m especially grateful to my assignment leader, Lian Wang and my mentor, Joe Lotti for their guidance. A special shoutout to Karin Dor Markovich for her continued support throughout my journey and making it an equally enjoyable experience.

I''m also excited to share that I''ll be continuing with Synchrony as a Co-op Intern this fall. I’m looking forward to even more learning and new experiences ahead!',
'2024-11-19 14:58:00'),
((SELECT user_id FROM users WHERE signup_email = 'shivikal@gmail.com' ),
'I''m thrilled to share that I''ve completed my MSc in Astrophysics from Cardiff University (awaiting thesis results). My MSc thesis, titled "Evolution of Binary Black Hole in the Presence of a Supermassive Black Hole", explores the dynamics of hierarchical triple systems and how supermassive black holes influence binary black hole mergers.

Prior to this, I earned my B.Tech in Aerospace Engineering from Ramaiah University of Applied Sciences. My B.Tech thesis focused on "CFD and Thermal Analysis of the Orion Re-entry Capsule," where I used Ansys Fluent and Ansys Steady State Thermal to analyze flow patterns and thermal effects during the spacecraft''s re-entry into Earth''s atmosphere.

I''m currently pursuing a nine-month advanced certification in Space Technologies with IISc, covering topics such as Space Biotechnology, AI for Space Robotics, Space-Based Navigation Systems, and Thermal Management Systems.

My hands-on experience includes:

1. Spartificial (2024): Classifying gravity glitches using deep learning techniques.
2. Rescape Aerospace (2023): Part of the re-entry team designing reusable satellites for aerodynamically effective re-entry.
3. Stellarion (2021-2022): Contributed to literature on solar energy stations in space and worked on a camera cover project with the Moon Village Association.
4. Indian Institute of Astrophysics (IIA, 2022): Attended a summer school led by esteemed professors.
5. HyperGalactic Ventures (2021-2022): Completed a research fellowship focusing on space-related projects.

With a deep interest in black hole mergers, triple systems, N-body simulations, I’m now looking to pursue a PhD and contribute to cutting-edge research.
If anyone has advice, tips, or guidance on PhD applications (particularly in black hole physics, gravitational waves, or related fields), or knows of opportunities in this area, I''d greatly appreciate your input!
Thank you in advance for your support and insights!',
'2024-11-19 15:02:00')
ON CONFLICT ON CONSTRAINT unique_post_time DO NOTHING;


INSERT INTO likes(user_id,post_id)
VALUES((SELECT user_id FROM users WHERE signup_email = 'nysssachoudhary@gmail.com' ),
(SELECT post_id FROM posts WHERE user_id=(SELECT user_id FROM users WHERE signup_email = 'khushboochoudhary@gmail.com')
AND created_at BETWEEN '2024-11-19 14:58:00' AND '2024-11-19 14:59:00'
AND content like '%my colleagues at Synchrony%'
)),
((SELECT user_id FROM users WHERE signup_email = 'nysssachoudhary@gmail.com' ),
(SELECT post_id FROM posts WHERE user_id=(SELECT user_id FROM users WHERE signup_email = 'shivikal@gmail.com')
AND created_at BETWEEN '2024-11-19 15:00:00' AND '2024-11-19 15:02:00'
AND content like '%deep interest in black hole mergers%'
))
ON CONFLICT (user_id,post_id) DO NOTHING ;

INSERT INTO commentss(user_id,post_id,content)
VALUES
((SELECT user_id FROM users WHERE signup_email = 'nysssachoudhary@gmail.com' ),
(SELECT post_id FROM posts WHERE user_id=(SELECT user_id FROM users WHERE signup_email = 'khushboochoudhary@gmail.com' )
AND created_at BETWEEN '2024-11-19 14:58:00' AND '2024-11-19 14:59:00'
AND content like '%my colleagues at Synchrony%'
),
'Amazing!! 🤍Congrats Bro!!⚡')
ON CONFLICT (user_id,created_at) DO NOTHING ;

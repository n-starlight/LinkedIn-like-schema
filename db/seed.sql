--To ensure no errors of unique constraint violations AND no nuplicate data insertions while running the script again and again
--during initial stage of populating tables with some data ----> have used 
---> ON CONFLICT(unique_field) DO NOTHING


INSERT INTO users(name,last_name,headline,summary)
VALUES
('Nisha','.','.');


INSERT INTO education(user_id,school,degree,field_of_study,start_date,end_date,grade,activities)
VALUES
(1,'Vidyashram Public School,Pilani','6th-10th grades',NULL,NULL,NULL,'86%(10th)',
'Martial Arts, 
Athletics(Long Distance & Sprint Running, Long and high Jumps, Hurdles Running, Calisthenics ...), 
Gully Football, Gully Cricket'),
(1,'Birla Balika Vidyapeeth, Pilani','12th Grade(BSV)(CBSE)','Physics, Mathematics, Chemistry',
'2014-06-01','2015-05-30','94%',NULL);

INSERT INTO contact_info(user_id,email,phone_no,address,website)
VALUES
(1,'playg1288@gmail.com','8114450120','Rajasthan',NULL)
ON CONFLICT(email) DO NOTHING ;

INSERT INTO user_skills(user_id,skills_name)
VALUES
(1,'Machine Learning'),(1,'Python'),(1,'DSA'),(1,'Martial Arts'),
(1,'Exploratory Data Analysis'),(1,'Tableau'),(1,'Power BI'),(1,'Javascript'),
(1,'SQL'),(1,'Linear Algebra'),(1,'Atheletics'),(1,'Football'),
(1,'Numpy'),(1,'Matplotlib'),(1,'Statistics'),(1,'Web Development');
ON CONFLICT(skills_name) DO NOTHING ;


INSERT INTO companies (comp_name,comp_location)
VALUES
('Polymerize','Singapore'),
('Amazon','Telangana'),
('Spartificial','Bengaluru')
ON CONFLICT(comp_name) DO NOTHING ;


INSERT INTO experiences(user_id,company_id)
VALUES
(1,1),
(1,2),
(1,3)
ON CONFLICT(user_id,company_id) DO NOTHING ;


INSERT INTO positions(experience_id,role,role_location,start_date,end_date,role_desc)
VALUES
(1,'Frontend Engineer','Remote','2022-09-01','2022-09-16',
'Couldnt continue due to family concerns and health issues'),
(2,'Logistics Associate','Remote','2023-10-01','2024-08-30',NULL),
(3,'ML Intern','Remote','2023-08-01','2022-10-10',
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
(1,4,'accepted'),
(1,5,'accepted'),
(1,6,'accepted');
ON CONFLICT(sender_id,receiver_id) DO NOTHING ;


INSERT INTO follows(follower_id,followed_id,created_at)
SELECT sender_id,receiver_id,created_at FROM connections
WHERE status ='accepted' 
ON CONFLICT(follower_id,followed_id) DO NOTHING ;


INSERT INTO follows(follower_id,followed_id,created_at)
SELECT receiver_id,sender_id,created_at FROM connections
WHERE status ='accepted' 
ON CONFLICT(follower_id,followed_id) DO NOTHING ;


INSERT INTO posts (user_id,content)
VALUES
(4,'I''m thrilled to share that I have successfully completed my summer internship at Synchrony as a Machine Learning Intern!

During my time at this innovative fintech company, I had the incredible opportunity to network with other interns, diving deep into cutting-edge technologies like PySpark, Hive, and cloud infrastructure. My work focused on optimizing complex machine-learning models, which was both challenging and rewarding.

A highlight of my internship was emerging as one of the top 3 finalists in the Best Business Innovation category across the entire UIUC research park. This recognition came as a result of my contributions to migrating our technology space from SAS to Python—a project that I''m immensely proud of.

None of this would have been possible without the unwavering support of my colleagues at Synchrony. I''m especially grateful to my assignment leader, Lian Wang and my mentor, Joe Lotti for their guidance. A special shoutout to Karin Dor Markovich for her continued support throughout my journey and making it an equally enjoyable experience.

I''m also excited to share that I''ll be continuing with Synchrony as a Co-op Intern this fall. I’m looking forward to even more learning and new experiences ahead!'),
(5,
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
Thank you in advance for your support and insights!'
)

INSERT INTO likes(user_id,post_id)
VALUES(1,1),
(1,2)

INSERT INTO commentss(user_id,post_id,content)
VALUES
(1,1,'Amazing!! 🤍Congrats Bro!!⚡')
CREATE TABLE t_User (
  id                      TEXT NOT NULL PRIMARY KEY
  ,[name]                 TEXT
  ,email                  TEXT
  ,nameTag                TEXT
  ,birthDate              TEXT NOT NULL
  ,avatarLink             TEXT
  ,subscriptionsCount     INTEGER
  ,subscribersCount       INTEGER
  ,postsCount             INTEGER
);
CREATE TABLE t_SimpleUser (
  id                      TEXT NOT NULL PRIMARY KEY
  ,[name]                 TEXT
  ,nameTag                TEXT
  ,avatarLink             TEXT
);
CREATE TABLE t_Post (
  id                      TEXT NOT NULL PRIMARY KEY
  ,[description]          TEXT
  ,authorId               TEXT NOT NULL
  ,publishDate            TEXT
  ,likes                  INTEGER
  ,comments               INTEGER
  ,isModified             INTEGER
  ,isLiked                INTEGER
  ,FOREIGN KEY(authorId) REFERENCES t_SimpleUser(id)
);
CREATE TABLE t_PostContent (
  id                      TEXT NOT NULL PRIMARY KEY
  ,[name]                 TEXT
  ,mimeType               TEXT
  ,postId                 TEXT
  ,contentLink            TEXT
  ,FOREIGN KEY(postId) REFERENCES t_Post(id)
);
CREATE TABLE t_PostComment (
  id                      TEXT NOT NULL PRIMARY KEY
  ,authorId               TEXT NOT NULL
  ,postId                 TEXT NOT NULL
  ,content                TEXT
  ,likes                  INTEGER
  ,isLiked                INTEGER
  ,publishDate            TEXT
  ,FOREIGN KEY(authorId) REFERENCES t_SimpleUser(id)
  ,FOREIGN KEY(postId) REFERENCES t_Post(id)
);
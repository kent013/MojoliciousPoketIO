DROP TABLE IF EXISTS session;

#for MojoX::Session
CREATE TABLE IF NOT EXISTS session (
  sid VARCHAR(40),
  data TEXT,
  expires INTEGER UNSIGNED NOT NULL,
  UNIQUE(sid),
  PRIMARY KEY(sid)
);

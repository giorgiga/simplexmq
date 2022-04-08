{-# LANGUAGE QuasiQuotes #-}

module Simplex.Messaging.Agent.Store.SQLite.Migrations.M20220322_notifications where

import Database.SQLite.Simple (Query)
import Database.SQLite.Simple.QQ (sql)

m20220322_notifications :: Query
m20220322_notifications =
  [sql|
CREATE TABLE ntf_servers (
  ntf_host TEXT NOT NULL,
  ntf_port TEXT NOT NULL,
  ntf_key_hash BLOB NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (ntf_host, ntf_port)
) WITHOUT ROWID;

CREATE TABLE ntf_tokens (
  provider TEXT NOT NULL, -- apn
  device_token TEXT NOT NULL,
  ntf_host TEXT NOT NULL,
  ntf_port TEXT NOT NULL,
  tkn_id BLOB, -- token ID assigned by notifications server
  tkn_priv_key BLOB NOT NULL, -- private key to sign token commands
  tkn_dh_secret BLOB, -- DH secret for e2e encryption of notifications
  tkn_status TEXT NOT NULL,
  tkn_action BLOB,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')), -- this is to check token status periodically to know when it was last checked
  PRIMARY KEY (provider, device_token, ntf_host, ntf_port),
  FOREIGN KEY (ntf_host, ntf_port) REFERENCES ntf_servers
    ON DELETE RESTRICT ON UPDATE CASCADE
) WITHOUT ROWID;
|]

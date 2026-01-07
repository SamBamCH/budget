-- Users
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  display_name TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Account hierarchy (tree)
CREATE TABLE IF NOT EXISTS account_hierarchy (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_string TEXT UNIQUE NOT NULL,
  level INTEGER NOT NULL,
  parent_string TEXT,
  display_name TEXT,
  is_leaf INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Actual accounts (leaves)
CREATE TABLE IF NOT EXISTS accounts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_string TEXT NOT NULL,
  account_type TEXT NOT NULL,
  name TEXT,
  starting_balance REAL DEFAULT 0,
  current_balance REAL DEFAULT 0,
  description TEXT,
  is_active INTEGER DEFAULT 1,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (account_string) REFERENCES account_hierarchy(account_string)
);

-- Transactions (double-entry)
CREATE TABLE IF NOT EXISTS transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  debit_account_id INTEGER,
  credit_account_id INTEGER,
  amount REAL NOT NULL,
  transaction_date TEXT,
  description TEXT,
  source_file TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (debit_account_id) REFERENCES accounts(id),
  FOREIGN KEY (credit_account_id) REFERENCES accounts(id)
);

-- Indexes (performance)
CREATE INDEX IF NOT EXISTS idx_users_username ON users (username);
CREATE INDEX IF NOT EXISTS idx_accounts_account_string ON accounts (account_string);
CREATE INDEX IF NOT EXISTS idx_account_hierarchy_parent ON account_hierarchy (parent_string);
CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions (transaction_date);


CREATE TABLE IF NOT EXISTS schema_version (
  version INTEGER PRIMARY KEY,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);


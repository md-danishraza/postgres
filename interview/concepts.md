## Q: PostgreSQL architecture and components

A: PostgreSQL follows a Process-Based Architecture (unlike MySQL or Oracle, which often use threads). It relies heavily on the operating system for features like file caching and process scheduling.

The architecture is divided into three main pillars: Memory, Processes, and Storage.

1. Process Architecture (The Workforce)
   Unlike Node.js (single-threaded) or Java (multi-threaded), Postgres forks a new process for every single user connection.

Postmaster (The Supervisor):

This is the main daemon (postgres). It listens on port 5432.

When you connect, it checks authentication and "forks" a new process specifically for you.

Backend Processes (The Workers):

If 100 users connect, there are 100 backend processes.

Each process handles the Query Parsing, Planning, and Execution for its specific user.

Background Processes (The Maintenance Crew):

Background Writer (BGWriter): Slowly moves modified data ("dirty pages") from RAM to Disk so the database doesn't crash if RAM gets full.

WAL Writer: Flushes the transaction logs to disk to ensure data safety (ACID).

Autovacuum Launcher: Cleans up "dead rows" (deleted data that is still taking up space).

Checkpointer: Ensures that all transaction logs and data files are synchronized at specific intervals.

2. Memory Architecture (The Workspace)
   Postgres splits memory into "Public" and "Private" areas.

A. Shared Memory (Public)
Accessible by all processes. This is configured in postgresql.conf.

Shared Buffers: The main cache.

When you run SELECT \* FROM users, Postgres first looks here.

If data is found (Cache Hit), it returns instantly.

If not (Cache Miss), it fetches from Disk, puts it here, and then returns it.

WAL Buffers: A temporary holding area for transaction logs before they are written to disk.

B. Local Memory (Private)
Private to each specific backend process.

work_mem: Used for sorting (ORDER BY) and hashing (JOIN).

Warning: If you set this to 100MB and have 100 users sorting data, you consume 10GB of RAM instantly.

maintenance_work_mem: Used for heavy tasks like VACUUM, CREATE INDEX, or adding foreign keys.

temp_buffers: Used for temporary tables that exist only for your session.

3. Storage Architecture (The Files)
   This is what lives on your hard drive (usually in /var/lib/postgresql/data).

Heap Files (The Data):

This is where your tables actually live.

Postgres stores data in fixed-size blocks (default 8KB) called "Pages."

WAL Files (The Safety Net):

Write-Ahead Log (WAL).

Rule: "Log it before you do it."

Before Postgres modifies the actual Heap file, it writes the action to the WAL. If the power plug is pulled, Postgres replays the WAL to recover lost data.

Control File:

A tiny file that records the cluster's state (e.g., "Was the database shut down cleanly?").

4. The Life of a Query (How it connects)
   Let's trace a simple Update transaction: UPDATE users SET age = 30 WHERE id = 1;

Connection: The Postmaster accepts your connection and starts a Backend Process.

Parsing: The Backend checks syntax ("Is the SQL valid?").

Planning: The Optimizer decides the fastest path (Index Scan vs. Seq Scan).

Execution (WAL):

The change (age = 30) is written to the WAL Buffer (Memory).

The WAL Writer flushes it to the WAL File (Disk). (Commit happens here).

Execution (Data):

The data in Shared Buffers is modified. The page is now marked as "Dirty" (Modified in RAM, but old on Disk).

Background Sync:

Later (milliseconds or minutes), the Background Writer or Checkpointer wakes up and saves that "Dirty Page" to the actual Heap File on disk.

## Q: catalog tables and system tables

A:
In PostgreSQL, Catalog Tables (also known as System Tables) are the place where the database stores Metadata—data about the data.

When you create a table, add a column, or create a user, Postgres does not just "remember" it magically; it inserts a row into these internal system tables. They act as the database's own internal database.

1. Where do they live?
   They reside in a special schema called pg_catalog. You can query them just like normal tables:

SQL

SELECT \* FROM pg_catalog.pg_tables; 2. The Core System Tables
Almost every object in Postgres has a corresponding row in one of these tables.

A. pg_class (The "Everything" Table)
This is arguably the most important table. It tracks Relations. In Postgres, "Relations" include:

Tables

Indexes

Sequences

Views

Materialized Views

If you run CREATE TABLE my_users ..., a new row is inserted here.

Key Columns: relname (Table Name), reltuples (Approx row count), relpages (Disk size estimate).

B. pg_attribute (The Columns Table)
Tracks information about the columns (attributes) inside the relations defined in pg_class.

If my_users has 3 columns (id, name, email), there will be 3 rows in pg_attribute linked to the single row in pg_class.

Key Columns: attname (Column Name), atttypid (Link to Data Type), attnotnull (Is Not Null?).

C. pg_namespace (The Schemas Table)
Tracks schemas (like public, pg_catalog, or your custom schemas).

Key Columns: nspname (Schema Name).

D. pg_type (The Data Types Table)
Tracks data types (e.g., int4, text, bool) and any custom types you create.

E. pg_proc (The Functions Table)
Tracks stored procedures and functions. Even built-in functions like count() or lower() are defined here.

3. How they connect (The OID Link)
   Postgres uses OIDs (Object IDs) to link these tables together internally.

Example Relationship:

pg_class.relnamespace points to pg_namespace.oid (Which schema is this table in?).

pg_attribute.attrelid points to pg_class.oid (Which table does this column belong to?).

pg_attribute.atttypid points to pg_type.oid (What is the data type of this column?)

## Q: replication strategies and methods

A:
Replication is the process of keeping a copy of the same data on multiple machines (nodes) that are connected via a network.

We do this for two main reasons:

High Availability (HA): If one server dies, the system keeps working.

Scalability (Performance): You can distribute the read load across many machines.

Here are the core strategies and methods used in systems like PostgreSQL, MySQL, MongoDB, and Cassandra.

1. The Timing Strategies (Sync vs. Async)
   This defines when the data is copied.

A. Synchronous Replication
The "Safe but Slow" approach.

Flow:

Client sends INSERT to the Leader.

Leader sends the data to the Follower.

Leader waits for the Follower to say "ACK" (Acknowledged/Saved).

Leader tells the Client "Success."

Pros: Zero Data Loss. If the Leader dies, the Follower is guaranteed to have the latest data.

Cons: High Latency. If the Follower is slow or the network glitches, the entire write operation freezes. If the Follower dies, no one can write.

B. Asynchronous Replication
The "Fast but Risky" approach. (Most common default).

Flow:

Client sends INSERT to the Leader.

Leader saves it and immediately tells Client "Success."

Leader sends the data to the Follower in the background.

Pros: Fast writes. The Leader doesn't care if the Follower is slow.

Cons: Replication Lag. If the Leader crashes before sending the data to the Follower, those recent writes are lost forever.

Shutterstock
Explore 2. The Architectures (Who accepts writes?)
A. Single-Leader (Master-Slave)
How it works:

One node is the Leader (Master). It accepts Writes and Reads.

Other nodes are Followers (Slaves/Replicas). They accept Reads Only.

Followers pull data from the Leader.

Use Case: PostgreSQL, MySQL, SQL Server.

Advantage: Simple to understand. No conflict resolution needed (because only one node decides the order of writes).

Disadvantage: If the Leader fails, you need a "Failover" process to promote a Follower.

B. Multi-Leader (Master-Master)
How it works:

You have 2+ nodes that can all accept Writes.

They sync with each other asynchronously.

Use Case: Systems spanning multiple datacenters (e.g., One master in USA, one in India). You write to the closest one.

Advantage: Write availability. If one datacenter dies, the other still accepts writes.

Disadvantage: Write Conflicts. What if User A sets color=red in USA, and User B sets color=blue in India at the exact same time? You need complex logic to merge these.

C. Leaderless (Dynamo-style)
How it works:

There is no leader. The client sends the Write to all nodes (or a coordinator does).

Quorum (Voting): To consider a write "successful", you need confirmation from W nodes. To read, you ask R nodes.

Rule: W + R > N (where N is total nodes). This guarantees overlap so you always read the latest data.

Use Case: Cassandra, DynamoDB.

Advantage: Extremely robust. Nodes can fail and come back without downtime.

Disadvantage: "Read Repair" is needed (clients fix old data when they see it).

3. The Mechanisms (How data moves?)
   Specifically in the context of databases like PostgreSQL.

A. Physical Replication (Streaming Replication)
What it sends: It sends the actual bits/bytes from the disk (Using the WAL - Write Ahead Log).

Concept: "Write byte 0xA1 at block 450."

Pros: Extremely fast, exact clone.

Cons: Inflexible. You cannot replicate just one table. Both servers must be on the exact same OS and DB version.

B. Logical Replication
What it sends: It sends the logical data changes.

Concept: "Insert row (id=1, name='Bilal') into table users."

Pros: Flexible.

You can replicate between different major versions (Postgres 13 -> 15).

You can replicate just specific tables.

You can send data to external systems (e.g., Postgres -> Kafka -> Data Warehouse).

Cons: Slightly higher overhead than physical replication.

## Q: Backup and recovery approaches

A:
In PostgreSQL, backup and recovery strategies fall into two main categories: Logical (exporting data) and Physical (copying files).

Here is the breakdown of the approaches, tools, and when to use them.

1. Logical Backups (SQL Dump)
   This approach extracts the data as a series of SQL commands (CREATE TABLE, INSERT INTO).

Tool: pg_dump (for one DB) or pg_dumpall (for the entire cluster).

How it works: It reads the database and writes a text file containing the SQL needed to recreate it.

Pros:

Portable: You can restore a backup from Linux to Windows or from Postgres 13 to Postgres 15.

Flexible: You can backup just one specific table.

Small Size: Can be compressed easily.

Cons:

Slow Restore: The database has to re-execute every single SQL command and rebuild indexes from scratch. Not suitable for massive databases (TB+).

Example Command:

Bash

# Backup

pg_dump -U postgres my_db > backup.sql

# Restore

psql -U postgres -d my_db -f backup.sql 2. Physical Backups (File System Level)
This approach copies the raw directories and files where Postgres stores data.

Tool: pg_basebackup.

How it works: It streams the actual binary data from the server's data directory (/var/lib/postgresql/data) to a backup location.

Pros:

Fast Restore: You essentially just paste the files back. No SQL execution needed.

Consistent: Can be done while the database is running (Hot Backup).

Cons:

Not Portable: You cannot restore a Linux physical backup onto a Windows machine. The architecture must match exactly.

All-or-Nothing: You cannot backup just one table. It is the whole cluster or nothing.

Example Command:

Bash

pg_basebackup -D /backup_path -Fp -Xs -P

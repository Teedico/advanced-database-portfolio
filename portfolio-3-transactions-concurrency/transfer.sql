-- Convenience runner: I run the success demo, then the commands for rollback and concurrency are printed.
-- I preferred the individual scripts for cleaner screenshots.

\i transfer_success.sql

\echo ''
\echo 'Next:'
\echo '  psql -d unipay -f transfer_rollback.sql'
\echo '  (two windows) concurrency_session_a.sql / concurrency_session_b.sql'

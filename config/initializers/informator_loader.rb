FeedFileLoadJob.perform_later
Entry.delete_all if Entry.table_exists?
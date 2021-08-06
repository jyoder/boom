-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE messages (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    sender TEXT NOT NULL,
    is_final BOOLEAN NOT NULL,
    words TEXT NOT NULL
);

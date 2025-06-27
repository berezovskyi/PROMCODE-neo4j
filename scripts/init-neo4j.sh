#!/bin/bash

echo "Waiting for Neo4j to be ready..."
until cypher-shell -a bolt://neo4j:7687 -u neo4j -p password123 "RETURN 1;" > /dev/null 2>&1; do
  sleep 2
done

echo "Neo4j is ready. Initializing neosemantics..."

# Create unique constraint for n10s
cypher-shell -a bolt://neo4j:7687 -u neo4j -p password123 "CREATE CONSTRAINT n10s_unique_uri IF NOT EXISTS FOR (r:Resource) REQUIRE r.uri IS UNIQUE;"

# Initialize neosemantics
cypher-shell -a bolt://neo4j:7687 -u neo4j -p password123 "CALL n10s.graphconfig.init();"

echo "Neosemantics initialized successfully!"

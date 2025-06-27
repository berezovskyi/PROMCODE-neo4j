# PROMCODE

A full-stack application for uploading and processing Turtle (RDF) files with Neo4j integration.

## Project Structure

- `PROMCODE-client/` - Vue.js 2 frontend application for file upload interface
- `PROMCODE-server/` - Node.js/Express backend for file processing and Neo4j integration
- `scripts/` - Initialization scripts for setup
- `docker-compose.yml` - Docker configuration for the entire stack

## Quick Start with Docker (Recommended)

The easiest way to run PROMCODE is using Docker Compose, which will set up the entire stack including Neo4j with the neosemantics plugin.

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Running with Docker

1. **Clone and navigate to the project**
   ```bash
   git clone <repository-url>
   cd PROMCODE
   ```

2. **Start the entire stack**
   ```bash
   docker-compose up --build
   ```

3. **Access the application**
   - Frontend: http://localhost:8080
   - Neo4j Browser: http://localhost:7474 (username: `neo4j`, password: `password123`)
   - Backend API: http://localhost:3000

4. **Stop the application**
   ```bash
   docker-compose down
   ```

5. **Clean up (removes all data)**
   ```bash
   docker-compose down -v
   ```

### Docker Services

The Docker setup includes:

- **neo4j**: Neo4j database with neosemantics plugin pre-installed
- **neo4j-init**: One-time initialization service that configures neosemantics
- **server**: Node.js backend API
- **client**: Vue.js frontend served with Nginx

### Environment Variables

Default Docker environment:
- Neo4j username: `neo4j`
- Neo4j password: `password123`
- Server URL: `http://localhost:3000`
- Client URL: `http://localhost:8080`

To customize, modify the `docker-compose.yml` file.

## Manual Installation (Alternative)

If you prefer to run without Docker:

### Prerequisites
- [Node.js](https://nodejs.org/) (version 12 or higher)
- [npm](https://www.npmjs.com/) (comes with Node.js)
- [Neo4j Database](https://neo4j.com/) with the [neosemantics (n10s) plugin](https://neo4j.com/labs/neosemantics/)

### Neo4j Setup
1. Install Neo4j Desktop or Neo4j Community Edition
2. Create a new database
3. Install the neosemantics (n10s) plugin:
   ```cypher
   CREATE CONSTRAINT n10s_unique_uri FOR (r:Resource) REQUIRE r.uri IS UNIQUE
   ```
   ```cypher
   CALL n10s.graphconfig.init()
   ```

### Installation Steps

1. **Set up the server**
   ```bash
   cd PROMCODE-server
   npm install
   ```

   Create a `.env` file in the `PROMCODE-server` directory:
   ```env
   SERVER_URI=bolt://localhost:7687
   NEO4J_USER=neo4j
   NEO4J_PASSWORD=your-password-here
   ```

2. **Set up the client**
   ```bash
   cd ../PROMCODE-client
   npm install
   ```

### Running Manually

1. **Start the Backend Server**
   ```bash
   cd PROMCODE-server
   node app.js
   ```

2. **Start the Frontend Client**
   ```bash
   cd PROMCODE-client
   npm run serve
   ```

## Usage

1. Open your browser and navigate to the frontend URL (usually `http://localhost:8080`)
2. Use the file selection interface to choose a Turtle (.ttl) file
3. Click submit to upload the file
4. The file will be uploaded to the server and imported into your Neo4j database

### Testing the Application

1. **Access the web interface**: Open http://localhost:8080 in your browser
2. **Upload a Turtle file**: Use the file upload interface to select and upload a `.ttl` file
3. **Monitor processing**: Check the server logs for processing status
4. **Verify in Neo4j**: Access Neo4j Browser at http://localhost:7474 (credentials: neo4j/password123)

### Sample Files

The project includes several sample Turtle files for testing:
- `neo4j-sample.ttl` - Basic RDF triples
- `project-resource.ttl` - Project-related data
- `promcode-example15.ttl` - PROMCODE-specific example
- `scopeitem-container.ttl` and `scopeitem-resource.ttl` - Scope item examples

### Neo4j Queries

After uploading files, you can query the data in Neo4j:

```cypher
// Show all nodes
MATCH (n) RETURN n LIMIT 25;

// Show all relationships
MATCH (n)-[r]->(m) RETURN n, r, m LIMIT 25;

// Show RDF resources
MATCH (r:Resource) RETURN r LIMIT 10;
```

## Sample Data

The project includes sample Turtle files in:
- `PROMCODE-client/upload/` - Sample files for testing
- `PROMCODE-server/turtle_sample/` - Additional sample files
- `PROMCODE-server/uploaded/` - Directory where uploaded files are stored

## API Endpoints

- `POST /` - Upload and process Turtle files
- `GET /` - Basic endpoint (currently logs query parameters)

## File Processing

When a Turtle file is uploaded:
1. The file is saved to the `PROMCODE-server/uploaded/` directory
2. The server calls the `register-turtle.js` module
3. The file is imported into Neo4j using the n10s plugin's `n10s.rdf.import.fetch` function

## Technologies Used

### Frontend
- Vue.js 2.6.11
- Axios for HTTP requests
- Vue CLI for development tools

### Backend
- Node.js
- Express.js
- Multer for file uploads
- Neo4j Driver
- dotenv for environment variables

### Database
- Neo4j 5.5 with neosemantics (n10s) plugin for RDF processing

## Makefile Commands

For easier Docker management, use the provided Makefile:

```bash
make up          # Start all services
make down        # Stop all services  
make restart     # Restart all services
make logs        # View logs from all services
make clean       # Remove containers and volumes
make neo4j-logs  # View Neo4j logs specifically
make server-logs # View server logs specifically
make client-logs # View client logs specifically
```

## Development

### Frontend Development
```bash
cd PROMCODE-client
npm run serve    # Development server with hot reload
npm run build    # Production build
npm run lint     # Linting
```

### Backend Development
The server uses standard Node.js. For development with auto-reload, you can install and use nodemon:

```bash
npm install -g nodemon
cd PROMCODE-server
nodemon app.js
```

### Manual Installation (Alternative to Docker)

If you prefer to run the components manually:

1. **Install Neo4j**:
   - Download Neo4j 5.5
   - Install the neosemantics plugin
   - Configure authentication (neo4j/password123)

2. **Server Setup**:
   ```bash
   cd PROMCODE-server
   npm install
   # Create .env file with NEO4J_URI, NEO4J_USER, NEO4J_PASSWORD
   npm start
   ```

3. **Client Setup**:
   ```bash
   cd PROMCODE-client
   npm install
   npm run serve
   ```

## System Status

### ✅ Successfully Deployed Components

| Service | Status | Port | Health Check |
|---------|--------|------|--------------|
| Neo4j 5.5 | ✅ Running | 7474, 7687 | Healthy with n10s plugin |
| PROMCODE Server | ✅ Running | 3000 | Online |
| PROMCODE Client | ✅ Running | 8080 | Accessible |
| Docker Network | ✅ Working | - | All services connected |

### What's Working
- ✅ Complete Docker stack deployment
- ✅ Neo4j with neosemantics (n10s) plugin
- ✅ File upload interface
- ✅ File storage and server processing
- ✅ RDF import from remote URLs
- ✅ Neo4j query interface
- ✅ Service orchestration with proper dependencies

### Testing Commands

```bash
# Start the application
make up

# Test file upload
curl -X POST -F "file=@PROMCODE-client/upload/neo4j-sample.ttl" http://localhost:3000/

# Test Neo4j connectivity
docker exec promcode-neo4j cypher-shell -a bolt://localhost:7687 -u neo4j -p password123 "MATCH (n) RETURN count(n);"

# Test RDF import from remote URL
docker exec promcode-neo4j cypher-shell -a bolt://localhost:7687 -u neo4j -p password123 "CALL n10s.rdf.import.fetch('https://github.com/neo4j-labs/neosemantics/raw/3.5/docs/rdf/nsmntx.ttl','Turtle');"
```

## Known Issues & Limitations

### 🔧 File Import Issue
- **Issue**: Local file imports via `file://` protocol not working due to container filesystem isolation
- **Current Status**: Remote URL imports work perfectly (tested and verified)
- **Workaround**: Use remote URLs for RDF imports
- **Potential Solutions**: 
  1. Modify server to copy files to Neo4j import directory
  2. Implement HTTP file serving endpoint
  3. Use different n10s import method

### Future Improvements
1. **File Import Fix**: Update register-turtle.js to handle local files in containerized environment
2. **Error Handling**: Add better error reporting in the UI
3. **Monitoring**: Add health check endpoints
4. **Security**: Implement proper authentication for production use

## Troubleshooting

### Common Issues

1. **Neo4j Connection Error**: Ensure Neo4j is running and the credentials in `.env` are correct
2. **n10s Plugin Error**: Make sure the neosemantics plugin is installed and properly configured
3. **File Upload Issues**: Check that the `uploaded/` directory exists and has write permissions
4. **CORS Issues**: The server includes basic CORS headers, but you may need to adjust them for production
5. **Neo4j connection refused**:
   - Ensure Neo4j container is healthy: `docker-compose ps`
   - Check Neo4j logs: `docker-compose logs neo4j`
6. **Port conflicts**:
   - Ensure ports 3000, 7474, 7687, and 8080 are not in use
   - Modify port mappings in `docker-compose.yml` if needed
7. **File upload errors**:
   - Check server logs: `docker-compose logs server`
   - Verify file permissions in the uploaded directory
8. **Neo4j plugin issues**:
   - Restart containers: `make restart`
   - Check n10s plugin status in Neo4j Browser

### Reset Everything

To completely reset the application:
```bash
make clean
make up
```

This removes all containers and volumes, then starts fresh.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with Docker setup
5. Submit a pull request

## License

This project is part of the Eclipse Lyo project.

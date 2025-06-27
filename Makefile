# PROMCODE Docker Management

.PHONY: help build up down clean logs restart neo4j-logs server-logs client-logs status

help: ## Show this help message
	@echo "PROMCODE Docker Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

build: ## Build all Docker images
	docker-compose build

up: ## Start all services
	docker-compose up -d

up-build: ## Build and start all services
	docker-compose up --build -d

down: ## Stop all services
	docker-compose down

clean: ## Remove containers and volumes
	docker-compose down -v
	docker system prune -f

logs: ## Show logs for all services
	docker-compose logs -f

logs-server: ## Show server logs
	docker-compose logs -f server

logs-client: ## Show client logs
	docker-compose logs -f client

logs-neo4j: ## Show Neo4j logs
	docker-compose logs -f neo4j

restart: ## Restart all services
	docker-compose restart

status: ## Show status of all containers
	docker-compose ps

shell-server: ## Open shell in server container
	docker-compose exec server sh

shell-neo4j: ## Open Cypher shell in Neo4j
	docker-compose exec neo4j cypher-shell -u neo4j -p password123

DATA_DIR := $(HOME)/data
# Extract domain name from .env file
DOMAIN_NAME := $(shell grep DOMAIN_NAME srcs/.env | cut -d '=' -f2)

.PHONY: all
all: up

.PHONY: prepare
prepare:
	mkdir -p $(DATA_DIR)/wordpress
	mkdir -p $(DATA_DIR)/mariadb
	sudo chown -R $(USER):$(USER) $(DATA_DIR)

.PHONY: set-hosts
set-hosts:
    @echo "Setting up domain name $(DOMAIN_NAME) in /etc/hosts..."
    @if grep -q "$(DOMAIN_NAME)" /etc/hosts; then \
        echo "Domain already in /etc/hosts"; \
    else \
        echo "Adding domain to /etc/hosts (requires sudo)"; \
        sudo sh -c "echo '127.0.0.1 $(DOMAIN_NAME)' >> /etc/hosts"; \
        echo "Domain $(DOMAIN_NAME) added to /etc/hosts"; \
    fi

.PHONY: up
up: prepare set-hosts
	docker compose -f srcs/docker-compose.yml up --build -d

.PHONY: down
down:
	docker compose -f srcs/docker-compose.yml down

.PHONY: restart
restart: down up

.PHONY: clean
clean: down
	docker system prune -a

.PHONY: fclean
fclean: clean
	sudo rm -rf $(DATA_DIR)
	docker volume prune -f

.PHONY: re
re: fclean up

.PHONY: logs
logs:
	docker compose -f srcs/docker-compose.yml logs

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  up        - Start containers"
	@echo "  down      - Stop containers" 
	@echo "  restart   - Restart containers"
	@echo "  clean     - Remove containers and images"
	@echo "  fclean    - Remove everything (containers, images, volumes, data)"
	@echo "  re        - Full rebuild (fclean + up)"
	@echo "  logs      - View container logs"
DATA_DIR := $(HOME)/data

.PHONY: all
all: up

.PHONY: prepare
prepare:
	mkdir -p $(DATA_DIR)/wordpress
	mkdir -p $(DATA_DIR)/mariadb
# sudo chown -R $(USER):$(USER) $(DATA_DIR)

.PHONY: up
up: prepare
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
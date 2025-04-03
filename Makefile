deploy:
	@echo "Preparazione del laboratorio..."
	@bash ./init.sh

test:
	@echo "Verifica dei container in esecuzione..."
	docker ps

spegni:
	@echo "Spegnimento dei container..."
	@docker ps -q | xargs -r sudo docker stop

clean:
	@echo "Pulizia completa del laboratorio..."
	@docker ps -q | xargs -r sudo docker stop
	@docker ps -aq | xargs -r sudo docker rm -f
	@docker images -q | xargs -r sudo docker rmi -f
	@docker volume ls -q | xargs -r sudo docker volume rm
	@for net in $(docker network ls --format '{{.Name}}' | grep -vE 'bridge|host|none'); do \
		if docker network inspect $$net > /dev/null 2>&1; then \
			echo "Rimuovo la rete: $$net"; \
			sudo docker network rm $$net; \
		else \
			echo "Rete non trovata: $$net"; \
		fi; \
	done
	@sudo docker system prune -a --volumes -f || true

rebuild:
	@echo "Ricostruzione del laboratorio..."
	@sudo docker compose down --volumes --remove-orphans || true
	@sudo docker compose up -d --build

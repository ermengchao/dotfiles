CONTAINER=nginx

up:
	sudo docker compose up -d

down:
	sudo docker compose down

logs:
	sudo docker compose logs -f $(CONTAINER)

restart:
	sudo docker restart $(CONTAINER)

test:
	sudo docker exec -it $(CONTAINER) nginx -t

reload:
	sudo docker exec -it $(CONTAINER) nginx -s reload

shell:
	sudo docker exec -it $(CONTAINER) /bin/sh
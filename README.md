# docker-cassandra

Runs cassandra with reasonable memory for development (~450MB instead of the
default ~6GB), and with much faster I/O (using
[eatmydata](https://www.flamingspork.com/projects/libeatmydata/), so expect data
loss if you pull the plug).

## Usage

Check out this repository.

Pull the image:

	docker-compose pull

Run Cassandra in the background:

	docker-compose up -d

Check logs:

	docker-compose logs

Run a CQL shell:
	
	./cqlsh

Wipe all data:

	docker-compose down
	docker volume rm dockercassandra_data

# Apache Spark Graphframes and Docker
This project allows you build and run a Docker Image that contains a version of Apache Spark and the necessary dependencies to allow you to run Spark Graphframes using pyspark.

## Building the Image
Run the following command from the main project folder to build the image:

`docker build --rm -f "Dockerfile" -t test_docker_spark:latest .`

Next, list the available docker images:

`docker images`

## Running the Image interactively
To the run the Image interactively and get playing with Spark on Ubuntu run:

`docker run --rm -it test_docker_spark:latest`

## Running pyspark from within the Image
To get an interactive instance of pyspark running in the image, which includes the graphframes package, run the following:

`pyspark --packages graphframes:graphframes:0.6.0-spark2.3-s_2.11`

(*Note* that the $SPARK_HOME environment variable is available)

## example1.py
Based on the databricks Graphframes tutorial found at https://docs.databricks.com/spark/latest/graph-analysis/graphframes/graph-analysis-tutorial.html#build-the-graph this python script should be run interactively from within the interactive pyspark session started in the previous step

*N.B.* you might need to cut down the file /data/examples/201508_trip_data.csv to a few tens of thousands of trips, to avoid the image running out of memory (or if you are smarter at using docker than I am, provide more resources to the image)
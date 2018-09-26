from graphframes import *

#LOAD DATAFRAMES
bikeStations = spark.read.csv("/data/examples/201508_station_data.csv", header=True)
tripData = spark.read.csv("/data/examples/201508_trip_data.csv", header=True)

#CREATE VERTICES AND EDGES
stationVertices = bikeStations.withColumnRenamed("name", "id").distinct()
tripEdges = tripData.withColumnRenamed("Start Station", "src").withColumnRenamed("End Station", "dst")

#CREATE THE GRAPH
stationGraph = GraphFrame(stationVertices, tripEdges)

#A FEW COUNTS TO CHECK
stationGraph.vertices.count()
stationGraph.edges.count()
tripData.count()

#PAGE RANK
results = stationGraph.pageRank(resetProbability=0.15, maxIter=10)

results.vertices.show()

results.vertices.orderBy("pagerank").show()

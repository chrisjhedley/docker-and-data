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

#IN DEGREES

from pyspark.sql.functions import desc

inDeg = stationGraph.inDegrees
inDeg.orderBy(desc("inDegree")).show(5, False)

#OUT DEGREES

outDeg = stationGraph.outDegrees
outDeg.orderBy(desc("outDegree")).show(5, False)

#DEGREE RATIO
degreeRatio = inDeg.join(outDeg, "id") \
.selectExpr("id", "double(inDegree)/double(outDegree) as degreeRatio")

degreeRatio.orderBy(desc("degreeRatio")).show(10, False)

degreeRatio.orderBy("degreeRatio").show(10, False)

#MOTIF FINDING (p. 517)
motifs = stationGraph.find("(a)-[ab]->(b); (b)-[bc]->(c); (c)-[ca]->(a)")

from pyspark.sql.functions import expr
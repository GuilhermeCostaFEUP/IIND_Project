#!/usr/bin/sh

echo "
# This file is part of ShopFloorSimulator.
# 
# ShopFloorSimulator is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# ShopFloorSimulator is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with ShopFloorSimulator.  If not, see <http://www.gnu.org/licenses/>.


#### Para gravar simulações...
####  java -jar sfs.jar --record teste1
####  java -jar sfs.jar --playback teste1


#### Imprimir ficheiro com os ids dos sensores todos.
####  java -jar sfs.jar --map ficheiro.txt
####  java -jar sfs.jar --csv teste.csv




#Size of factory in meters
configuration.width = 28
configuration.height = 36

#Floor color
floor.color = 55AA33

#How many meters one pixel represents
configuration.pixelsize = 0.05
#Block size in meters
configuration.blocksize = 1

#Radius of conveyor middle sensors in meters
configuration.sensorradius = 0.5

#Miliseconds between each simulation step
configuration.simulationtime = 20

#Miliseconds before error occurs when forcing
configuration.errortime = 2000

#Miliseconds before piece on the floor disappears
configuration.floortime = 2000

#Conveyor speed in meters/second
configuration.conveyorspeed = 4
configuration.conveyorspeeddelta = 0

#Rotator rotation speed in degrees/second
configuration.rotationspeed = 180

#Pusher speed in meters/second
configuration.pushspeed = 1

#Machine tool rotation speed in degrees/second
configuration.toolrotationspeed = 4

#Machine tool move speed in meters/second
configuration.toolmovespeed = 0.05

#Modbus Port
configuration.port = 5502
#Set to true if you want to use address 127.0.0.1
configuration.loopback = true
#configuration.loopback = false

#Blocktypes

blocktype.1.name = P1
blocktype.1.color = 8B4513
blocktype.1.shape = rounded
#blocktype.1.shape = circle
#blocktype.1.shape = square

blocktype.2.name = P2
blocktype.2.color = FF0000
blocktype.2.shape = rounded

blocktype.3.name = P3
blocktype.3.color = F88017
blocktype.3.shape = rounded

blocktype.4.name = P4
blocktype.4.color = FFFF00
blocktype.4.shape = rounded

blocktype.5.name = P5
blocktype.5.color = 00FF00
blocktype.5.shape = rounded

blocktype.6.name = P6
blocktype.6.color = 1E90FF
blocktype.6.shape = rounded

blocktype.7.name = P7
blocktype.7.color = FF00FF
blocktype.7.shape = rounded

blocktype.8.name = P8
blocktype.8.color = 888888
blocktype.8.shape = rounded

blocktype.9.name = P9
blocktype.9.color = FFFFFF
blocktype.9.shape = rounded

blocktype.10.name = P10
blocktype.10.color = 8EF6FF
blocktype.10.shape = rounded

blocktype.11.name = P11
blocktype.11.color = FFB3B3
blocktype.11.shape = rounded


#################
#    Tools      #
#################
tool.1.color = 880000
tool.2.color = 008800
tool.3.color = 000088
tool.4.color = FF8888
tool.5.color = 88FF88
tool.6.color = 8888FF
#tool.7.color = 008888
#tool.8.color = 880088
#tool.9.color = 888800



#Transformations (tool number, initial block type, final block type and duration in miliseconds)
"
TID=0

TID=$((TID+1))
echo "
transformation.$(( TID )).initial  = 1
transformation.$(( TID )).final    = 3
transformation.$(( TID )).tool     = 1
transformation.$(( TID )).duration = 20000
"
TID=$((TID+1))
echo "
transformation.$(( TID )).initial  = 3
transformation.$(( TID )).final    = 4
transformation.$(( TID )).tool     = 2
transformation.$(( TID )).duration = 20000
"
TID=$((TID+1))
echo "
transformation.$(( TID )).initial  = 4
transformation.$(( TID )).final    = 5
transformation.$(( TID )).tool     = 3
transformation.$(( TID )).duration = 45000
"
TID=$((TID+1))
echo "
transformation.$(( TID )).initial  = 5
transformation.$(( TID )).final    = 8
transformation.$(( TID )).tool     = 4
transformation.$(( TID )).duration = 45000
"
TID=$((TID+1))
echo "
transformation.$(( TID )).initial  = 5
transformation.$(( TID )).final    = 7
transformation.$(( TID )).tool     = 6
transformation.$(( TID )).duration = 30000
"
TID=$((TID+1))
echo "
transformation.$(( TID )).initial  = 8
transformation.$(( TID )).final    = 6
transformation.$(( TID )).tool     = 5
transformation.$(( TID )).duration = 30000
"
TID=$((TID+1))
echo "
transformation.$(( TID )).initial  = 2
transformation.$(( TID )).final    = 9
transformation.$(( TID )).tool     = 6
transformation.$(( TID )).duration = 15000
"
TID=$((TID+1))
echo "
transformation.$(( TID )).initial  = 9
transformation.$(( TID )).final    = 10
transformation.$(( TID )).tool     = 5
transformation.$(( TID )).duration = 20000
"
TID=$((TID+1))
echo "
transformation.$(( TID )).initial  = 9
transformation.$(( TID )).final    = 11
transformation.$(( TID )).tool     = 1
transformation.$(( TID )).duration = 30000
"
TID=$((TID+1))
echo "
transformation.$(( TID )).initial  = 4
transformation.$(( TID )).final    = 9
transformation.$(( TID )).tool     = 2
transformation.$(( TID )).duration = 20000
"


echo "
#########################################
#                                       #
#  Facility types: conveyor,            #
#                  rotator,             #
#                  rail,                #
#                  warehousein,         #
#                  warehouseout,        #
#                  machine              #
#                                       #
#########################################
"

ID=0
WID=0


Xoff=0
Yoff=1
echo "
#########################
# Plate Load            #
# Loading Docks         #
#########################
"
# a 'virtual' warehouse, representing the suppliers that will supply the raw materials
WID=$((WID+1))
echo "
warehouse.$(( WID )).show = false
warehouse.$(( WID )).length = 1
warehouse.$(( WID )).width = 1
warehouse.$(( WID )).orientation = horizontal
warehouse.$(( WID )).center.x = $(( $Xoff + 1 ))
warehouse.$(( WID )).center.y = $(( $Yoff + 1 ))
warehouse.$(( WID )).block.1.stock = 10000
warehouse.$(( WID )).block.2.stock = 10000
warehouse.$(( WID )).block.3.stock = 0
warehouse.$(( WID )).block.4.stock = 0
warehouse.$(( WID )).block.5.stock = 0
warehouse.$(( WID )).block.6.stock = 0
warehouse.$(( WID )).mintime = 0
warehouse.$(( WID )).maxtime = 0
"

ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 6 ))
facility.$(( ID )).center.y = $(( $Yoff + 2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = Cin1
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 10 ))
facility.$(( ID )).center.y = $(( $Yoff +  2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = Cin2
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 14 ))
facility.$(( ID )).center.y = $(( $Yoff +  2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = Cin3
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 18 ))
facility.$(( ID )).center.y = $(( $Yoff +  2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = Cin4
"



Xoff=0
Yoff=4
echo "
#########################
# Plate W1              #
# Warehouse             #
#########################
"
WID=$((WID+1))
echo "
warehouse.$(( WID )).show = true
warehouse.$(( WID )).length = 26
warehouse.$(( WID )).width = 2
warehouse.$(( WID )).orientation = horizontal
warehouse.$(( WID )).center.x = $(( $Xoff + 1 + 13 ))
warehouse.$(( WID )).center.y = $(( $Yoff +      4 ))
warehouse.$(( WID )).block.1.stock = 0
warehouse.$(( WID )).block.2.stock = 0
warehouse.$(( WID )).block.3.stock = 0
warehouse.$(( WID )).block.4.stock = 0
warehouse.$(( WID )).block.5.stock = 0
warehouse.$(( WID )).block.6.stock = 0
warehouse.$(( WID )).mintime = 1000
warehouse.$(( WID )).maxtime = 1000
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehousein
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 2 ))
facility.$(( ID )).center.y = $(( $Yoff + 6 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT1_in0
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehousein
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 6 ))
facility.$(( ID )).center.y = $(( $Yoff + 2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT1_in1
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehousein
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 10 ))
facility.$(( ID )).center.y = $(( $Yoff +  2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT1_in2
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehousein
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 14 ))
facility.$(( ID )).center.y = $(( $Yoff +  2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT1_in3
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehousein
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 18 ))
facility.$(( ID )).center.y = $(( $Yoff +  2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT1_in4
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff +  6 ))
facility.$(( ID )).center.y = $(( $Yoff +  6 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT1_out1
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff +  10 ))
facility.$(( ID )).center.y = $(( $Yoff +  6 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT1_out2
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff +  14 ))
facility.$(( ID )).center.y = $(( $Yoff +  6 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT1_out3
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff +  18 ))
facility.$(( ID )).center.y = $(( $Yoff +  6 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT1_out4
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff +  22 ))
facility.$(( ID )).center.y = $(( $Yoff +  6 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT1_out5
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff +  26 ))
facility.$(( ID )).center.y = $(( $Yoff +  6 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT1_out6
"


Xoff=0
Yoff=22
echo "
#########################
# Plate W2              #
# Warehouse             #
#########################
"
WID=$((WID+1))
echo "
warehouse.$(( WID )).show = true
warehouse.$(( WID )).length = 26
warehouse.$(( WID )).width = 2
warehouse.$(( WID )).orientation = horizontal
warehouse.$(( WID )).center.x = $(( $Xoff + 1 + 13 ))
warehouse.$(( WID )).center.y = $(( $Yoff +      4 ))
warehouse.$(( WID )).block.1.stock = 0
warehouse.$(( WID )).block.2.stock = 0
warehouse.$(( WID )).block.3.stock = 0
warehouse.$(( WID )).block.4.stock = 0
warehouse.$(( WID )).block.5.stock = 0
warehouse.$(( WID )).block.6.stock = 0
warehouse.$(( WID )).block.7.stock = 0
warehouse.$(( WID )).block.8.stock = 0
warehouse.$(( WID )).block.9.stock = 0
warehouse.$(( WID )).mintime = 1000
warehouse.$(( WID )).maxtime = 1000
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 2 ))
facility.$(( ID )).center.y = $(( $Yoff + 2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT2_out0
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 6 ))
facility.$(( ID )).center.y = $(( $Yoff + 6 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT2_out1
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 10 ))
facility.$(( ID )).center.y = $(( $Yoff + 6 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT2_out2
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 14 ))
facility.$(( ID )).center.y = $(( $Yoff + 6 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT2_out3
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehouseout
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff + 18 ))
facility.$(( ID )).center.y = $(( $Yoff + 6 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT2_out4
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehousein
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff +  6 ))
facility.$(( ID )).center.y = $(( $Yoff +  2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT2_in1
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehousein
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff +  10 ))
facility.$(( ID )).center.y = $(( $Yoff +  2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT2_in2
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehousein
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff +  14 ))
facility.$(( ID )).center.y = $(( $Yoff +  2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT2_in3
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehousein
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff +  18 ))
facility.$(( ID )).center.y = $(( $Yoff +  2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT2_in4
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehousein
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff +  22 ))
facility.$(( ID )).center.y = $(( $Yoff +  2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT2_in5
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = warehousein
facility.$(( ID )).length = 2
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff +  26 ))
facility.$(( ID )).center.y = $(( $Yoff +  2 ))
facility.$(( ID )).warehouse = $(( WID ))
facility.$(( ID )).alias = AT2_in6
"


Xoff=2
Yoff=13
Cell=0
echo "
#########################
# Plate $Cell               #
# Serial Conveyors      #
#########################
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = conveyor
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +   0 ))
facility.$(( ID )).alias = Cell$(( Cell ))_Ctop
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = conveyor
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  4 ))
facility.$(( ID )).alias = Cell$(( Cell ))_Cmid
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = conveyor
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  8 ))
facility.$(( ID )).alias = Cell$(( Cell ))_Cbot
"


Xoff=6
Yoff=13
Cell=1
echo "
#########################
# Plate $Cell               #
# Serial Machines       #
#########################
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = machine
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +   0 ))
facility.$(( ID )).tool1 = 1
facility.$(( ID )).tool2 = 2
facility.$(( ID )).tool3 = 3
facility.$(( ID )).alias = Cell$(( Cell ))_Mtop
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = conveyor
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  4 ))
facility.$(( ID )).alias = Cell$(( Cell ))_Cmid
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = machine
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  8 ))
facility.$(( ID )).tool1 = 2
facility.$(( ID )).tool2 = 3
facility.$(( ID )).tool3 = 4
facility.$(( ID )).alias = Cell$(( Cell ))_Mbot
"


Xoff=10
Yoff=13
Cell=2
echo "
#########################
# Plate $Cell               #
# Serial Machines       #
#########################
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = machine
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +   0 ))
facility.$(( ID )).tool1 = 2
facility.$(( ID )).tool2 = 3
facility.$(( ID )).tool3 = 4
facility.$(( ID )).alias = Cell$(( Cell ))_Mtop
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = conveyor
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  4 ))
facility.$(( ID )).alias = Cell$(( Cell ))_Cmid
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = machine
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  8 ))
facility.$(( ID )).tool1 = 3
facility.$(( ID )).tool2 = 4
facility.$(( ID )).tool3 = 5
facility.$(( ID )).alias = Cell$(( Cell ))_Mbot
"


Xoff=14
Yoff=13
Cell=3
echo "
#########################
# Plate $Cell               #
# Serial Machines       #
#########################
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = machine
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +   0 ))
facility.$(( ID )).tool1 = 3
facility.$(( ID )).tool2 = 4
facility.$(( ID )).tool3 = 5
facility.$(( ID )).alias = Cell$(( Cell ))_Mtop
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = conveyor
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  4 ))
facility.$(( ID )).alias = Cell$(( Cell ))_Cmid
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = machine
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  8 ))
facility.$(( ID )).tool1 = 4
facility.$(( ID )).tool2 = 5
facility.$(( ID )).tool3 = 6
facility.$(( ID )).alias = Cell$(( Cell ))_Mbot
"


Xoff=18
Yoff=13
Cell=4
echo "
#########################
# Plate $Cell               #
# Serial Machines       #
#########################
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = machine
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +   0 ))
facility.$(( ID )).tool1 = 4
facility.$(( ID )).tool2 = 5
facility.$(( ID )).tool3 = 6
facility.$(( ID )).alias = Cell$(( Cell ))_Mtop
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = conveyor
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  4 ))
facility.$(( ID )).alias = Cell$(( Cell ))_Cmid
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = machine
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  8 ))
facility.$(( ID )).tool1 = 5
facility.$(( ID )).tool2 = 6
facility.$(( ID )).tool3 = 1
facility.$(( ID )).alias = Cell$(( Cell ))_Mbot
"


Xoff=22
Yoff=13
Cell=5
echo "
#########################
# Plate $Cell               #
# Serial Machines       #
#########################
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = machine
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +   0 ))
facility.$(( ID )).tool1 = 5
facility.$(( ID )).tool2 = 6
facility.$(( ID )).tool3 = 1
facility.$(( ID )).alias = Cell$(( Cell ))_Mtop
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = conveyor
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  4 ))
facility.$(( ID )).alias = Cell$(( Cell ))_Cmid
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = machine
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  8 ))
facility.$(( ID )).tool1 = 6
facility.$(( ID )).tool2 = 1
facility.$(( ID )).tool3 = 2
facility.$(( ID )).alias = Cell$(( Cell ))_Mbot
"


Xoff=26
Yoff=13
Cell=6
echo "
#########################
# Plate $Cell               #
# Serial Machines       #
#########################
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = machine
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +   0 ))
facility.$(( ID )).tool1 = 6
facility.$(( ID )).tool2 = 1
facility.$(( ID )).tool3 = 2
facility.$(( ID )).alias = Cell$(( Cell ))_Mtop
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = conveyor
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  4 ))
facility.$(( ID )).alias = Cell$(( Cell ))_Cmid
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = machine
facility.$(( ID )).length = 4
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff +  8 ))
facility.$(( ID )).tool1 = 1
facility.$(( ID )).tool2 = 2
facility.$(( ID )).tool3 = 3
facility.$(( ID )).alias = Cell$(( Cell ))_Mbot
"




Xoff=6
Yoff=29
Cell=1
echo "
#########################
# Plate $Cell               #
# Output Rollers        #
#########################
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 0 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))a
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 1 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))b
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 2 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))c
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 3 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))d
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 4 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))e
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = conveyor
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 5 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))f
"




Xoff=10
Yoff=29
Cell=2
echo "
#########################
# Plate $Cell               #
# Output Rollers        #
#########################
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 0 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))a
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 1 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))b
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 2 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))c
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 3 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))d
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 4 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))e
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = conveyor
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 5 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))f
"




Xoff=14
Yoff=29
Cell=3
echo "
#########################
# Plate $Cell               #
# Output Rollers        #
#########################
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 0 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))a
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 1 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))b
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 2 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))c
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 3 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))d
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 4 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))e
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = conveyor
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 5 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))f
"




Xoff=18
Yoff=29
Cell=4
echo "
#########################
# Plate $Cell               #
# Output Rollers        #
#########################
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 0 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))a
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 1 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))b
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 2 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))c
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 3 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))d
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = roller
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 4 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))e
"
ID=$((ID+1))
echo "
facility.$(( ID )).type = conveyor
facility.$(( ID )).length = 1
facility.$(( ID )).width = 2
facility.$(( ID )).orientation = vertical
facility.$(( ID )).center.x = $(( $Xoff ))
facility.$(( ID )).center.y = $(( $Yoff + 5 )).5
facility.$(( ID )).direction = 1
facility.$(( ID )).sensors = 1
facility.$(( ID )).alias = Roll$((Cell))f
"

`me_update(pos,event)` reveives an event table,  
it may contain the following values:
* type: string can be:
  * n/a event type was not given
  * connect a new machine was added to the network
  * disconnect a machine was or will be removed from the network
  * item_cap the item capacity if the network changed
  * items the items within the network changed
* origin: table
  * pos: table (vector) the position of the sender
  * name: string the itemstring of the sender
  * type: string the machine type of the sender
* net: network (optional)
* payload: any, mostly table

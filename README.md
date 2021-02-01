# Cab Problem API's
## SETUP: 
### Requirements:

Ruby Version 2.5.0 required
https://www.postgresql.org/download/ PostgreSql

Go in terminal to the location where project installed
Run Commands 
bundle install
rake db:create
rake db:migrate
rake db:seed 
rails s

On running these command we are ready to run the api’s 

DRIVER API

POST: http://127.0.0.1:3000/api/v1/drivers

#### INPUT: 
```json
{
   "driver": {
       "mobile_number": "2132434312",
       "full_name": "test driver"
   }
}
``` 
#### OUTPUT: 

```json
{
   "data": {
           "id": 1,
           "mobile_number": "2132434312",
           "full_name": "test driver",
           "rides": [],
           "rating": 5.0,
           "is_active": true
       },
   "error": []
}
``` 

GET :http://127.0.0.1:3000/api/v1/drivers?by_name=test&by_mobile_number=2132434312

Filters by_name and by_mobile_number are optional

```json
Output: 
{
   "data": [
       {
           "id": 1,
           "mobile_number": "2132434312",
           "full_name": "test driver",
           "rides": [],
           "rating": 5.0,
           "is_active": true
       }
   ],
   "error": []
}
```

PUT: http://127.0.0.1:3000/api/v1/drivers

INPUT: 

```json
{
    "driver": {
        "id": 1,
        "mobile_number": "2132434312",
        "full_name": "testing driver"
    }
}
```

OUTPUT:

```json
{
   "data": {
           "id": 1,
           "mobile_number": "2132434312",
           "full_name": "testing driver",
           "rides": [],
           "rating": 5.0,
           "is_active": true
       },
   "error": []
}
```
 
### CUSTOMER API’S

POST: http://127.0.0.1:3000/api/v1/customers

```json
Input:
{
   "customer": {
       "full_name": "Test Customer",
       "mobile_number": "7395945998",
       "customer_plan_id": 1
   }
}
```
Output:

```
{
   "data": {
       "id": 2,
       "mobile_number": "7395945998",
       "plan": "Silver",
       "full_name": "Test Customer",
       "rides": []
   },
   "error": []
}
```
 
GET: http://127.0.0.1:3000/api/v1/customers?by_name=Test&by_mobile_number=
 
By_name and by_mobile_number both filter optional
```json
{
   "data": [
       {
           "id": 1,
           "mobile_number": "7395945991",
           "plan": "Silver",
           "full_name": "Test Customer",
           "rides": []
       },
       {
           "id": 2,
           "mobile_number": "7395945998",
           "plan": "Silver",
           "full_name": "Test Customer",
           "rides": []
       }
   ],
   "error": []
}
 ```
PUT: http://127.0.0.1:3000/api/v1/customers
Input:
```json
{
   "customer": {
       "full_name": "Ride Test Customer",
       "customer_plan_id": 2,
       "id": 1
   }
}
```
Output:
```json
{
   "data": {
       "id": 1,
       "mobile_number": "7395945991",
       "plan": "Gold",
       "full_name": "Ride Test Customer",
       "rides": []
   },
   "error": []
}
``` 
 
 
Rides
 
POST: http://127.0.0.1:3000/api/v1/rides
 
Input:
```json
{
   "customer_mobile_number": "7395945991"
}
``` 
Output:
```json
{
   "data": {
       "id": 2,
       "ride_number": 102,
       "customer_name": "Ride Test Customer",
       "driver_name": "New Driver",
       "distance_travelled": null,
       "is_cancelled_before_start": false,
       "is_cancelled_after_start": false,
       "rating": null,
       "travel_time": null,
       "start_time": null,
       "end_time": null,
       "waiting_time": null,
       "rate_per_km": null,
       "surge_amount": null,
       "status": "confirmed",
       "total_fair": null
   },
   "error": []
}
```

PUT: http://127.0.0.1:3000/api/v1/rides
 
Input:
```json
{
   "cab_trip_id": 1,
   "distance_travelled": 10,
   "surge": 1,
   "start_time": "12-01-2021 15:00", (format: dd-mm-yyyy HH-MM)
   "end_time": "12-01-2021 15:31",
   "waiting_time": 6.7,
   "rate_per_km": 4,
}
```
If is_cancelled_after_start than Input
```json
{
  "cab_trip_id": 1,
  "distance_travelled": 10,
  "surge": 1,
  "start_time": "12-01-2021 15:00",
  "is_cancelled_after_start": true,
  "end_time": "12-01-2021 15:31",
  "waiting_time": 6.7,
  "rate_per_km": 4
}
```
Output:
```json
{
   "data": {
       "id": 1,
       "ride_number": 101,
       "customer_name": "Test Customer",
       "driver_name": "testing driver",
       "distance_travelled": 10.0,
       "is_cancelled_before_start": false,
       "is_cancelled_after_start": false,
       "rating": null,
       "travel_time": 31,
       "start_time": "2021-01-12T15:00:00.000+05:30",
       "end_time": "2021-01-12T15:31:00.000+05:30",
       "waiting_time": 6,
       "rate_per_km": 4.0,
       "surge_amount": 1.0,
       "status": "completed",
       "total_fair": 119.0
   },
   "error": []
}
``` 
 
 
 
 
Rating Ride
 
PUT: http://127.0.0.1:3000/api/v1/rate_driver
Input:
```json
{
  "cab_trip_id": 1,
  "rating": 4.5
}
``` 
Output:
```json
{
   "data": [
       "Thanks for riding with us"
   ],
   "error": []
}
json 
 
 
 
 
 
 
FOR CANCELLED BEFORE START:

Input:

```json
{
   "is_cancelled_before_start": true,
   "cab_trip_id": 2,
   "waiting_time": 6.7
}
```
Output:
```json
{
   "data": {
       "id": 2,
       "ride_number": 102,
       "customer_name": "Ride Test Customer",
       "driver_name": "New Driver",
       "distance_travelled": null,
       "is_cancelled_before_start": false,
       "is_cancelled_after_start": false,
       "rating": null,
       "travel_time": null,
       "start_time": null,
       "end_time": null,
       "waiting_time": 6,
       "rate_per_km": null,
       "surge_amount": null,
       "status": "cancelled",
       "total_fair": 50.0
   },
   "error": []
}
``` 
Rides Listing
All filters optional
GET: http://127.0.0.1:3000/api/v1/rides?by_customer=2&by_driver=3&by_start_date=12-01-2021&by_end_date=12-01-2021&by_ride_number=101
```json 
{
   "data": [
       {
           "id": 1,
           "ride_number": 101,
           "customer_name": "Rep. Jill Kunze",
           "driver_name": "DriverCC",
           "distance_travelled": 10.0,
           "is_cancelled_before_start": false,
           "is_cancelled_after_start": false,
           "rating": 3.0,
           "travel_time": 31,
           "start_time": "2021-01-12T15:00:00.000+05:30",
           "end_time": "2021-01-12T15:31:00.000+05:30",
           "waiting_time": 6,
           "rate_per_km": 4.0,
           "surge_amount": 1.0,
           "status": "completed",
           "total_fair": 119.0
       }
   ],
   "error": []
}
 ```
 
 
 
 
 


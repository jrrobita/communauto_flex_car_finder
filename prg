#attribution: from user ExtraEponge on reddit - merci!

# install packages that you may not have
pip install geopy
pip install mac_say

#import packages
import requests
from geopy.distance import geodesic
import mac_say
import platform
import time

# Input: Maximum distance that I'm willing to walk to get this communauto (in meters)
maxDist = 5000
# Input: Refresh rate for the search query in seconds (currently every 10 seconds)
refreshRate = 10

# Input: My current latitude and longitude
myLat = <insert value>
myLong = <insert value>

orig = (myLat, myLong)

#section to run call to communauto api 
found = False
while found == False:
    fullRes = requests.get('https://www.reservauto.net/WCF/LSI/LSIBookingServiceV3.svc/GetAvailableVehicles?BranchID=1&LanguageID=1')
    jsonRes = fullRes.json()
    for vehicle in jsonRes['d']['Vehicles']:
        dest = (vehicle['Latitude'],vehicle['Longitude'])
        dist = geodesic(orig, dest).meters
        if dist < maxDist:
            text = "J'ai trouvé une Communauto avec le numéro "+ str(vehicle['CarNo']) + " à "+ str(int(dist)) + " mètres."
            print(text)
            if platform.system() == "Darwin":
                mac_say.say(text)
            found = True
    if found == False:
        print("No car found, will refresh")
        time.sleep(refreshRate)

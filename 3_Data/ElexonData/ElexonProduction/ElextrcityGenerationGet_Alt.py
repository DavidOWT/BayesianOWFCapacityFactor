# -*- coding: utf-8 -*-
"""
- Created on Sun Sep  6 22:23:35 2020
- Updarted 06/10/20 - Fixed final date and fixed mean power calculation

@author: David Wilkie
"""


#! /usr/bin/env python

import io
import pandas as pd
import numpy as np
import httplib2

#   Old unused libaries
# import csv
# from datetime import datetime
# from pprint import pformat
# pretty print
# pformat returns the formatted representation of object as a string


# Main function
def main():
    ##  Import farm name (unitID) and start dates
    offshoreWindFarms = pd.read_excel("ElexonOWFList.xlsx")

    dateInitial = offshoreWindFarms["Date Added"]
    farmName = offshoreWindFarms["Generator Name"]


    ##  Loop over each farm
    for i in np.arange(36,farmName.size):        # range(farmName.size)
        #   Define wind farm and it's start date
        dataInitialLoop = dateInitial[i].date()
        farmNameLoop = farmName[i]

        #   Date range
        date1 = dataInitialLoop.strftime("%Y-%m-%d")
        date2 = '2020-08-01'
        datelist = pd.date_range(date1, date2).tolist()

        #   Number of days
        energyData = np.zeros(len(datelist))
        indEn = 0

        for dateVal in datelist:
            keyAPI="2cj9m5l9x9z8thl"

            # Inputs for testing
            #settleDate="2016-04-11"
            #unitID = "BOWLW-1"
            
            # Inputs for running
            settleDate=dateVal.strftime("%Y-%m-%d")
            unitID=farmNameLoop
            
            period="*"
            serviceType="csv"
         
            content = post_elexon(
                url='https://api.bmreports.com/BMRS/B1610/v2?APIKey='+keyAPI+'&SettlementDate='+settleDate+'&Period='+period+'&NGCBMUnitID='+unitID+'&ServiceType='+serviceType)

            # Do something if content is empty TODO


            # Write content
            writeData = content.decode(encoding="utf-8", errors="strict")

            if writeData[118:128] == 'No Content':
                indEn =indEn+1
            else:
                writeDataForm = io.StringIO(writeData[54:-1])

                df = pd.read_csv(writeDataForm, sep=",", header=0)

                # Timeseries IDs do not overlap
                rawQuantityMW = df.loc[:,'Quantity (MW)'].to_numpy()
                timeSeriesID = df.loc[:,'ime Series ID'].to_numpy()
                
                [tsUni, tsUniInd] = np.unique(timeSeriesID, return_index= True)
                                
                cleanQuantityMW = rawQuantityMW[tsUniInd]

                energyData[indEn] = np.sum(cleanQuantityMW)/2
                # Each day has 48 settlement periods
                
                indEn =indEn+1

        # save results
        # energyData datelist farmNameLoop
        outputData = pd.concat([pd.DataFrame(datelist), pd.DataFrame(energyData)], axis=1, sort=False)
        outputData.to_csv('Results_'+farmNameLoop+'.csv', date_format="%Y-%m-%d", header=['Date', 'Power Gen MW'])

        status= "Loop %i of %i completed" % (i, farmName.size)
        print(status)

# Function to get data
def post_elexon(url):
    http_obj = httplib2.Http()

    resp, content = http_obj.request(
        uri=url,
        method='GET',
        headers={'Content-Type': 'application/xml; charset=UTF-8'},
    )

    return content  # a string from the server

# Call main function
if __name__ == "__main__":
    main()
    
    


//
//  DatabaseConstants.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/15/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//
/**
 * This file includes the URLs that the network poller and the patient information VC
 * will use to reach the remote server.
 */

#ifndef Medical_Cyborgs_DatabaseConstants_h
#define Medical_Cyborgs_DatabaseConstants_h

//#define PATIENTID_BASE_URL @"http://192.168.1.113/testpatient.php?" // home test
#define PATIENTID_BASE_URL @"http://172.31.99.52/testpatient.php?"   // coffee shop test
//#define PATIENTID_BASE_URL @"http://192.168.6.153/testpatient.php?"
//#define PATIENTID_BASE_URL @"HTTP://10.91.2.38/testpatient.php?"

//#define INSERT_DB_BASE_URL @"http://192.168.1.113/addmeasurement.php?"
#define INSERT_DB_BASE_URL @"http://172.31.99.52/addmeasurement.php?"
//#define INSERT_DB_BASE_URL @"http://192.168.6.153/addmeasurement.php?"
//#define INSERT_DB_BASE_URL @"http://10.91.2.38/addmeasurement.php?"

#endif

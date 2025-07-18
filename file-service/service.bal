// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//
// AUTO-GENERATED FILE.
// This file is auto-generated by Ballerina.

import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/time;
import ballerina/uuid;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;

configurable BulkExportServerConfig exportServiceConfig = ?;

// This is used to connect to fhir service
http:Client fhirServiceClient = check new (exportServiceConfig.fhirServerBaseUrl);

service /bulk on new http:Listener(8090) {

    isolated resource function post export(international401:Parameters parameters) returns r4:FHIRError|http:Response|error {

        string exportTaskId = uuid:createType1AsString();
        international401:ParametersParameter[]? selectedPatients = parameters.'parameter;
        if selectedPatients is international401:ParametersParameter[] {
            string? patientId = selectedPatients[0]?.valueReference?.reference;
            if patientId is string {
                log:printDebug(string `Exporting data for ID: ${patientId}`);
                error? executionResult = executeJob(exportTaskId, exportServiceConfig, patientId);
                if executionResult is error {
                    log:printError("Error occurred: ", executionResult);
                    return r4:createFHIRError("Server Error", r4:ERROR, r4:PROCESSING, httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR);
                }
                addExportTasktoMemory(exportTaskId, time:utcNow());
            }
        }

        http:Response response = new;
        response.statusCode = http:STATUS_ACCEPTED;
        response.setHeader(CONTENT_LOCATION, exportServiceConfig.fileServerBaseUrl + "/status/" + exportTaskId);
        response.setHeader(CONTENT_TYPE, "application/fhir+json");    
        r4:OperationOutcome outcome = createOpereationOutcome("information", "processing",
                "Your request has been accepted. You can check its status at " + exportServiceConfig.fileServerBaseUrl + "/status/" + exportTaskId);
        response.setPayload(outcome);
        return response;
    }

    isolated resource function get status/[string exportTaskId]() returns json|r4:FHIRError|http:Response {
        ExportTask|error exportTask = getExportTaskFromMemory(exportTaskId);

        if exportTask is error {
            http:Response response = new;
            response.statusCode = http:STATUS_BAD_REQUEST;
            response.setPayload(exportTask.message());
            return response;
        }

        if exportTask.lastStatus == "in-progress" {
            return;
        } else if exportTask.lastStatus == "completed" {
            return {
                //todo: check if the start time format here is what the specification exactly needs
                transactionTime: time:utcToString(exportTask.startTime),
                request: exportServiceConfig.fileServerBaseUrl + "/fhir/Patient/$export",
                requiresAccessToken: false,
                outputOrganizedBy: "",
                deleted: [],
                output: exportTask.results,
                'error: exportTask.errors
            };
        }
        //Handles the lastStauts "failed" scenario
        return r4:createFHIRError("Server Error", r4:ERROR, r4:PROCESSING, httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR);
    }

    isolated resource function get [string exportId]/files/[string fileName]() returns http:Response|error {
        string filePath = string `${exportServiceConfig.targetDirectory}/${exportId}/${fileName}`;

        // Create new response
        http:Response response = new;

        // Try to read the file
        byte[]|io:Error fileContent = io:fileReadBytes(filePath);

        if fileContent is io:Error {
            log:printError("Error reading file", fileContent);
            response.statusCode = http:STATUS_NOT_FOUND;
            response.setPayload("File not found");
            return response;
        }

        // Set headers and payload
        response.setHeader("Content-Type", "application/ndjson");
        response.setHeader("Content-Disposition", string `attachment; filename=${fileName}`);
        response.setBinaryPayload(fileContent);

        return response;
    }
}

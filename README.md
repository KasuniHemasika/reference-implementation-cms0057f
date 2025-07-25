# Reference Implementation CMS 0057-F

## Purpose

This repository provides a reference implementation of the CMS 0057-F regulation, demonstrating the integration of Ballerina services with React applications. It serves as a practical example for developers aiming to understand and implement CMS0057F-compliant solutions using these technologies.

## Folder Structure

```
.
├── apps
|   ├── demo-ehr-app
├── cds-service
│   ├── Ballerina.toml
│   ├── Config.toml
│   ├── Dependencies.toml
│   ├── Package.md
│   ├── decision_engine_connector.bal
│   ├── interceptor.bal
│   ├── service.bal
│   └── utils.bal
├── fhir-service
│   ├── Ballerina.toml
│   ├── Config.toml
│   ├── Dependencies.toml
│   ├── api_config.bal
│   ├── conformance.bal
│   ├── constants.bal
│   ├── member_matcher.bal
│   ├── mock_backend.bal
│   ├── oas
│   │   └── OpenAPI.yaml
│   ├── records.bal
│   ├── resources
│   ├── service.bal
│   ├── source_connect.bal
│   └── utils.bal
├── file-service
│   ├── Ballerina.toml
│   ├── Config.toml
│   ├── Dependencies.toml
│   ├── constants.bal
│   ├── inMemoryStorage.bal
│   ├── oas
│   │   └── OpenAPI.yaml
│   ├── records.bal
│   ├── service.bal
│   └── utils.bal```

## Version Information

- **Ballerina**: 2201.12.3
- **Node.js**: 20.11.1

## Running the Ballerina Services

1. **Navigate to the Ballerina Project Directory**:

   ```bash
   cd reference-implementation-cms0057f/fhir-service
   ```

   or

   ```bash
   cd reference-implementation-cms0057f/cds-service
   ```

2. **Run the Ballerina Service**:

   ```bash
   bal run
   ```

   The service will start, typically listening on `http://localhost:9090`.

## Running the React Application

1. **Navigate to the React Application Directory**:

   ```bash
   cd reference-implementation-cms0057f/apps/demo-ehr-app
   ```

2. **Install Dependencies**:

   ```bash
   npm install
   ```

3. **Start the React Application**:

   ```bash
   npm run dev
   ```

   The application will launch in your default browser, usually accessible at `http://localhost:5173/`.

## Additional Notes

- Ensure that both the Ballerina service and the React application are running concurrently to allow seamless interaction between the frontend and backend.
- For detailed information on Ballerina code organization, refer to the official documentation: [Ballerina Documentation](https://ballerina.io/learn/organize-ballerina-code/)
- For insights into structuring React projects, consider this guide: [React Folder Structure](https://blog.webdevsimplified.com/2022-07/react-folder-structure/)

By following this setup, you can explore the integration of Ballerina services with a React frontend, providing a comprehensive understanding of building CMS0057F-compliant applications.

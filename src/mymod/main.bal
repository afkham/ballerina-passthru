import ballerina/http;
import ballerina/log;
import ballerina/docker;

@docker:Config {
  
}

service passthroughService on new http:Listener(9090) {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/"
    }
    resource function passthrough(http:Caller caller, http:Request clientRequest) {
        http:Client nettyEP = new("http://168.62.161.179:8602");
        var response = nettyEP->forward("/", clientRequest);

        if (response is http:Response) {
            var result = caller->respond(<@untainted>response);
        } else {
            log:printError("Error at h1c_h1c_passthrough", <error>response);
            http:Response res = new;
            res.statusCode = 500;
            res.setPayload((<@untainted error>response).message());
            var result = caller->respond(res);
        }
    }
}
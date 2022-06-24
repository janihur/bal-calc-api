import ballerina/mime;
import ballerina/http;

service /calc on new http:Listener(9090) {
    isolated resource function post rpn (http:Caller caller, http:Request request) returns error? {
        do {
            int result = 
                check calculate(
                    check sanitize(
                        check getPayload(request)
                    )
                );

            http:Response r = new;
            check r.setContentType(mime:TEXT_PLAIN);
            r.setTextPayload(result.toString());
            check caller->respond(r);
        } on fail error e {
            return e;
        }
    }
}

import ballerina/http;

isolated function getPayload(http:Request request) returns string|error {
    string contentType = request.getContentType();
    if !contentType.startsWith("text/plain") {
        return error("INVALID_INPUT", message = string`Content type '${contentType}' is not allowed.`);
    }

    string|http:ClientError payload = request.getTextPayload();
    if payload is http:NoContentError {
        return error("INVALID_INPUT", message = string`Empty input is not allowed.`);
    } else if payload is http:ClientError {
        return error("INVALID_INPUT", message = string`Failed to get payload.`);
    } else {
        return payload;
    }
}

isolated function sanitize(string input) returns string|error {
    string trimmedInput = input.trim();
    if trimmedInput.length() == 0 { return error("INVALID_INPUT", message = "Effectively empty input."); }

    // check valid values and filter out extra space
    string output = "";
    boolean spaces = false;
    foreach string item in trimmedInput {
        match item {
            "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|"+"|"-"|"/"|"*" => {
                spaces = false;
                output += item;
            }
            " " => {
                if !spaces {
                    spaces = true;
                    output += item;
                }
            }
            _ => {
                return error("INVALID_INPUT", message = string`Character '${item}' is not allowed.`);
            }
        }
    }

    return output;
}

// Assumes valid input
isolated function calculate(string input) returns int|error {
    string[] input2 = split(input, " ");
    int[] stack = [];
    foreach var char in input2 {
        match char {
            "+" => {
                int operand2 = stack.pop();
                int operand1 = stack.pop();
                int result = operand1 + operand2;
                stack.push(result);
            }
            "-" => {
                int operand2 = stack.pop();
                int operand1 = stack.pop();
                int result = operand1 - operand2;
                stack.push(result);
            }
            "/" => {
                int operand2 = stack.pop();
                int operand1 = stack.pop();
                int result = operand1 / operand2;
                stack.push(result);
            }
            "*" => {
                int operand2 = stack.pop();
                int operand1 = stack.pop();
                int result = operand1 * operand2;
                stack.push(result);
            }
            _ => { 
                int n = check 'int:fromString(char);
                stack.push(n);
            }
        }
    }
    return stack.pop();
}

import ballerina/test;

function test_sanitize_datagen() returns map<[string, string]> {
    return {
         test1: ["1 1 +", "1 1 +"]
        ,test2: ["  1   1   +  ", "1 1 +"]
    };
}

@test:Config{ dataProvider: test_sanitize_datagen }
function test_sanitize(string input, string expected) {
    string|error got = sanitize(input);
    test:assertTrue(got is string);
    if got is string {
        test:assertEquals(got, expected);
    }
}

function test_calculate_datagen() returns map<[string, int]> {
    return {
         add1: ["1 1 +",         2] // 1 + 1
        ,add2: ["1 1 + 1 1 + +", 4] // (1 + 1) + (1 + 1)
        ,minus1: ["3 4 -",          -1] // 4 - 3
        ,minus2: ["3 10 - 3 10 - -", 0] // (10 - 3) - (10 - 3)
    };
}

@test:Config { dataProvider: test_calculate_datagen }
function test_calculate(string input, int expected) {
    int|error got = calculate(input);
    test:assertTrue(got is int);
    if got is int {
        test:assertEquals(got, expected);
    }
}
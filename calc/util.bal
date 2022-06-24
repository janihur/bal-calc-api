isolated function concat(string[] a, string[] b) returns string[] {
    var c = a.clone();
    foreach var item in b {
        c.push(item);
    }
    return c;
}

isolated function cut(string value, string separator = ",") returns ([string, string]) {
    int? cutIndex = value.indexOf(separator, 0);
    if cutIndex is int {
        int separatorLength = separator.length();
        string head = value.substring(0, cutIndex);
        string tail = value.substring(cutIndex + separatorLength);
        return [head, tail];
    } else {
        return [value, ""];
    }
}

isolated function split(string value, string separator = ",") returns string[] {
    string[] accu = [];
    var [head, tail] = cut(value, separator);
    accu.push(head);
    if tail.length() > 0 {
        accu = concat(accu, split(tail, separator));
    }
    return accu;
}

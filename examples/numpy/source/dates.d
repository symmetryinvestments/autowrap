import std.datetime;


DateTime incYear(DateTime dateTime, int diff) {
    return DateTime(dateTime.year + diff, dateTime.month, dateTime.day,
                    dateTime.hour, dateTime.minute, dateTime.second);
}

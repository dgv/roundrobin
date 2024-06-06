# roundrobin

### usage
`zig fetch -save https://github.com/dgv/master/head/master.tar.gz`

```zig
const print = @import("std").debug.print;
const roundrobin = @import("roundrobin");

pub fn main() !void {
    var ips = [_]std.net.Address{
        try std.net.Address.parseIp("100.123.10.20", 0),
        try std.net.Address.parseIp("100.123.20.30", 0),
        try std.net.Address.parseIp("100.123.40.50", 0),
        try std.net.Address.parseIp("100.123.60.70", 0),
    };
    const rr = try RoundRobin.init(&ips);
    _ = rr.next(); // "100.123.10.20"
    _ = rr.next(); // "100.123.20.30"
    _ = rr.next(); // "100.123.40.50"
    _ = rr.next(); // "100.123.60.70"
    _ = rr.next(); // "100.123.10.20"
    print("{s}\n", .{rr.next().host} ); // "100.123.20.30"
}
```

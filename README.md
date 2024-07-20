# roundrobin

### usage
`zig fetch -save https://github.com/dgv/roundrobin/archive/refs/heads/main.zip`

```zig
const print = @import("std").debug.print;
const roundrobin = @import("roundrobin").RoundRobin;

pub fn main() !void {
    var ips = [_]std.net.Address{
        try std.net.Address.parseIp("100.123.10.20", 0),
        try std.net.Address.parseIp("100.123.20.30", 0),
        try std.net.Address.parseIp("100.123.40.50", 0),
        try std.net.Address.parseIp("100.123.60.70", 0),
    };
    const rr = try roundrobin.init(&ips);
    _ = rr.next(); // "100.123.10.20:0"
    _ = rr.next(); // "100.123.20.30:0"
    _ = rr.next(); // "100.123.40.50:0"
    _ = rr.next(); // "100.123.60.70:0"
    _ = rr.next(); // "100.123.10.20:0"
    print("{?}\n", .{rr.next()} ); // "100.123.20.30:0"
}
```

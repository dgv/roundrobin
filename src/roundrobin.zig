const std = @import("std");
const testing = std.testing;

const RoundRobinError = error{
    NotExists,
};

pub const RoundRobin = struct {
    const Self = @This();
    ips: []std.net.Address = undefined,
    var atomic: u32 = undefined;

    pub fn init(ips: []std.net.Address) RoundRobinError!RoundRobin {
        if (ips.len == 0) {
            return RoundRobinError.NotExists;
        }
        return .{ .ips = ips };
    }
    pub fn next(self: Self) std.net.Address {
        @atomicStore(u32, &atomic, atomic + 1, .release);
        const n = atomic;
        return self.ips[(n - 1) % self.ips.len];
    }
};

test "roundrobin test" {
    var ips = [_]std.net.Address{
        try std.net.Address.parseIp("100.123.10.20", 0),
        try std.net.Address.parseIp("100.123.20.30", 0),
        try std.net.Address.parseIp("100.123.40.50", 0),
        try std.net.Address.parseIp("100.123.60.70", 0),
    };
    const rr = try RoundRobin.init(&ips);
    _ = rr.next();
    _ = rr.next();
    _ = rr.next();
    _ = rr.next();
    _ = rr.next();
    const lastIP = rr.next();
    std.testing.expect(std.net.Address.eql(lastIP, try std.net.Address.parseIp("100.123.20.30", 0))) catch {
        std.debug.print("got unexpected ip {?}", .{lastIP});
    };
}
